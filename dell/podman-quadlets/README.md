# OpenCHAMI with Podman Quadlets
This Doc is a very brief tutorial on how to deploy OpenCHAMI with the podman-quadlets recipe.  
This won't get a full production system running but should give you an idea of how to get started in that direction.

## Assumptions

### A running OS
I think we all know how to install a linux OS on a machine at this point.
This has been currently tested on RHEL10.0 and it's cousins. 

### Config Management
We'll go over some config management, but it will not be a full system deployment. Anything beyond basic booting functions will not be covered

### Cluster Images
OpenCHAMI doesn't provide an image build system. It relies on external images being available.  
We'll go over how we are building images locally but they won't be full production-like images

## Prep
Some stuff we need before we start deploying OpenCHAMI

### Package installs
```bash
dnf install -y ansible-core git podman jq
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
pip3 install jmespath
```

### Setup hosts
Clusters generally have names. This cluster is named `demo` and the shortname for our nodes is `nid`. Feel free to be creative on your own time.  
The BMCs are named `<shortname>-bmc`. 
Make your `/etc/hosts` look something like
```bash
172.16.0.254    demo.openchami.cluster
172.16.0.1      nid001
172.16.0.2      nid002
172.16.0.3      nid003
172.16.0.4      nid004
172.16.0.5      nid005
172.16.0.6      nid006
172.16.0.7      nid007
172.16.0.8      nid008
172.16.0.9      nid009
172.16.0.101    nid-bmc001
172.16.0.102    nid-bmc002
172.16.0.103    nid-bmc003
172.16.0.104    nid-bmc004
172.16.0.105    nid-bmc005
172.16.0.106    nid-bmc006
172.16.0.107    nid-bmc007
172.16.0.108    nid-bmc008
172.16.0.109    nid-bmc009
```

## OpenCHAMI microservices
OpenCHAMI is a long acronym for something that is probably a lot more simple than you would expect. OpenCHAMI is ostensibly based on CSM but really we took SMD and BSS and that's about it. 

### SMD
State Management Database (SMD), at least that is what I think SMD stands for, is a set of APIs that sit in front of a Postgres database. SMD does a lot more in CSM than it does in OpenCHAMI. There is no hardware discovery happening in SMD and we don't use it for holding the state of anything. SMD is simply an API that talks to a database that holds component information. The components here are Nodes, BMCs, and Interface data. 
In OpenCHAMI SMD does not actively do anything and is a repository of information on the system hardware. 
### BSS
BootScript Service (BSS) is a service that provides on demand iPXE scripts to nodes during the netboot process. It talks to SMD to confirm the requesting node exists and if so it returns a generated iPXE script based on the data it holds about that node. 
### Cloud-init
We wrote a custom cloud-init server that does some things similar to BSS. It will process the requesting nodes IP and find the component and/or group information, then build the cloud-init configs from there. Cloud-init data is populated externally. OpenCHAMI does not provide the actual configs only a way to push out the configs. 

