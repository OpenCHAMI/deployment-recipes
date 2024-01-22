# Delete everything (by boot config).
DELETE http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"params": "param1,param2"
}

HTTP 200

GET http://bss:27778/boot/v1/bootparameters

# Response should be null, since all of the boot configs, boot groups,
# and nodes should have been deleted.
HTTP 200
Content-Type: application/json; charset=UTF-8
[Asserts]
jsonpath "$" == null
