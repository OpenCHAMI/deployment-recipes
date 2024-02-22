# Try to add two NIDs to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri2.tld",
	"initrd": "https://testinitrduri2.tld",
	"nids": [1, 2],
	"params": "console=tty1 console=ttyS1,115200n8"
}

# We should not be able to POST to bootparameters without a JWT.
HTTP 401
