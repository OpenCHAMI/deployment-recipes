# Self-contained OpenCHAMI demo environment

These instructions cover creation of a local self-contained OpenCHAMI test
cluster and Redfish-managed VM using [KinD](https://kind.sigs.k8s.io/) and
[KubeVirt](https://kubevirt.io/).

## Runbook

### Cluster creation

I create my KinD clusters using the [ktf wrapper](https://github.com/Kong/kubernetes-testing-framework),
mostly to provide a convenient metallb install and network configuration:

```
ktf env create --name test --addon metallb
```

https://mauilion.dev/posts/kind-metallb/ describes the manual steps for the
metalb install and creation of an IPAddressPool appropriate for your KinD
Docker network.

### Supporting infrastructure installation

Install cert-manager and ArgoCD:

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

I'd originally included cert-manager as part of the virtual machine
Application, but for some reason Argo was unable to recognize its webhook
certificate, preventing it from deploying Certificate resources.

### Configure Argo access

From the [Argo _Getting Started_ guide](https://argo-cd.readthedocs.io/en/stable/getting_started/),
change the admin Service to a LoadBalancer and set up your account:

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Retrieve the Service external IP and initial password:

```
kubectl get svc -n argocd argocd-server -ojson | jq .status.loadBalancer.ingress[0].ip -r
172.19.128.1
```

```
argocd admin initial-password -n argocd
```

Log in using the initial password:

```
argocd login 172.19.128.1
```

Update the password to something else:

```
argocd account update-password
```

You'll now be able to log in to the web UI at https://172.19.128.1/ (the
username is `admin`). This guide will use the CLI to create and sync
Applications, but the UI's useful for seeing the status of managed resources.

### Set up a private repository

ArgoCD is a pure GitOps CD implementation. Outside of content in the
Application manifests, resources must be available in a git repository.

This repository seeks to include generic manifests that can be applied in any
environment, and does not include site-local configuration or secrets.

You'll need to create your own private fork of https://github.com/rainest/openchami-kustomize-local
to hold your overlay.

In your fork:

1. Change `remote/services/app.yaml` and `remote/test-node/app.yaml` to use
   your fork in `spec.source.repoURL`.
1. Edit `remote/services/kustomization.yaml` to set your DB passwords
   under the `secretGenerator` section.
1. Edit `remote/test-node/userdata` to set an SSH key and hashed password for
   the virtual machine.

Create a deploy key (for [GitLab](https://docs.gitlab.com/user/project/deploy_keys/)
or [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys))
and configure Argo to use it

```
argocd repo add https://github.com/myuser/myfork --username myuser ----ssh-private-key-path /path/to/key
```

### Create applications

From your fork checkout directory:

```
kubectl apply -n argocd -f test-node/app.yaml
kubectl apply -n argocd -f services/app.yaml
```

### Deploy the virtual machine

The `virt-env` Application deploys KubeVirt, a virtual machine (`fred`), an SSH
access Service, and a [Redfish emulator](https://github.com/rainest/kubevirtbmc)
that can interact with KubeVirt power control.

There's a remaining rough edge deploying KubeVirt that requires a workaround:
the KubeVirt operator wants to manage creation of KubeVirt CRDs, and I did not
find a standalone CRD manifest. This takes a few seconds, and Argo's attempts
to deploy CRs using those CRDs will fail if run in a single sync.

Although the Application does deploy the VirtualMachine resource in a
[wave](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/) after
the operator, there's no guarantee the operator will have deployed the CRDs
first. There's also often a delay before CRD webhooks are ready.

Allowing retries gets past this pending some better means of blocking on CRD
availability:

```
argocd app sync --retry-limit 2 argocd/virt-env
```

#### Accessing the VM

The virtual machine will take a while to become ready, as it needs to download
its disk image first. It will eventually transition to `Running`:

```
15:03:00-0700 baqytgul $ kubectl get virtualmachine
NAME   AGE    STATUS               READY
fred   115s   ErrorUnschedulable   False
```

When the VM reaches `Running`, you can SSH into it using the key you set in
the `userdata` file:

```
VM=$(kubectl get svc sshvm -ojson | jq .status.loadBalancer.ingress[0].ip -r); ssh -i /path/to/private/key fred@$VM
```

Note that KubeVirt does not appeart to re-run cloud-init after initial
provisioning: while cloud-init docs indicate SSH keys and passwords update on
each boot, that does _not_ apply to KubeVirt VMs. You must `kubectl delete
virtualmachine fred` and re-sync the Application if you need to update
credentials.

#### Interacting with Redfish

These manifests deploy a [modified version](https://github.com/rainest/kubevirtbmc/tree/smd-compat)
of the [original upstream KubeVirt BMC](https://github.com/starbops/kubevirtbmc/tree/main)
to support basic auth on all endpoints and to provide power action metdata.

You can change the BMC Service to a LoadBalancer, and then interact with it
directly via cURL:

```
kubectl patch svc -n kubevirtbmc-system default-fred-virtbmc -p '{"spec": {"type": "LoadBalancer"}}'
```

```
BMC=$(kubectl get svc -n kubevirtbmc-system default-fred-virtbmc -ojson | jq .status.loadBalancer.ingress[0].ip -r); curl -svX POST \
  -H "Content-Type: application/json" -u admin:password \
  http://172.19.128.4/redfish/v1/Systems/1/Actions/ComputerSystem.Reset \
  -d '{"ResetType":"ForceRestart"}'
```

### Deploying OpenCHAMI

The `openchami` Application deploys [CloudNativePG](https://cloudnative-pg.io/),
SMD, BSS, and PCS. The service databases will block on CNPG CRD availability
and need to be synced with retries:

```
argocd app sync --retry-limit 2 argocd/openchami
```

#### Adding the machine to SMD

The emulated BMC is unfortunately less complete than proper hardware BMCs, and
lacks Redfish endpoints that the [OpenCHAMI discovery tool](https://github.com/OpenCHAMI/magellan)
needs. We can hopefully improve this, but for now it's easiest to manually
enter machine details.

Released versions of the CLI manual discovery lack support for some information
that PCS needs. Pending approval and release of
https://github.com/OpenCHAMI/ochami/pull/47 and https://github.com/OpenCHAMI/ochami/pull/51
this uses yet another custom build:

```
go install github.com/rainest/ochami@v0.6.0-beta-pcs
```

Somewhat amusingly, PCS doesn't actually make use of almost any of the
information in the fake discovery manifest--it doesn't care about much anything
other than the xname, and the remaining fields can be entirely garbage:

```
echo 'nodes:
-   bmc_ipaddr: 10.49.186.68
    bmc_fqdn: default-fred-virtbmc.kubevirtbmc-system
    ipaddr: 10.119.4.198
    group: dfddfdffdsdf
    mac: "5e:72:59:e4:6a:a8"
    name: ba019
    nid: 1
    xname: x1000c0s0b0n0
    interfaces:
    - mac_addr: f4:a2:2e:ee:9e:f8
      ip_addrs:
      - name: internal
        ip_addr: 10.143.0.199' > /tmp/node.yaml
```

```
SMD=$(kubectl get svc -n mgmt smd -ojson | jq .status.loadBalancer.ingress[0].ip -r);
PCS=$(kubectl get svc -n mgmt pcs -ojson | jq .status.loadBalancer.ingress[0].ip -r);
echo "default-cluster: bazfoo
clusters:
    - name: bazfoo
      cluster:
        smd:
          uri: http://$SMD:27779/hsm/v2/
        pcs:
          uri: http://$PCS/v1/" > /tmp/ochami-demo.yaml
```

Recent additions to skip auth are also not quite in yet, so you'll need a
pretend credential to use the CLI:

```
export BAZFOO_ACCESS_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE3ODYyMTkxNTZ9.XZ2Imn0IQc5JMmOmsyexESKdc3cHkUMt2suhmymO3RY"
```

```
ochami --config /tmp/ochami-demo.yaml -v discover static -f yaml --overwrite -d @/tmp/node.yaml
```

This will complain about a bad interface address, but it will still create the
SMD entry the demo needs.

```
ochami --config /tmp/ochami-demo.yaml smd compep get | jq
```

will look something like

```
{
  "ComponentEndpoints": [
    {
      "ComponentEndpointType": "ComponentEndpointComputerSystem",
      "Enabled": true,
      "ID": "x1000c0s0b0n0",
      "OdataID": "/redfish/v1/Systems/x1000c0s0b0n0",
      "RedfishEndpointFQDN": "x1000c0s0b0",
      "RedfishEndpointID": "x1000c0s0b0",
      "RedfishSubtype": "",
      "RedfishSystemInfo": {
        "Actions": {
          "#ComputerSystem.Reset": {
            "@Redfish.ActionInfo": "/redfish/v1/Systems/x1000c0s0b0n0/ResetActionInfo",
            "ResetType@Redfish.AllowableValues": [
              "On",
              "ForceOff",
              "GracefulShutdown",
              "GracefulRestart",
              "ForceRestart",
              "Nmi",
              "ForceOn",
              "PushPowerButton",
              "PowerCycle",
              "Suspend",
              "Pause",
              "Resume"
            ],
            "target": "/redfish/v1/Systems/x1000c0s0b0n0/Actions/ComputerSystem.Reset"
          }
        },
        "EthernetNICInfo": [
          {
            "@odata.id": "",
            "Description": "Interface 0 for ba019",
            "InterfaceEnabled": true,
            "MACAddress": "f4:a2:2e:ee:9e:f8",
            "RedfishId": ""
          }
        ],
        "Name": "ba019"
      },
      "RedfishType": "ComputerSystem",
      "RedfishURL": "x1000c0s0b0/redfish/v1/Systems/x1000c0s0b0n0",
      "Type": "Node",
      "UUID": "fe167d38-a09b-4650-92b3-1abbc2182e14"
    }
  ]
}
```

#### Initiaing a power transition

The cluster now has everything it needs to handle turning a machine off and on
again. This doesn't look very exciting from the CLI alone, so you'll want to
SSH into the VM first to see it in action.

```
ochami --config /tmp/ochami-demo.yaml pcs transition start --xname "x1000c0s0b0n0" hard-restart
```

It doesn't look very exciting from within the machine either, but it's at least
more ready feedback than the CLI provides--PCS actions are asynchronous, so the
CLI only confirms it's submitted the request, and doesn't know if it'll
succeed.

You can watch the transition proceed through the CLI, but getting kicked out of
the machine is more visceral proof:

```
ochami --config ~/.config/ochami/demo pcs transition monitor f8579afb-2843-417c-9bff-65135c0765a3
```

However, something's broken re API compatibility and while `transition start`
works, `transition show` and `transition list` have started 404ing. Pending
investigation of that, you can check the VM to see that it's restarting:

```
$ kubectl get virtualmachine
NAME   AGE   STATUS    READY
fred   50m   Stopped   False

$ kubectl get virtualmachine
NAME   AGE   STATUS     READY
fred   51m   Starting   False
```
