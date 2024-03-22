# Try to add a duplicate MAC address using upper case. This should not add anything.
POST http://bss-noauth:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri0.tld",
	"initrd": "https://testinitrduri0.tld",
	"macs": ["02:0B:B8:00:30:04"],
	"params": "quiet"
}

HTTP 400
[Asserts]
jsonpath "$.detail" == "Bad Request: postgres.Add: No nodes to add (possible duplicate(s))"

GET http://bss-noauth:27778/boot/v1/bootparameters?mac=02:0B:B8:00:30:04

# Response should be:
#
# [
#	 {
#		 "macs": [
#			 "02:0b:b8:00:30:04"
#		 ],
#		 "params": "console=tty0 console=ttyS0,115200n8",
#		 "kernel": "https://testkerneluri1.tld",
#		 "initrd": "https://testinitrduri1.tld",
#		 "cloud-init": {
#			 "meta-data": null,
#			 "user-data": null,
#			 "phone-home": {
#				 "pub_key_dsa": "",
#				 "pub_key_rsa": "",
#				 "pub_key_ecdsa": "",
#				 "instance_id": "",
#				 "hostname": "",
#				 "fqdn": ""
#			 }
#		 }
#	 }
# ]
HTTP 200
Content-Type: application/json; charset=UTF-8
[Asserts]
jsonpath "$[0].macs" count == 1
jsonpath "$[0].macs[0]" == "02:0b:b8:00:30:04"
jsonpath "$[0].params" == "console=tty0 console=ttyS0,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri1.tld"
jsonpath "$[0].initrd" == "https://testinitrduri1.tld"
