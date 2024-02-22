# Try updating a MAC.
PATCH http://bss:27778/boot/v1/bootparameters
{
	"macs": ["02:0b:b8:00:30:02"]
}

# We should not be able to PATCH to bootparameters without a JWT.
HTTP 401
