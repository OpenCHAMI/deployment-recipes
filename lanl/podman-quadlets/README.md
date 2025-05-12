# Ochami Bootcamp
This Doc is a very brief tutorial on how to deploy OpenCHAMI with the podman-quadlets recipe.  
This won't get a full production system running but should give you an idea of how to get started in that direction.

## Assumptions

### A running OS
I think we all know how to install a linux OS on a machine at this point.
This has been currently tested on RHEL8.10 and it's cousins. 

### Config Management
We'll go over some config management, but it will not be a full system deployment. Anything beyond basic booting functions will not be covered

### Cluster Images
OpenCHAMI doesn't provide an image build system. It relies on external images being available.  
We'll go over how we are building images locally but they won't be full production-like images

## Prep
Some stuff we need before we start deploying OpenCHAMI

### Package installs
```bash
dnf install -y ansible git podman jq
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

### powerman + conman
Install the things
```bash
dnf install -y powerman conman jq
```
Configure `/etc/powerman/powerman.conf`, remember your cluster shortnames. User/Password should be the same on all systems
```bash
include "/etc/powerman/ipmipower.dev"

device "ipmi0" "ipmipower" "/usr/sbin/ipmipower -D lanplus -u admin -p Password123! -h nid-bmc[001-009] -I 17 -W ipmiping |&"
node "nid[001-009]" "ipmi0" "nid-bmc[001-009]"
```
Start and enable powerman:
```bash
systemctl start powerman
systemctl enable powerman
```
Then Check to make sure you can see the power state of the nodes
```bash
pm -q
```

Conman is next. Configure your `/etc/conman.conf`. You may have to zero out that file first.
Should look something like the below, with your cluster shortname in place.
```bash
SERVER keepalive=ON
SERVER logdir="/var/log/conman"
SERVER logfile="/var/log/conman.log"
SERVER loopback=ON
SERVER pidfile="/var/run/conman.pid"
SERVER resetcmd="/usr/bin/powerman -0 %N; sleep 5; /usr/bin/powerman -1 %N"
SERVER tcpwrappers=ON

GLOBAL seropts="115200,8n1"
GLOBAL log="/var/log/conman/console.%N"
GLOBAL logopts="sanitize,timestamp"

# Compute nodes
CONSOLE name="nid001" dev="ipmi:nid-bmc001" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid002" dev="ipmi:nid-bmc002" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid003" dev="ipmi:nid-bmc003" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid004" dev="ipmi:nid-bmc004" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid005" dev="ipmi:nid-bmc005" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid006" dev="ipmi:nid-bmc006" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid007" dev="ipmi:nid-bmc007" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid008" dev="ipmi:nid-bmc008" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
CONSOLE name="nid009" dev="ipmi:nid-bmc009" ipmiopts="U:admin,P:Password123!,C:17,W:solpayloadsize"
```
Then start and enable `conman`
```bash
systemctl start conman
systemctl enable conman
```

At this point you can test powering on a node and check that conman is working
```bash
pm -1 nid001
conman nid001
```
You should at least see console output, but it won't boot just yet...


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
cd deployment-recipes/lanl/podman-quadlets
```
Here will have to make some local changes that match your system

### Setup the inventory
The inventory is a single node so just change `inventory/01-ochami` and set
```ini
[ochami]
demo-head.si.usrc
```
To be the value of `hostname` (demo-head.si.usrc in this case).

### Set cluster names
Pick a cluster name and shortname. These examples use `demo` and `nid` respectively.  
These are set in `inventory/group_vars/ochami/cluster.yaml`
```yaml
cluster_name: "demo"
cluster_shortname: "nid"
```

### Setup a private SSH key pair
Generate an SSH key pair if one doesn't exist
```bash
ssh-keygen
```
Just hit enter 'til you get the prompt back.  
Now we take the contents of `~/.ssh/id_rsa.pub` and set it in our inventory.  
In `inventory/group_vars/ochami/cluster.yaml`
```yaml
cluster_boot_ssh_pub_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZW66ja<snip> = root@st-head'
```
 Replace what is there with what `ssh-keygen` created. Make sure it is the pub key. 

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

