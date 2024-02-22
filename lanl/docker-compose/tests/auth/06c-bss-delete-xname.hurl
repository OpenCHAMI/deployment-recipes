# Try deleting an XName.
DELETE http://bss:27778/boot/v1/bootparameters
{
	"hosts": ["x0c2s2b0"]
}

# We should not be able to DELETE to bootparameters without a JWT.
HTTP 401
