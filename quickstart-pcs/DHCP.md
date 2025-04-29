# Deploying CoreDHCP on a "Real" System

<!-- Text width is 80, only use spaces and use 4 spaces instead of tabs -->
<!-- vim: set et sta tw=80 ts=4 sw=4 sts=0: -->

The quickstart rather hastily sets up CoreDHCP with assumed network parameters,
but it would be useful to know how to configure it for an actual system. This
document serves to walk through how to configure CoreDHCP with the
[coresmd](https://github.com/OpenCHAMI/coresmd) plugins.

## Purpose

SMD is meant to be the source of truth for nodes/BMCs in the cluster, so the
goal of CoreDHCP + coresmd is to match MAC addresses requesting an IP address to
interfaces stored in SMD and serve the matching IP address. However, for
unknown MAC addresses to become known to SMD, they need to be added, for
example, by network discovery tools like
[Magellan](https://github.com/OpenCHAMI/magellan). To be discoverable at the
network layer, coresmd provides functionality for providing unknown MAC
addresses with temporary IP addresses so they can be discovered. Once they are
discovered and added to SMD, they can get a more "permanent" IP address from
coresmd.

## Methodology

Coresmd differentiates between *known* MAC addresses (handled by the `coresmd`
plugin itself) and *unknown* MAC addresses (handled by the `bootloop` plugin or
by CoreDHCP's `file` plugin depending on if IP-MAC mapping is necessary). The
general flow for a device getting a long-term IP address from scratch is as
follows:

1. Unknown MAC gets assigned an IP with a short lease.
   - This can be an available IP from a pool (`bootloop` plugin) or a fixed IP
     (`file` plugin).
   - If left unknown, device will continually request a new IP and get a
     short-lived one until the MAC becomes known.
1. MAC with short-leased IP gets added to SMD.
   - This happens outside the scope of DHCP.
   - How this happens can depend on the device type:
      - **BMC:** Using Magellan. **NOTE:** Modern versions of Magellan add node
        interfaces to SMD if discovered via Redfish.
      - **Node:** POSTing to SMD using `curl` or the Ochami CLI tool.
1. Known MAC gets assigned the IP assigned to it in SMD once the short-leased IP
   address expires, but with a longer lease time.
   - This happens via the `coresmd` plugin itself.

The first step in the above can be handled by either coresmd's `bootloop` plugin
or CoreDHCP's `file` plugin, or via a combination of both. The next two sections
describe the uses for these plugins and how they work while the section after
describes how the `coresmd` plugin itself works.

### Unknown MAC Addresses: The `file` Plugin

This plugin is used when it *does* matter which MAC address gets which IP
address. It is paired with CoreDHCP's `lease_time` directive to set how long the
temporary IPs should last. This plugin is maintained by CoreDHCP.

The `file` plugin is pretty simple: it hands out the IP address assigned to the
MAC address sending the DHCPDISCOVER and renews this IP once it expires.

### Unknown MAC Addresses: The `bootloop` Plugin

This plugin is used when it does not matter which MAC address gets which IP
address. Often, this is as a catch-all for MAC addresses not in an assignment
list, e.g. MAC addresses not caught by the `file` plugin above.

As stated, the `bootloop` plugin is designed to assign available IPs from a pool
to unknown MAC addresses without the guarantee that specific IP addresses get
assigned to certain MAC addresses.  While this plugin works with any device that
speaks DHCP, important behavioral differences are present between devices that
are able to network boot (e.g.  ethernet interfaces on a node) and devices that
are not able to network boot (e.g. BMCs). The difference is how requests to
renew IP addresses are handled.  When devices that can boot try to renew their
IP address, they are served an iPXE script that reboots them so they are forced
to renew their IP address. When devices that cannot boot try to renew their IP
address, their request is responded to with a DHCPNAK, which, according to [RFC
2131](https://datatracker.ietf.org/doc/html/rfc2131#section-3.2), causes the
device to reinitiate the entire DHCP handshake.

Technically, all DHCPDISCOVERs from MAC addresses that haven't been assigned an
IP address are responded to with a DHCPOFFER with the temporary IP address and
the rebooting iPXE script. Devices that can boot execute this iPXE script while
devices that cannot do not. So, when a non-booting device tries to renew this IP
address with a DHCPREQUEST, the response is a DHCPNAK so that it will send a
DHCPDISCOVER.

### Known MAC Addresses: The `coresmd` Plugin

This plugin is used to assign IP addresses based on data in SMD.

A cache in memory is maintained containing SMD Component and EthernetInterface
data which is refreshed at a configured interval. This refreshment occurs via a
separate thread (goroutine).

When a DHCP request reaches the plugin, it checks the cache if 1) the MAC
address exists as an EthernetInterface, 2) if there is an IP address for this
interface, and 3) if there is a corresponding Component for this interface. If
all three exist, the IP address corresponding to the EthernetInterface structure
is assigned to the device. This could be a node NIC or a BMC.

## Preparation

### (REQUIRED) TFTP

Since CoreDHCP does not include a TFTP server or plugin (as far as is known at
this writing), one is required that contains the following files at the TFTP
root:

- **ipxe.efi** --- UEFI iPXE bootloader for amd64 systems
- **undionly.kpxe** --- Legacy bootloader for x86-based systems
- **reboot.ipxe** --- The reboot iPXE script which contains:
  ```ipxe
  #!ipxe
  reboot
  ```

### (OPTIONAL) File for `file` Plugin

If using the `file` plugin, you will need a plaintext file that contains the
MAC-to-IP mapping. For example:

```
de:ca:fc:0f:fe:ee 172.16.0.101
de:ad:be:ee:ee:ef 172.16.0.102
```

## Writing a Configuration File

The configuration file is YAML-formatted. The general format is:

```yaml
server4:
  plugins:
    - plugin1: arg1 arg2
    - plugin2: arg1 arg2
    ...
```

... where `plugin1` and `plugin2` are plugin names in the plugin list, each
followed by space-separated arguments.

### Part 1: Server Configuration

The first part of this file should be plugins that configure basic server
settings, such as the IP of the DHCP server and optional DNS servers. These
settings should be configured *before* the coresmd configuration, since CoreDHCP
sends DHCP packets to be processed sequentially, *in order*, through these
plugins.

Let's look at an example server configuration:

```yaml
server4:
  plugins:
    - server_id: 172.16.0.253
    - dns: 1.1.1.1,8.8.8.8
    - router: 172.16.0.254
    - netmask: 255.255.255.0
```

- **server_id:** (*REQUIRED*) This is the "identity" of the DHCP server to
  distinguish it from any other servers that might be listening on the same
  network. Usually this is just the IP address the server is listening on.
- **dns:** (*OPTIONAL*) A comma-separated list of DNS servers to use for names
  and domains.
- **router:** (*REQUIRED*) The IP address of the network gateway for routing
  packets. This can be the same as the IP address CoreDHCP is listening on if
  that machine acts as a gateway.
- **netmask:** (*OPTIONAL*) The network mask used with IP addresses served by
  the `file` and `bootloop` plugins, if used. This is not needed if one is
  *only* using the `coresmd` plugin.

### Part 2: CoreSMD Configuration

The next part of the configuration file corresponds to the place where any of
the coresmd/file/bootloop plugins are configured. These need to be *below* the
server config above.

```yaml
server4:
  plugins:
    ...
    - coresmd: https://foobar.openchami.cluster http://172.16.0.253:8081 /root_ca/root_ca.crt 30s 1h
    - lease_time: 10m
    - file: /etc/coredhcp/hostsfile
    - bootloop: /tmp/coredhcp.db 5m 172.16.0.156 172.16.0.200
```

- **coresmd:** (*REQUIRED*) Check if MAC address in request matches any
  component in SMD. Pass request through if not.

  Arguments:
  - **SMD Base URI:** (*https://foobar.openchami.cluster*) Base URI for where
    SMD is listening (usually behind API proxy), usually with TLS enabled.
  - **Boot Script Base URI:** (*http://172.16.0.253:8081*) Base URI for where
    BSS is listening to fetch boot scripts from, usually *without* TLS. This is
    a separate argument because chances are that the CA certificate is not baked
    into the iPXE bootloader and thus cannot perform proper certificate
    validation.
  - **Path to CA Certifacate:** (*/root_ca/root_ca.crt*) Path to certificate
    authority certificate for validation of connections to SMD.
  - **Cache Update Interval:** (*30s*) Amount of time in between cache
    refreshes.[^intervals]
  - **Known Device Lease Duration:** (*1h*) Amount of time a *known* device's IP
    is valid for.[^intervals]
- **lease_time:** (*OPTIONAL*) Assign lease time for *unknown* nodes. This is
  *required* if using the `file` or `bootloop` plugins.

  Arguments:
  - **Unknown Device Lease Duration:** (*10m*) Amount of time an *unknown*
    device's IP is valid for.[^intervals]
- **file:** (*OPTIONAL*) Assign specific IP addresses to specific MAC addresses
  based on mapping in file. Typically, this comes right after `coresmd` since
  some MACs that are unknown to SMD need to be assigned a specific IP address.
  If the MAC isn't in the list, it gets passed to the "catch-all" `bootloop`
  plugin below.

  Arguments:
  - **Map File Path:** (*/etc/coredhcp/hostsfile*) Path to text file that maps
    MAC addresses to IP addresses.
- **bootloop:** (*OPTIONAL*) Assign available IP addresses from a pool to
  unknown MAC addresses. This is normally the last plugin in the file because it
  is usually used as a catch-all: the MAC was not known by SMD and was not
  listed in the map file.

  Arguments:
  - **Storage DB Path:** (*/tmp/coredhcp.db*) Path to sqlite3 file used for
    storing IP addresses that have been assigned. This file need not exist and
    will be created by the plugin upon initialization (assuming permissions are
    correct!).
  - **Pool Start IP:** (*172.16.0.156*) Starting IP address (inclusive) of the
    pool of available IP addresses to hand out.
  - **Pool End IP:** (*172.16.0.200*) Ending IP address (inclusive) of the pool
    of available IP addresses to hand out.

[^intervals]: Interval strings are parsed via Go's
    [time.ParseDuration](https://pkg.go.dev/time#ParseDuration) function. Check
    there for valid strings.
