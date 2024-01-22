# Add two NIDs to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"nids": [1, 2],
	"params": "param5,param6"
}

HTTP 201

# Add another NID to BSS (to see if same boot config got used instead of
# creating another).
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"nids": [3],
	"params": "param5,param6"
}

HTTP 201

GET http://bss:27778/boot/v1/bootparameters

# Response should be:
#
# [
#	 {
#		 "nids": [
#			 1,
#			 2,
#			 3
#		 ],
#		 "params": "param5,param6",
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
jsonpath "$[0].nids" count == 3
jsonpath "$[0].nids[*]" includes 1
jsonpath "$[0].nids[*]" includes 2
jsonpath "$[0].nids[*]" includes 3
jsonpath "$[0].params" == "param5,param6"
jsonpath "$[0].kernel" == "https://testkerneluri3.tld"
jsonpath "$[0].initrd" == "https://testinitrduri3.tld"
