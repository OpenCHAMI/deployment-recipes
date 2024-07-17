OCHAMI LIBVIRT
--------------------------------------------------------------------------------
This role configures libvirt for ochami head nodes. Creates networks and VM definitions

## Variables
- `libvirt_nets`: a dictionary defining a libvirt network  
	- `name`: name of the network  
	- `forward_mode`: libvirt forward modes  
	- `bridge_name`: name of the virtual bridge  
	- `mac_addr`: MAC of the network bridge  
	- `ipaddr`: IP address of the network bridge  
	- `netmask`: Netmask of the network bridge  
	- `ip_start`: First IP of the network range  
	- `ip_end`: Last IP of the network range  
	- `hosts`: a list of dictionaries defining static hosts for this network  
		- `name`: Name of the host  
		- `mac`: MAC of the host  
		- `ipaddr`: IP of the host  
	- `booturl`: URL of the BOOT binary  

- `libvirt_vms`: a list of dictionaries defining the libvirt host VMs  
	- `name`: name of VM  
	- `memory`: Requested memory for VM  
	- `cpus`: Number of CPUs to assign to VM  
	- `arch`: Architecture of VM  
	- `interfaces`: A list of dictionaries defining the interfaces for the VM  
		- `type`: Network type: `network` or `bridge`  
		- `network`: option existing network to use  
		- `mac`: Optional MAC to assign to interface  
		- `bridge`: If using type `bridge`, specify the bridge here  
		- `model_type`: Type of libvirt network model.  

## Examples
Network example
```yaml
libvirt_nets:
  - name: ochami-network
    forward_mode: 'nat'
    bridge_name: 'virbr1'
    mac_addr: '02:00:00:0D:B6:0D'
    ipaddr: '10.1.0.1'
    netmask: '255.255.255.0'
    ip_start: '10.1.0.2'
    ip_end: '10.1.0.254'
    hosts:
      - name: 'ochami-vm'
        mac: '02:00:00:B6:13:76'
        ipaddr: '10.1.0.2'
    booturl: 'http://192.168.7.253:9000/efi/BOOTX64.EFI'
```

Host example
```yaml
libvirt_vms:
  - name: ochami-vm
    memory: 16777216
    cpus: '4'
    arch: 'x86_64'
    interfaces:
      - type: 'network'
        network: 'ochami-network'
        mac: '02:00:00:B6:13:76'
        model_type: 'virtio'
      - type: 'bridge'
        bridge: 'cvl-br0'
        model_type: 'virtio'
      - type: 'bridge'
        bridge: 'mvl-br0'
        model_type: 'virtio'
```
