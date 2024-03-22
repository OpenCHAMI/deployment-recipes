GET http://bss:27778/boot/v1/bootparameters

# We should not be able to GET bootparameters without a JWT.
HTTP 401
