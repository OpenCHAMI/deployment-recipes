# Try updating an XName.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"hosts": ["x0c2s1b0"]
}

# We should not be able to PATCH to bootparameters without a JWT.
HTTP 401
