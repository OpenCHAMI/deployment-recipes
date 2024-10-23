# Podman Quadlets Deployment Recipe
This recipe uses [podman quadlets](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) to start and orchestrate the OpenCHAMI containers. 

## Assumptions

### A running OS
This has be tested RHEL-like systems(Rocky, Almalinux, etc). 

### Cluster Images
OpenCHAMI doesn't provide an image build system. It relies on external images being available.  There is an example build below you can use to test things with. If you don't care about actually booting images and only want to deploy the services you don't have to care about this. 

### Cluster data
The data included here for things like MACs, cluster name, node names, etc come from a test system at LANL. 

## Prep
The following steps are needed before deploying the OpenCHAMI services.

### Package installs
```bash
sudo dnf install -y ansible git podman
```
### Setup hosts
Each cluster has a name and a shortname. This cluster is `Stratus` and the shortname is `st`.
The BMCs are named `p<shortname>`.
```bash
172.16.0.254    stratus.openchami.cluster
172.16.0.1      st01
172.16.0.2      st02
172.16.0.3      st03
172.16.0.4      st04
172.16.0.5      st05
172.16.0.6      st06
172.16.0.7      st07
172.16.0.8      st08
172.16.0.9      st09
172.16.0.101    pst01
172.16.0.102    pst02
172.16.0.103    pst03
172.16.0.104    pst04
172.16.0.105    pst05
172.16.0.106    pst06
172.16.0.107    pst07
172.16.0.108    pst08
172.16.0.109    pst09
```
The `stratus.openchami.cluster` entry is particularly important as OpenCHAMI will use this as the API gateway and when creating CA certs. 

### powerman + conman
We are assuming powerman and conman for power control and console access. OpenCHAMI doesn't care about these features (yet) so use whatever you have. If you are not going to be booting actual nodes then you can skip the power and console setup
```bash
dnf install -y powerman conman
```
Config `/etc/powerman/powerman.conf`, remember your cluster shortnames. User/Password are assumed to be set already
```bash
include "/etc/powerman/ipmipower.dev"

device "ipmi0" "ipmipower" "/usr/sbin/ipmipower -D lanplus -u admin -p TestPass123 -h pst[01-09] -I 17 -W ipmiping |&"
node "st[01-09]" "ipmi0" "pst[01-09]"
```
Start powerman:
```bash
systemctl start powerman
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
CONSOLE name="st01" dev="ipmi:pst01" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st02" dev="ipmi:pst02" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st03" dev="ipmi:pst03" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st04" dev="ipmi:pst04" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st05" dev="ipmi:pst05" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st06" dev="ipmi:pst06" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st07" dev="ipmi:pst07" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st08" dev="ipmi:pst08" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
CONSOLE name="st09" dev="ipmi:pst09" ipmiopts="U:admin,P:TestPass123,C:17,W:solpayloadsize"
```
Then Start `conman`
```bash
systemctl start conman
```

At this point you can test powering on a node and check that conman is working
```bash
pm -1 st01
conman st01
```
You should at least see console output, but it won't boot just yet...

### Building a test image
This will build a test image that you can use to boot nodes. 

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
Install the kernel and some needed dracut stuff:
```bash
dnf install -y --installroot=$MNAME kernel dracut-live fuse-overlayfs cloud-init
```
Then rebuild the initrd so that during dracut it will download the image and mount the rootfs as an in memory overlay
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
total 1244104
-rw----r-- 1 root root  102142693 Oct 16 09:04 initramfs-4.18.0-553.22.1.el8_10.x86_64.img
-rw-r--r-- 1 root root 1160933376 Oct 16 09:07 rootfs-4.18.0-553.22.1.el8_10.x86_64
-rwxr-xr-x 1 root root   10881352 Oct 16 09:04 vmlinuz-4.18.0-553.22.1.el8_10.x86_64
```
We'll use these later. 

Clean up the container stuff
```bash
buildah umount $CNAME
buildah rm $CNAME
```

## Deploying OpenCHAMI
We have a set of [Deployment Recipes](https://github.com/OpenCHAMI/deployment-recipes.git) available on the [OpenCHAMI GitHub](https://github.com/OpenCHAMI). 
We are going to use a specific one, the LANL [podman-quadlets](https://github.com/OpenCHAMI/deployment-recipes/tree/trcotton/podman-quadlets/lanl/podman-quadlets) recipe. We will have to modify some of the configs to match our cluster, but we'll get to that.  
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
st-head.si.usrc
```
To be the value of `hostname` (st-head.si.usrc in this case).  

### Set cluster names
Pick a cluster name and shortname. These examples use `Stratus` and `st` respectively.  
These are set in `inventory/group_vars/ochami/cluster.yaml`
```yaml
cluster_name: "stratus"
cluster_shortname: "st"
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
cluster_boot_ssh_pub_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZW66jaQXHDLgm9kfguy8J0rw/sz0XDuzZcAFyrQ4nE7QvM20vsC2L8NCv28LNozKOP2hzlDyP4aL0Uy8bVew07ApRUmXmselU2ReYxtjDtX2HEQPdyOg8+64sCjU2O3yxvufzI5jRNk+tV8+5T0yi1ZlIUBqM4I0tM0/16OwHEpnGusv58rZBcb+E1ipEnf0gEb4J0cz1NlhmvklF8Mb8NMOpEhjPp9Ilam6em5oulkx7IliQ+tmF+kKYi4jXZsZ4v31cmksQhniznb7YjAYxSN6DiPi2b/Nuxs6FeqTFhSAU9HxG5/7kZG5MrWsGWKPFp11DI7gL2D9zWplTT6577kLfz5IIKSS5qN1eJEaSZ60+ADPvgFMazt4J0nwCbZ+r9FYspV16Da/qPCURUe9D7Mg5qK1B8XaFvvaEPKavq1rT5GflfgI9ehXDNaVUPcqmpi4ALoblYzGQaRxP9LuRs7MOgLwqV2h3CVS8H2GkNeNipG5NRw11zK0w5AjIJlc= root@st-head.si.usrc'
```
 Replace what is there with what `ssh-keygen` created. Make sure it is the pub key. 

