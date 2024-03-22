# Try updating a NID.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"nids": [1]
}

# We should not be able to PATCH to bootparameters without a JWT.
HTTP 401
