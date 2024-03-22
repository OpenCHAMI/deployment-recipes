# Delete mac addresses we added (by boot config).
DELETE http://bss-noauth:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"params": "console=tty0 console=ttyS0,115200n8"
}

HTTP 200

# All of the MAC addresses with the above boot config should not exist now.
# Check the first and third, since the second was already deleted.

GET http://bss-noauth:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:00

HTTP 404

GET http://bss-noauth:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:04

HTTP 404
