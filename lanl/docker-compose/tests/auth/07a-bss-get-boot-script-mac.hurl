# Generate a boot script for MAC address and return it.
GET http://bss:27778/boot/v1/bootscript?mac=02:0b:b8:00:30:00

# We should be able to GET bootscript without authentication.
HTTP 200
