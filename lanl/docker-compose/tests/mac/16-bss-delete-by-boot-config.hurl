# Delete everything (by boot config).
DELETE http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"params": "param3,param4"
}

HTTP 200

# All of the MAC addresses with the above boot config should not exist now.
# Check the first and third, since the second was already deleted.

GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:00

HTTP 404

GET http://bss:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:04

HTTP 404
