# Delete a MAC address.
DELETE http://bss-noauth:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:02"]
}

HTTP 200

GET http://bss-noauth:27778/boot/v1/bootparameters?mac=02:0b:b8:00:30:02

HTTP 404