#### Getting the MACs
We are gonna grab the MACs from redfish. 
Make a script `gen_nodes_file.sh` (and you guys are gonna be so impressed)
```bash
#!/bin/bash
nid=1
SN=${SN:-nid}
if [ -z "$rf_pass" ]
then
        >&2 echo 'ERROR: rf_pass not set, needed for BMC credentials'
        exit 1
fi
echo "nodes:"
for i in {1..9}
do
        # NIC MAC Address
        NDATA=$(curl -sk -u "$rf_pass" https://172.16.0.10${i}/redfish/v1/Chassis/FCP_Baseboard/NetworkAdapters/Nic259/NetworkPorts/NICChannel0)
        if [[ $? -ne 0 ]]
        then
                >&2 echo "172.16.0.10${i} unreachable, generating a random MAC"
                NRMAC=$(printf '02:00:00:%02x:%02x:%02x\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
                NDATA="{\"AssociatedNetworkAddresses\": [\"$NRMAC\"]}"
        fi
        NIC_MAC=$(echo $NDATA | jq -r '.AssociatedNetworkAddresses|.[]')

        # BMC MAC Address
        BDATA=$(curl -sk -u "$rf_pass" https://172.16.0.10${i}/redfish/v1/Managers/bmc/EthernetInterfaces/eth0)
        if [[ $? -ne 0 ]]
        then
                >&2 echo "Could not find BMC MAC address for for node with IP 172.16.0.${i}, generating a random one"
                BRMAC=$(printf '02:00:00:%02x:%02x:%02x\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
                BDATA="{\"MACAddress\": \"$BRMAC\"}"
        fi
        BMC_MAC=$(echo $BDATA | jq .MACAddress | tr -d '"')

        # Print node config
        echo "- name: ${SN}00${i}
  xname: x1000c1s7b${i}n0
  nid: ${nid}
  group: compute
  bmc_mac: ${BMC_MAC}
  bmc_ip: 172.16.0.10${i}
  interfaces:
  - mac_addr: ${NIC_MAC}
    ip_addrs:
    - name: management
      ip_addr: 172.16.0.${i}"

        nid=$((nid+1))
done
```
Set the follow variables
```bash
export SN=<cluster-shortname>
export rf_pass="admin:Password123!"
``` 
Then `chmod +x gen_nodes_file.sh` and run it
```bash
gen_nodes_file.sh > nodes.yaml
```
If a node's BMC does not respond it will generate a MAC address, You can fix it later. 
You can then copy that to your ansible inventory (and replace the nodes.yaml that is there).

### Running the OpenCHAMI playbook
Almost done. Run the provided playbook:
```bash
ansible-playbook -l $HOSTNAME -c local -i inventory ochami_playbook.yaml
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
The playbook created a profile script `/etc/profile.d/ochami.sh`. So unless you logout and back in you'll be missing some ENV settings. You can also just `source /etc/profile.d/ochami.sh` without logging out. 

Create a CA cert
```bash
get_ca_cert > /etc/pki/ca-trust/source/anchors/ochami.pem
update-ca-trust 
```
The cert will expire in 24 hours. You can regenerate certs with
```bash
systemctl restart acme-deploy
systemctl restart acme-register
systemctl restart haproxy
```
This would go great in a cron job.

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

### Building a test image
We'll build a test image real quick to boot into. Won't be anything special.

First install `buildah`
```bash
dnf install -y buildah
```
Create a blank container
```bash
CNAME=$(buildah from scratch)
```
Mount it 
```bash
MNAME=$(buildah mount $CNAME)
```
Install some base packages
```bash
dnf groupinstall -y --installroot=$MNAME --releasever=8 "Minimal Install"
```
Install the kernel and some need dracut stuff:
```bash
dnf install -y --installroot=$MNAME kernel dracut-live fuse-overlayfs cloud-init
```
Then rebuld the initrd so that during dracut it will download the image and mount the rootfs as an in memory overlay
```bash
buildah run --tty $CNAME bash -c ' \
    dracut \
    --add "dmsquash-live livenet network-manager" \
    --kver $(basename /lib/modules/*) \
    -N \
    -f \
    --logfile /tmp/dracut.log 2>/dev/null \
    '