### Configure BSS
BSS will provide the kernel,initramfs, and params to nodes when the iPXE. If you don't plan on booting nodes then you can leave these variables as is. If you use the test image steps then you will use the values set there. If you want to use your own image then you will have to fill the values on your own. 
Modify `inventory/group_vars/ochami/bss.yaml` and set
```yaml
bss_kernel_version: '4.18.0-553.22.1.el8_10.x86_64'
bss_image_version: 'rocky/test'
```
The `bss_kernel_version` should match `echo $KVER` if that is still set or you can check `/data/domain-images/rocky/test/`. 

### Populate nodes
Now we need to populate `inventory/group_vars/ochami/nodes.yaml`. This describes your cluster in a flat yaml file. 
It will look something like:
```yaml
nodes:
  - bmc_ipaddr: 172.16.0.101
    ipaddr: 172.16.0.1
    mac: ec:e7:a7:05:a1:fc
    nid: 1
    xname: x1000c1s7b0n0
    group: compute
    name: st01
```
These values will be local to your system. 

### Running the OpenCHAMI playbook
Run the provided playbook with the `configs` tag. As CAUTION, this will update the podman config to use netavark as the network backend instead of the default CNI. This will break any currently running containers.
```bash
ansible-playbook -l $HOSTNAME -c local -i inventory -t configs ochami_playbook.yaml
```
You may have to reboot to get podman to work correctly. If you run this on a fresh system then you may not have to.
```bash
reboot
```
Once the system is back up, run the full playbook
```bash
ansible-playbook -l $HOSTNAME -c local -i inventory ochami_playbook.yaml
```

Should take a minute or two to start everything and populate the services.  
At the end you should have these containers running:
```bash
# podman ps | awk '{print $NF}' | sort
bss
cloud-init-server
dnsmasq
dnsmasq-loader
haproxy
hydra
image-server
NAMES
opaal
opaal-idp
postgres
smd
step-ca
tpm-manager
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

Generate an ACCESS_TOKEN. This is used in the rest of the commands
```bash
export ACCESS_TOKEN=$(gen_access_token)
```
We're going to interact with the OpenCHAMI services using `ochami-cli`.  
It's not super great but it functions. 
```bash
ochami-cli --help
```

Check SMD is populated with `ochami-cli smd --get-components`
```bash
BMC:  x1000c1s7b[0-8]
Compute:  x1000c1s7b[0-8]n0
```

Check BSS is populated with `ochami-cli bss --get-bootparams`
```bash
nodes: nid[1-9]
kernel:  http://172.16.0.254:8080/openchami/rocky/v1/vmlinuz-4.18.0-553.22.1.el8_10.x86_64
initrd:  http://172.16.0.254:8080/openchami/rocky/v1/initramfs-4.18.0-553.22.1.el8_10.x86_64.img
params:  root=live:http://172.16.0.254:8080/openchami/rocky/v1/rootfs-4.18.0-553.22.1.el8_10.x86_64 ochami_ci_url=http://172.16.0.254:8081/cloud-init/ ochami_ci_url_secure=http://172.16.0.254:8081/cloud-init-secure/ overlayroot=tmpfs overlayroot_cfgdisk=disabled nomodeset ro ip=dhcp apparmor=0 selinux=0 console=ttyS0,115200 ip6=off network-config=disabled rd.shell
```

Check cloud-init is populated with `ochami-cli cloud-init --get-ci-data --name compute`
```yaml
cloud-init:
  metadata:
    instance-id: test
  userdata:
    runcmd:
    - setenforce 0
    - systemctl disable firewalld
    write_files:
    - content: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZW66jaQXHDLgm9kfguy8J0rw/sz0XDuzZcAFyrQ4nE7QvM20vsC2L8NCv28LNozKOP2hzlDyP4aL0Uy8bVew07ApRUmXmselU2ReYxtjDtX2HEQPdyOg8+64sCjU2O3yxvufzI5jRNk+tV8+5T0yi1ZlIUBqM4I0tM0/16OwHEpnGusv58rZBcb+E1ipEnf0gEb4J0cz1NlhmvklF8Mb8NMOpEhjPp9Ilam6em5oulkx7IliQ+tmF+kKYi4jXZsZ4v31cmksQhniznb7YjAYxSN6DiPi2b/Nuxs6FeqTFhSAU9HxG5/7kZG5MrWsGWKPFp11DI7gL2D9zWplTT6577kLfz5IIKSS5qN1eJEaSZ60+ADPvgFMazt4J0nwCbZ+r9FYspV16Da/qPCURUe9D7Mg5qK1B8XaFvvaEPKavq1rT5GflfgI9ehXDNaVUPcqmpi4ALoblYzGQaRxP9LuRs7MOgLwqV2h3CVS8H2GkNeNipG5NRw11zK0w5AjIJlc= root@st-head.si.usrc
      path: /root/.ssh/authorized_keys
  vendordata: {}
name: compute
```
We only setup authorized keys on the computes for now. 


### Booting Nodes
You should be able to boot nodes now. Checking the logs will help debug boot issues and/or see the nodes interacting with the OpenCHAMI services.

Watch incoming DHCP requests. 
```bash
podman logs -f dnsmasq
```

Check BSS requests.
```bash
podman logs -f bss
```

Check cloud-init requests:
```bash
podman logs -f cloud-init
```