# Add two NIDs to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"nids": [1, 2],
	"params": "console=tty1 console=ttyS1,115200n8"
}

HTTP 201

# Add another NID to BSS (to see if same boot config got used instead of
# creating another).
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"nids": [3],
	"params": "console=tty1 console=ttyS1,115200n8"
}

HTTP 201

GET http://bss:27778/boot/v1/bootparameters?nid=1

# Response should be:
#
# [
#	 {
#		 "nids": [
#			 1
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
jsonpath "$[0].nids[0]" == 1
jsonpath "$[0].params" == "console=tty1 console=ttyS1,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"

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
jsonpath "$[0].nids[0]" == 2
jsonpath "$[0].params" == "console=tty1 console=ttyS1,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"

GET http://bss:27778/boot/v1/bootparameters?nid=3

# Response should be:
#
# [
#	 {
#		 "nids": [
#			 3
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
jsonpath "$[0].nids[0]" == 3
jsonpath "$[0].params" == "console=tty1 console=ttyS1,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