```
Then commit it
```bash
buildah commit $CNAME test-image:v1
```
While we're here we'll get the initrd, vmlinuz, and build a rootfs to boot from. 
We have a container that holds all three of these items we just need to pull them out. 

Setup a directory to store these. We'll use an nginx container to serve these out later on.
```bash
mkdir -p /data/domain-images/openchami/rocky/test
```

Get the kernel version of the image
```bash
KVER=$(ls $MNAME/lib/modules)
```
If you have more than one kernel installed then something went very wrong

Get the initrd and vmlinuz
```bash
cp $MNAME/boot/initramfs-$KVER.img /data/domain-images/openchami/rocky/test
chmod o+r /data/domain-images/openchami/rocky/test/initramfs-$KVER.img
cp $MNAME/boot/vmlinuz-$KVER /data/domain-images/openchami/rocky/test
```

Now let's make a squashfs of the rootfs
```bash
mksquashfs $MNAME /data/domain-images/openchami/rocky/test/rootfs-$KVER -noappend -no-progress
```

After all this you should have something that looks like so
```bash
[root@st-head ~]# ls -l /data/domain-images/openchami/rocky/test/
-rw----r-- 1 root root  107435549 May 12 09:46 initramfs-4.18.0-553.51.1.el8_10.x86_64.img
-rw-r--r-- 1 root root 1355763712 May 12 09:47 rootfs-4.18.0-553.51.1.el8_10.x86_64
-rwxr-xr-x 1 root root   10881352 May 12 09:47 vmlinuz-4.18.0-553.51.1.el8_10.x86_64
```
We'll use these later. 

Clean up the container stuff
```bash
buildah umount $CNAME
buildah rm $CNAME
```
### Configure BSS
We need to update BSS to use this image.  
Modify `inventory/group_vars/ochami/bss.yaml` and set
```yaml
bss_kernel_version: '4.18.0-553.22.1.el8_10.x86_64'
bss_image_version: 'rocky/test'
```
The `bss_kernel_version` should match `echo $KVER` if that is still set or you can check `/data/domain-images/openchami/rocky/test/`. 

Update BSS to use these new settings:
```bash
ansible-playbook -l $HOSTNAME -c local -i inventory -t bss ochami_playbook.yaml
```
You can check to make sure it got set correctly with
```bash
ochami bss boot params get | jq
```

## Booting nodes
Let's open like, I don't know, 4-5 windows.
You should be able to boot nodes now, but lets start with just one
```bash
pm -1 nid001
```
and watch the console
```bash
conman nid001
```

Checking the logs will help debug boot issues and/or see the nodes interacting with the OpenCHAMI services.
Run all these in separate windows...

Watch incoming DHCP requests. 
```bash
podman logs -f coresmd
```

Check BSS requests.
```bash
podman logs -f bss
```

Check cloud-init requests:
```bash
podman logs -f cloud-init-server
```

## Digging in
At this point you should be able to boot the test image and have all the fancy OpenCHAMI services running.
Now we can dive into things and get a better picture of what is going on

### SMD
We haven't really poked at SMD yet. There are a lot of endpoints but we are only really using these:

| **Endpoint**                  | **`ochami` Command**   |
| ----------------------------- | ---------------------- |
| /State/Components             | `ochami smd component` |
| /Inventory/ComponentEndpoints | `ochami smd compep`    |
| /Inventory/RedfishEndpoints   | `ochami smd rfe`       |
| /Inventory/EthernetInterfaces | `ochami smd iface`     |
| /groups                       | `ochami smd group`     |

As shown in the table, the `ochami` command can be used to deal with these
endpoints directly. Feel free to play around with it. For those that want to dig
around using `curl`, you'll need the `DEMO_ACCESS_TOKEN` we created earlier. If
it expired, regenerate it with:
```bash
export DEMO_ACCESS_TOKEN=$(gen_access_token)
```
`SMD_URL` should be set already but confirm with `echo $SMD_URL`

You can use:
```bash
curl -sH "Authorization: Bearer $DEMO_ACCESS_TOKEN" $SMD_URL/<endpoint>
```
to see all the fun data.

- The `/State/Componets` holds all the Components. You should see your nodes and BMCs here. The xnames are pointless in this context but SMD REQUIRES THEM. I hate it.  
- `/Inventory/ComponentEndpoints` is an intermediary endpoint. You don't directly interact with this endpoint.  
- `/Inventory/RedfishEndpoints` is where the BMC data is stored. If you DELETE `/Inventory/RedfishEndpoints` then `/Inventory/ComponentEndpoints` will also get deleted.  
- `/Inventory/EthernetInterfaces` is where all the interfaces are stored. IPs and MACs are mapped to Component IDs
- `/groups` is where the group information is stored

### BSS
BSS only has two endpoints we care about.

| **Endpoint**    | **`ochami` Command**     |
| --------------- | ------------------------ |
| /bootparameters | `ochami bss boot params` |
| /bootscript     | `ochami bss boot script` |

You'll need `DEMO_ACCESS_TOKEN` for one of these and `BSS_URL` will need to be
set (which it should be already).

- `/bootparameters` will require a token, but running `curl -sH "Authorization: Bearer $DEMO_ACCESS_TOKEN" $BSS_URL/bootparameters` should show you all your bootparams with the associated MACs.
- `/bootscript` can be accessed via HTTP (so nodes can get things during iPXE) and doesn't require a token. But you'll need to pick a valid MAC (pick one from the previous command output).
`curl $BSS_URL/bootscript?mac=ec:e7:a7:05:a1:fc` should show this nodes iPXE chain. 

### cloud-init
The cloud-init service is a microservice that provides cloud-config files to nodes when booting. This is done via groups, where the groups in cloud-init align with the groups in SMD. A group can contain two types of payloads:
- `meta-data`: a dictionary of key-value pairs. The values can be complex data structures like dictionaries, lists, and a combination of data structures. An example `meta-data` payload is shown here:
```yaml
name: compute
description: "Group for all compute meta-data"
meta-data:
  chrony_server: 192.168.0.1
