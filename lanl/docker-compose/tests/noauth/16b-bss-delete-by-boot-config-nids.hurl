# Delete NIDs (by boot config).
DELETE http://bss-noauth:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"params": "console=tty1 console=ttyS1,115200n8"
}

HTTP 200

# All of the NIDs with the above boot config should not exist now.
# Check the first and third, since the second was already deleted.

GET http://bss-noauth:27778/boot/v1/bootparameters?nid=1

HTTP 404

GET http://bss-noauth:27778/boot/v1/bootparameters?nid=3

HTTP 404
