# Generate a boot script for first MAC address and return it.
GET http://bss-noauth:27778/boot/v1/bootscript?mac=02:0b:b8:00:30:00

# Response should be (trailing newline included):
#
# #!ipxe
# kernel --name kernel https://testkerneluri1.tld initrd=initrd console=tty0 console=ttyS0,115200n8 xname=x0c0s1b0 ds=nocloud-net;s=localhost/ || goto boot_retry
# initrd --name initrd https://testinitrduri1.tld || goto boot_retry
# boot || goto boot_retry
# :boot_retry
# sleep 30
# chain https://api-gw-service-nmn.local/apis/bss/boot/v1/bootscript?mac=02:0b:b8:00:30:00&retry=1
#
HTTP 200
[Asserts]
body contains "#!ipxe"
body contains "kernel --name kernel https://testkerneluri1.tld initrd=initrd console=tty0 console=ttyS0,115200n8 xname=x0c0s1b0 ds=nocloud-net;s=localhost/ || goto boot_retry"
body contains "initrd --name initrd https://testinitrduri1.tld || goto boot_retry"
body contains "boot || goto boot_retry"
body contains ":boot_retry"
body contains "sleep 30"
body contains "chain https://api-gw-service-nmn.local/apis/bss/boot/v1/bootscript?mac=02:0b:b8:00:30:00&retry=1"
