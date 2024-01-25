# Generate a boot script for first MAC address and return it.
GET http://bss:27778/boot/v1/bootscript?mac=02:0b:b8:00:30:00

# Response should be (trailing newline included):
#
# #!ipxe
# kernel --name kernel https://testkerneluri2.tld initrd=initrd param3,param4 xname=x0c0s1b0 ds=nocloud-net;s=localhost/ || goto boot_retry
# initrd --name initrd https://testinitrduri2.tld || goto boot_retry
# boot || goto boot_retry
# :boot_retry
# sleep 30
# chain https://api-gw-service-nmn.local/apis/bss/boot/v1/bootscript?mac=02:0b:b8:00:30:00&retry=1
#
HTTP 200
[Asserts]
body contains "#!ipxe"
body contains "kernel --name kernel https://testkerneluri2.tld initrd=initrd param3,param4 xname=x0c0s1b0 ds=nocloud-net;s=localhost/ || goto boot_retry"
body contains "initrd --name initrd https://testinitrduri2.tld || goto boot_retry"
body contains "boot || goto boot_retry"
body contains ":boot_retry"
body contains "sleep 30"
body contains "chain https://api-gw-service-nmn.local/apis/bss/boot/v1/bootscript?mac=02:0b:b8:00:30:00&retry=1"
