# Try to add two xnames to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"hosts": ["x0c2s1b0", "x0c2s2b0"],
	"params": "console=tty2 console=ttyS2,115200n8"
}

# We should not be able to POST to bootparameters without a JWT.
HTTP 401
