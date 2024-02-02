# Test attempting to update a duplicate config for existing MAC address.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:02"],
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"params": "param3,param4"
}

HTTP 200

# Verify that update occurred.
GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:02

# Response should be:
#
# [
# 	{
# 		"macs": [
# 			"02:0b:b8:00:30:02"
# 		],
# 		"params": "param3,param4",
# 		"kernel": "https://testkerneluri2.tld",
# 		"initrd": "https://testinitrduri2.tld",
# 		"cloud-init": {
# 			"meta-data": null,
# 			"user-data": null,
# 			"phone-home": {
# 				"pub_key_dsa": "",
# 				"pub_key_rsa": "",
# 				"pub_key_ecdsa": "",
# 				"instance_id": "",
# 				"hostname": "",
# 				"fqdn": ""
# 			}
# 		}
# 	}
# ]
HTTP 200
[Asserts]
jsonpath "$" count == 1
jsonpath "$[0].macs" count == 1
jsonpath "$[0].macs[0]" == "02:0b:b8:00:30:02"
jsonpath "$[0].params" == "param3,param4"
jsonpath "$[0].kernel" == "https://testkerneluri2.tld"
jsonpath "$[0].initrd" == "https://testinitrduri2.tld"
