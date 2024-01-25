# Testing erring when specifying MAC address that doesn't exist.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:ff"],
	"params": "param1 param2"
}

HTTP 404
