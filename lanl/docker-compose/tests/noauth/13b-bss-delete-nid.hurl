# Delete a NID.
DELETE http://bss-noauth:27778/boot/v1/bootparameters
{
	"nids": [2]
}

HTTP 200

GET http://bss-noauth:27778/boot/v1/bootparameters?nid=2

HTTP 404
