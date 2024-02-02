# Delete an xname.
DELETE http://bss:27778/boot/v1/bootparameters
{
	"hosts": ["x0c2s2b0"]
}

HTTP 200

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s2b0

HTTP 404