```
- `file`: a [cloud-config](https://cloudinit.readthedocs.io/en/latest/reference/examples.html) valid payload. An example `file` payload is show here:
```yaml
name: chrony
description: "chrony.conf template"
file:
  encoding: plain
  content: |
    ## template: jinja
    #cloud-config
    write_files:
      - content: |
          server {{ ds.meta_data.instance_data.v1.vendor_data.groups.chrony.chrony_server }} iburst
          driftfile /var/lib/chrony/drift
          makestep 1.0 3
          rtcsync
          keyfile /etc/chrony.keys
          leapsectz right/UTC
          logdir /var/log/chrony
        path: /etc/chrony.conf
    runcmd:
      - systemctl restart chronyd
```

You can have both `meta-data` and `file` in the same payload or just one of them. Using the examples above yoy could combine them into a single payload:
```yaml
name: chrony
description: "chrony.conf template"
meta-data:
  chrony_server: 172.16.0.254
file:
  encoding: plain
  content: |
    ## template: jinja
    #cloud-config
    merge_how:
     - name: list
       settings: [append]
     - name: dict
       settings: [no_replace, recurse_list]
    write_files:
      - content: |
          server {{ ds.meta_data.instance_data.v1.vendor_data.groups.chrony.chrony_server }} iburst
          driftfile /var/lib/chrony/drift
          makestep 1.0 3
          rtcsync
          keyfile /etc/chrony.keys
          leapsectz right/UTC
          logdir /var/log/chrony
        path: /etc/chrony.conf
    runcmd:
      - systemctl restart chronyd
```

The difference is what the cloud-init server will do with `meta-data` or `file`. 

When the cloud-init client starts it will look for a data source. There are a lot of cloud-init [sources](https://cloudinit.readthedocs.io/en/latest/reference/datasources.html), but the cloud-init server will look like the [nocloud](https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html) data source to the client. 

Once it finds the data source it will look for three files in this order:
- meta-data
- user-data
- vendor-data

To the client the cloud-init server is a `nocloud` data source, but on the server side it will do some processing to discover what groups the client is a member of.

For `meta-data`:
- a node makes a request to `http://<server>/cloud-init/meta-data`
- The server will inspect the client IP and find the component in SMD
- The server will find the group membership of this component
- The server will find any cloud-init groups that match the found SMD groups
- If any matching groups contain `meta-data`, then the following format is returned to the client 
```yaml
instance-id: i-a71ecea7
local-hostname: de01
hostname: de01
cluster-name: demo
instance_data:
  v1:
    instance_id: i-a71ecea7
    local_ipv4: 172.16.0.1
    public_keys:
    - ssh-rsa <pub_key>
    vendor_data:
      version: "1.0"
      cloud_init_base_url: http://10.0.0.1:27777/cloud-init
      cluster_name: demo
      groups:
        <group_dict>
```
- The `meta-data` from each matched group is inserted into the cloud-init `meta-data` payload under `instance_data.v1.vendor_data.groups`
- This allows you to be as generic or specific as you want to be. Any conflicting key-value pairs between groups must be resolved in your cloud-config data. The server makes no attempt at deciding which key-value pairs are the correct ones

For `user-data`, this is currently returned as an empty cloud-config, i.e.:
```
#cloud-config
```

