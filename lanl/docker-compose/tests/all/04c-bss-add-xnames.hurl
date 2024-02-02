# Add two xnames to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"hosts": ["x0c2s1b0", "x0c2s2b0"],
	"params": "console=tty2 console=ttyS2,115200n8"
}

HTTP 201

# Add another xname to BSS (to see if same boot config got used instead of
# creating another).
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"hosts": ["x0c2s3b0"],
	"params": "console=tty2 console=ttyS2,115200n8"
}

HTTP 201

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s1b0

# Response should be:
#
# [
#	 {
#		 "hosts": [
#			 "x0c2s1b0"
#		 ],
#		 "params": "console=tty2 console=ttyS2,115200n8",
#		 "kernel": "https://testkerneluri3.tld",
#		 "initrd": "https://testinitrduri3.tld",
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
jsonpath "$[0].hosts[0]" == "x0c2s1b0"
jsonpath "$[0].params" == "console=tty2 console=ttyS2,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri3.tld"
jsonpath "$[0].initrd" == "https://testinitrduri3.tld"

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s2b0

# Response should be:
#
# [
#	 {
#		 "hosts": [
#			 "x0c2s2b0"
#		 ],
#		 "params": "console=tty2 console=ttyS2,115200n8",
#		 "kernel": "https://testkerneluri3.tld",
#		 "initrd": "https://testinitrduri3.tld",
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
jsonpath "$[0].hosts[0]" == "x0c2s2b0"
jsonpath "$[0].params" == "console=tty2 console=ttyS2,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri3.tld"
jsonpath "$[0].initrd" == "https://testinitrduri3.tld"

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s3b0

# Response should be:
#
# [
#	 {
#		 "hosts": [
#			 "x0c2s3b0"
#		 ],
#		 "params": "console=tty2 console=ttyS2,115200n8",
#		 "kernel": "https://testkerneluri3.tld",
#		 "initrd": "https://testinitrduri3.tld",
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
jsonpath "$[0].hosts[0]" == "x0c2s3b0"
jsonpath "$[0].params" == "console=tty2 console=ttyS2,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri3.tld"
jsonpath "$[0].initrd" == "https://testinitrduri3.tld"
