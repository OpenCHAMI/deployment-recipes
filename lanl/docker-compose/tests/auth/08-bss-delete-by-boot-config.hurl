# Try deleting by boot config.
DELETE http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"params": "console=tty0 console=ttyS0,115200n8"
}

# We should not be able to DELETE to bootparameters without a JWT.
HTTP 401