### opaal and Hydra
#### Hydra
[Hydra](https://github.com/ory/hydra) is an oauth provider but it does not manage logins or user accounts etc. We use Hydra to create and hand out JWTs.

### opaal
Opaal is a toy OIDC provider. You make a request to opaal and it makes a JWT request to hydra, then hands that back to the "user". It's a pretend login service.

Hydra is something that will probably stick around for a while as we use it as the authorization server. opaal is a stand in service that will probably get replaced, hopefully soon.
So I wouldn't worry too much about opaal.
### ACME and step-ca
Automatic Certificate Management Environemnt or ACME is what we use to automate CA cert renewals. This is so you don't have that special day every year when all your certificates expire and you have to go renew them and it's annoying. Now you have to renew them everyday! but it should be "automatic" and much easier. I say that but we only issue a single cert at the moment, so time will tell. We use [acme.sh](https://github.com/acmesh-official/acme.sh) to generate certs from a certificate authority. 

[step-ca](https://smallstep.com/docs/step-ca/) is the certificate authority we use to generate CA certs. 
### haproxy
HAproxy acts our API gateway. It's what allows outside requests to reach into the container network and talk to various OpenCHAMI services. 
### postgres
We use postgres as the backend for BSS, SMD, and Hydra. It's just a postgres database in a container. 

## OpenCHAMI adjacent techonologies
OpenCHAMI doesn't exist in a vacuum. There are parts of deploying OpenCHAMI that are not managed by OpenCHAMI. 
We'll cover some of these briefly. Very Briefly. 

### DHCP and iPXE and Dracut
These are all important parts of the boot process. 

#### DHCP
DHCP is all over the place so I'm not gonna go over what DHCP is. OpenCHAMI provides a [CoreDHCP](https://github.com/coredhcp/coredhcp) plugin called [coresmd](https://github.com/OpenCHAMI/coresmd). This links up with SMD to build out the config files and also provides TFTP based on the nodes architecture. This allows us to boot many types of systems.

#### iPXE
iPXE is also something we should all be familiar with. OpenCHAMI interacts with iPXE via BSS, as explained above, but does not control the entire workflow.

We continue to use iPXE because it is in all firmware at this point. HTTP booting is becoming more popular but not all vendors are building that into their firmware just yet. 

#### Dracut
OpenCHAMI doesn't directly interact with the dracut init stage, but we can insert parameters into BSS that can have an effect here. 
One example is NFS provided rootfs. 

## Deploying OpenCHAMI  
First pull down the deployment-recipes repo from the OpenCHAMI GitHub.
```bash
git clone https://github.com/OpenCHAMI/deployment-recipes.git
```
Go to the cloned repo and the LANL podman-quadlets recipes
```bash
cd deployment-recipes/dell/podman-quadlets
```
Here will have to make some local changes that match your system

### Setup the inventory
The inventory is a single node so just change `inventory/01-ochami` and set
```ini
[ochami]
localhost ansible_connection=local
```
To be the value of `hostname` (demo-head.si.usrc in this case).

### Set cluster names
Update below variables in `inventory/group_vars/ochami/cluster.yaml` as per your cluster and requirements.
```yaml
cluster_name: "demo"
cluster_shortname: "nid"
cluster_nidlength: 3
cluster_domain: "openchami.cluster"
cluster_boot_ip: 172.16.0.254
cluster_boot_interface: ens259f0
rhel_tag: 10.0
rhel_repos:
  - { name: 'RHEL10_BaseOS', url: '', gpg: '' }
  - { name: 'RHEL10_AppStream', url: '', gpg: '' }
```

### Update the dhcp configuration
Update netmask and dhcp dynamic range in `inventory/group_vars/ochami/coredhp.yaml` as per your cluster.
```yaml
coredhcp_netmask: '255.255.255.0'
coredhcp_dhcp_pool: '172.16.0.200 172.16.0.250'
```
### Populate nodes
Now we need to populate `inventory/group_vars/ochami/nodes.yaml`. This describes your cluster in a flat yaml file. 
It will look something like:
```yaml
nodes:
- name: nid001
  xname: x1000c1s7b1n0
  nid: 1
  group: compute
  bmc_mac: c2:77:05:e2:03:48
  bmc_ip: 172.16.0.101
  interfaces:
  - mac_addr: ec:e7:a7:05:a1:fc
    ip_addrs:
    - name: management
      ip_addr: 172.16.0.1
```

### Running the OpenCHAMI playbook
Almost done. Run the provided playbook:
```bash
ansible-playbook -i inventory ochami_playbook.yaml
```

Should take a minute or two to start everything and populate the services.  
At the end you should have these containers running:
```bash
# podman ps --noheading | awk '{print $NF}' | sort
bss
cloud-init-server
coresmd
haproxy
hydra
image-server
opaal
opaal-idp
postgres
smd
step-ca
```

### Verifying things look OK

Ansible will install a CLI tool called `ochami`.  
This tool comes with manual pages. See **ochami**(1) for more.

Let's take a look at our config to make sure things are set correctly:
```bash
ochami config show
```
It should look like this:
```yaml
clusters:
    - cluster:
        uri: https://demo.openchami.cluster:8443
      name: demo
default-cluster: demo
log:
    format: basic
    level: warning
```

Now, we need to generate a token for the "demo" cluster. `ochami` reads this
from `<CLUSTER_NAME>_ACCESS_TOKEN` where `<CLUSTER_NAME>` is the configured name
of the cluster in all capitals. This is `DEMO` in our case. Let's set the token:
```bash
export DEMO_ACCESS_TOKEN=$(gen_access_token)
```

Check SMD is populated with `ochami smd component get | jq`
```json
{
  "Components": [
    {
      "Enabled": true,
      "ID": "x1000c1s7b1",
      "Type": "Node"
    },
    {
      "Enabled": true,
      "Flag": "OK",
      "ID": "x1000c1s7b1n0",
      "NID": 1,
      "Role": "Compute",
      "State": "On",
      "Type": "Node"
    },
    {
      "Enabled": true,
      "ID": "x1000c1s7b2",
      "Type": "Node"
    },
    {
      "Enabled": true,
      "Flag": "OK",
      "ID": "x1000c1s7b2n0",
      "NID": 2,
      "Role": "Compute",
      "State": "On",
      "Type": "Node"
    },
    ...
]
```
You should see:
```json
    {
      "Enabled": true,
      "ID": "x1000c1s7bN",
      "Type": "Node"
    },
    {
      "Enabled": true,
      "Flag": "OK",
      "ID": "x1000c1s7bNn0",
      "NID": 1,
      "Role": "Compute",
      "State": "On",
      "Type": "Node"
    },
```
for each `N` (in the xname) from 1-9, inclusive.

Check BSS is populated with `ochami bss boot params get | jq`
```json
[
  {
    "cloud-init": {
      "meta-data": null,
      "phone-home": {
        "fqdn": "",
        "hostname": "",
        "instance_id": "",
        "pub_key_dsa": "",
        "pub_key_ecdsa": "",
        "pub_key_rsa": ""
      },
      "user-data": null
    },
    "initrd": "http://172.16.0.254:8080/openchami/compute-slurm/latest/initramfs-4.18.0-553.27.1.el8_10.x86_64.img",
    "kernel": "http://172.16.0.254:8080/openchami/compute-slurm/latest/vmlinuz-4.18.0-553.27.1.el8_10.x86_64",
    "macs": [
      "ec:e7:a7:05:a1:fc",
      "ec:e7:a7:05:a2:28",
      "ec:e7:a7:05:93:84",
      "ec:e7:a7:02:d9:90",
      "02:00:00:a8:4f:04",
      "ec:e7:a7:05:96:74",
      "02:00:00:97:c4:2e",
      "ec:e7:a7:05:93:48",
      "ec:e7:a7:05:9f:50"
    ],
    "params": "root=live:http://172.16.0.254:8080/openchami/compute-slurm/latest/rootfs-4.18.0-553.27.1.el8_10.x86_64 ochami_ci_url=http://172.16.0.254:8081/cloud-init/ ochami_ci_url_secure=http://172.16.0.254:8081/cloud-init-secure/ overlayroot=tmpfs overlayroot_cfgdisk=disabled nomodeset ro ip=dhcp apparmor=0 selinux=0 console=ttyS0,115200 ip6=off network-config=disabled rd.shell"
  }
]
```
We'll have to update these values later when we build a test image. But for now we can see that it is at least working...

Cloud-init should have some data added. You can check with `ochami cloud-init defaults get | jq`. You should see something like:
```json
{
  "base-url": "http://10.0.0.1:27777/cloud-init",
  "cluster-name": "demo",
  "nid-length": 3,
  "public-keys": [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDs70I2ROK/zl9+zVxXTAo+I0vtaNrvViXKQMcqihGvdmCghlcK9P54KBaj3fgh5MGCv+1dxHTWwJmQvw8naw2t+lRpVsdCmGhkXkf6UMgRWJnGxfWWMha7g54Uk16zvbYJi/MKes0pkWLdNsFwpKDKbUi2syvtoEpgpsw4Tc6ayk6S+CxLE+eZVMKbTTaWXoI91KooZAUHTIKSyP61I9/LBD8yWvA4hJirrAhVHezcvn1Jflc7/Rbs75r6jj2yp74a7gsbAxlkj2Ls7o4rMeXJ+Z4lg6qsNwEEan8sSpbNbCjyeOULU0jbigEyh2BxmWR/sQu9TUeHmIgZxOMLxoKX7tKjMudq8ArCIT3W4u1dlWkuhBrzqwQxpTmewIhQot5sVeuc7wO//w4Jw1LteKVc7NXw78bPWhbi/UERNo65/GcBa7vMaAJ4a97xm6ssFRO9UJy/q6X1Y+2+6F/RJ5lxaDxiKygzjZZiRfAWwV+K+Lp0GMysdO6nYwbUAqoHsGs= root@st-head.si.usrc"
  ],
  "short-name": "nid"
}
```


## Booting nodes
PXE boot the nodes manually to verify the OS installation.

## To cleanup OpenCHAMI installation
Run the provided playbook:
```bash
ansible-playbook -i inventory ochami_cleanup.yaml
```
