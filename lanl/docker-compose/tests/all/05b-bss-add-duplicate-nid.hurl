# Try to add a duplicate NID. This should not add anything.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri0.tld",
	"initrd": "https://testinitrduri0.tld",
	"nids": [2],
	"params": "quiet"
}

HTTP 400
[Asserts]
jsonpath "$.detail" == "Bad Request: postgres.Add: No nodes to add (possible duplicate(s))"

GET http://bss:27778/boot/v1/bootparameters?nid=2

# Response should be:
#
# [
#	 {
#		 "nids": [
#			 2
#		 ],
#		 "params": "console=tty1 console=ttyS1,115200n8",
#		 "kernel": "https://testkerneluri2.tld",
#		 "initrd": "https://testinitrduri2.tld",
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
jsonpath "$[0].nids" count == 1
jsonpath "$[0].nids[0]" == 2
jsonpath "$[0].params" == "console=tty1 console=ttyS1,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
