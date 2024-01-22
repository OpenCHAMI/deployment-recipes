# Testing erring when specifying a mix of a MAC address that doesn't exist
# and a MAC address that does exist.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:ff", "02:0b:b8:00:30:02"],
	"params": "param1 param2"
}

HTTP 404