The `vendor-data` is where we include the cloud-init group `cloud-configs` using the [include](https://cloudinit.readthedocs.io/en/latest/explanation/format.html#include-file) directive.
- When the client requests it's `vendor-data` the server will again search through the groups and any cloud-init groups that contain `file` data will get added to a payload that looks like:
```
#include
<cloud-init-base-url>/<group>.yaml
```
- If a client is a member of `group1`, `group2`, and `group3` and these groups all contain `file` data the the include file would look something like
```
#include
<cloud-init-base-url>/group1.yaml
<cloud-init-base-url>/group2.yaml
<cloud-init-base-url>/group3.yaml
```
- On the client side cloud-init will, in order, download each of these and execute the `cloud-config` modules. 
- The default merging behavior is to override each module. You can tell the client to "merge append" by adding this to the top of each groups `file` data:
```yaml
merge_how:
- name: list
  settings: [append]
- name: dict
  settings: [no_replace, recurse_list]
```

Populating the cloud-init-server is relatively straight forward.
Here is an example:
```yaml
name: test1
description: "some dumb configs"
file:
  encoding: plain
  content: |
    ## template: jinja
    #cloud-config
    write_files:
      - path: /etc/test123
        content: 'blah blah blah'
    runcmds:
      - echo hello
```

To post data to the endpoint your payload needs to be in JSON, so you'll have to convert it. Save the above example to a file called `test1.yaml`
```bash
python3 -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin)))' < test.yaml | jq > test.json
```

Then you can 
```bash
curl -X POST -H "Content-Type: application/json" https://demo.openchami.cluster:8443/cloud-init/admin/groups -d @test1.json
```
Then get the data back with
```bash
curl https://demo.openchami.cluster:8443/cloud-init/admin/groups/test1 | jq
```

The `ochami` tool makes it a little bit easier to add things. However, it
expects an array of cloud-init configs since it can add/update many configs at
once. Make a test2.yaml and set it as:
```yaml
- name: test2
  description: "some more dumber configs"
  file:
    encoding: plain
    content: |
      ## template: jinja
      #cloud-config
      write_files:
        - path: /etc/dumb
          content: 'you are a dummy'
      runcmds:
        - cat /etc/dumb
```
Then, pass it to the tool:
```bash
ochami cloud-init group add -d @test2.yaml -f yaml
ochami cloud-init group get config test2
```
Which should look something like:
```
#cloud-config
write_files:
  - path: /etc/dumb
    content: 'you are a dummy'
runcmds:
  - cat /etc/dumb
```

You can also get the exact cloud-init payloads that a node will get when booting by hitting the `/cloud-init/admin/impersonation/<name>/{user-data, meta-data, vendor-data}`

The `ochami` tool can be used to get lots of info from the cloud-init server and has excellent `man` pages and `--help` works on all subcommands (with examples).

### CoreDHCP
We currently use CoreDHCP as our DHCP provider. CoreDHCP is useful because it is
plugin-based. All incoming DHCP packets are filtered through a list of plugins,
each of which can optionally modify the response and either pass it through to
the next plugin or return the response to the client. This is very useful for
customizing functionality.

The version of CoreDHCP that OpenCHAMI uses is built with a plugin called
"coresmd" that checks if MAC addresses requesting an IP address exist in SMD and
serves their corresponding IP address and BSS boot script URL. There is also
another plugin called "bootloop" that is optional and can be used as a catch-all
to continuously reboot requesting nodes whose MAC address is unknown to
SMD.[^bootloop]

[^bootloop]: The reason for rebooting continuously is so that unknown nodes
  continuously try to get a new IP address so that in the case these nodes are
  added to SMD, they can get their IP address with a longer lease. Rebooting is
  the default behavior, but the bootloop plugin allows customization of the
  behavior.

Ansible will place the CoreDHCP config file at
`/etc/ochami/configs/coredhcp.yaml`. Feel free to take a look. See
[here](https://github.com/OpenCHAMI/deployment-recipes/blob/main/quickstart/DHCP.md)
for a more in-depth description of how to configure CoreDHCP for OpenCHAMI on a
"real" system.

The "coresmd" plugin contains its own TFTP server that serves out the iPXE
bootloader binary matching the system CPU architecture. You can see these here:
```
podman exec coresmd ls /tftpboot
```
For more advanced "bootloop" plugin config (if used), one can put a custom iPXE
script in this directory and then replace `default` in the bootloop config line
with the name of the script file to have that script execute instead of
rebooting.

CoreDHCP, as OpenCHAMI has it, does not handle DNS itself, but rather outsources
to other DNS servers (see the `dns` directive in the config file).

Finally, if the static mapping of MAC addresses to IP addresses is required for
unknown nodes, the CoreDHCP "file" plugin can be added below the coresmd line in
the config file. See the DHCP.md document linked above for more details.