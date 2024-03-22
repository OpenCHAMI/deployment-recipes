# Try to add a duplicate XName. This should not add anything.
POST http://bss-noauth:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri0.tld",
	"initrd": "https://testinitrduri0.tld",
	"hosts": ["x0c2s2b0"],
	"params": "quiet"
}

HTTP 400
[Asserts]
jsonpath "$.detail" == "Bad Request: postgres.Add: No nodes to add (possible duplicate(s))"

GET http://bss-noauth:27778/boot/v1/bootparameters?name=x0c2s2b0

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
jsonpath "$[0].hosts" count == 1
jsonpath "$[0].hosts[0]" == "x0c2s2b0"
jsonpath "$[0].params" == "console=tty2 console=ttyS2,115200n8"
jsonpath "$[0].kernel" == "https://testkerneluri3.tld"
jsonpath "$[0].initrd" == "https://testinitrduri3.tld"
