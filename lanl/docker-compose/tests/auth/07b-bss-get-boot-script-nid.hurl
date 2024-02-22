# Generate a boot script for NID and return it.
GET http://bss:27778/boot/v1/bootscript?nid=1

# We should be able to GET bootscript without authentication.
HTTP 200
