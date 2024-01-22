# Try to add a duplicate MAC address using upper case. This should not add anything.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri0.tld",
	"initrd": "https://testinitrduri0.tld",
	"macs": ["02:0B:B8:00:30:04"],
	"params": "param0"
}

HTTP 400
[Asserts]
jsonpath "$.detail" == "Bad Request: postgres.Add: No nodes to add (possible duplicate(s))"

GET http://bss:27778/boot/v1/bootparameters

# Response should be:
#
# [
#	 {
#		 "macs": [
#			 "02:0b:b8:00:30:00",
#			 "02:0b:b8:00:30:02",
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
jsonpath "$[0].macs" count == 3
jsonpath "$[0].macs[*]" includes "02:0b:b8:00:30:00"
jsonpath "$[0].macs[*]" includes "02:0b:b8:00:30:02"
jsonpath "$[0].macs[*]" includes "02:0b:b8:00:30:04"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
