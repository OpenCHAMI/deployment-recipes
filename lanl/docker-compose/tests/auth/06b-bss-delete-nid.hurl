# Try deleting a NID.
DELETE http://bss:27778/boot/v1/bootparameters
{
	"nids": [2]
}

# We should not be able to DELETE to bootparameters without a JWT.
HTTP 401
