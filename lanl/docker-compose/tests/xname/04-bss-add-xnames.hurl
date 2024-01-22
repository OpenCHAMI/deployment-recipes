# Add two xnames to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"hosts": ["x0c0s1b0", "x0c0s2b0"],
	"params": "param1,param2"
}

HTTP 201

# Add another xname to BSS (to see if same boot config got used instead of
# creating another).
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"hosts": ["x0c0s3b0"],
	"params": "param1,param2"
}

HTTP 201

GET http://bss:27778/boot/v1/bootparameters

# Response should be:
#
# [
#	 {
#		 "hosts": [
#			 "x0c0s1b0",
#			 "x0c0s2b0",
#			 "x0c0s3b0"
#		 ],
#		 "params": "param1,param2",
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
jsonpath "$[0].hosts" count == 3
jsonpath "$[0].hosts[*]" includes "x0c0s1b0"
jsonpath "$[0].hosts[*]" includes "x0c0s2b0"
jsonpath "$[0].hosts[*]" includes "x0c0s3b0"
jsonpath "$[0].params" == "param1,param2"
jsonpath "$[0].kernel" == "https://testkerneluri1.tld"
jsonpath "$[0].initrd" == "https://testinitrduri1.tld"
