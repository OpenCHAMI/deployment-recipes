# Testing erring when no new parameters are passed.
PATCH http://bss-noauth:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:02"]
}

HTTP 404
