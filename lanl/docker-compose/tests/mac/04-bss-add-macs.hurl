# Add two MAC addresses to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"macs": ["02:0b:b8:00:30:00", "02:0b:b8:00:30:02"],
	"params": "param3,param4"
}

HTTP 201

# Add another MAC address to BSS (to see if same boot config got used instead of
# creating another). Also, use an upper-case MAC address. BSS should store this
# as lower case.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"macs": ["02:0B:B8:00:30:04"],
	"params": "param3,param4"
}

HTTP 201

GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:00

# Response should be:
#
# [
#	 {
#		 "macs": [
#			 "02:0b:b8:00:30:00"
#		 ],
#		 "params": "param3,param4",
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
jsonpath "$[0].macs[0]" == "02:0b:b8:00:30:00"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"

GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:02

# Response should be:
#
# [
#	 {
#		 "macs": [
#			 "02:0b:b8:00:30:02"
#		 ],
#		 "params": "param3,param4",
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
jsonpath "$[0].macs[0]" == "02:0b:b8:00:30:02"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"

GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:04

# Response should be:
#
# [
#	 {
#		 "macs": [
#			 "02:0b:b8:00:30:04"
#		 ],
#		 "params": "param3,param4",
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
jsonpath "$[0].macs[0]" == "02:0b:b8:00:30:04"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
