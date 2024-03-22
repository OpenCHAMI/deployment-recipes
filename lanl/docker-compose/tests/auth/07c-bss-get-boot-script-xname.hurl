# Generate a boot script for x0c2s1b0 and return it.
GET http://bss:27778/boot/v1/bootscript?name=x0c2s1b0

# We should be able to GET bootscript without authentication.
HTTP 200
