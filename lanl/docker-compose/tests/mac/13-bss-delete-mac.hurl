# Delete a MAC address.
DELETE http://bss:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:02"]
}

HTTP 200

GET http://bss:27778/boot/v1/bootparameters

# Response should be:
#
# [
#	 {
#		 "hosts": [
#			 "02:0b:b8:00:30:00",
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
jsonpath "$[0].macs" count == 2
jsonpath "$[0].macs[*]" includes "02:0b:b8:00:30:00"
jsonpath "$[0].macs[*]" includes "02:0b:b8:00:30:04"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
