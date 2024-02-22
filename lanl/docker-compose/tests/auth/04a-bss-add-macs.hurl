# Try to add two MAC addresses to BSS.
POST http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri1.tld",
	"initrd": "https://testinitrduri1.tld",
	"macs": ["02:0b:b8:00:30:00", "02:0b:b8:00:30:02"],
	"params": "console=tty0 console=ttyS0,115200n8"
}

# We should not be able to POST to bootparameters without a JWT.
HTTP 401
