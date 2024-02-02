# Delete XNames (by boot config).
DELETE http://bss:27778/boot/v1/bootparameters
{
	"kernel": "https://testkerneluri3.tld",
	"initrd": "https://testinitrduri3.tld",
	"params": "console=tty2 console=ttyS2,115200n8"
}

HTTP 200

# Ideally, it would be nice if BSS supported:
# /boot/v1/bootparameters?kernel=<uri>?initrd=<uri>?params=<params>
# so we could search only for nodes with that configuration. That
# would make testing if deleting by boot config works a lot easier.
#
# For now, since we know which xnames had this config, we check if
# those nodes exist.

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s1b0

# Node should have been deleted (and thus not found) since it had
# the above config.
HTTP 404

GET http://bss:27778/boot/v1/bootparameters?name=x0c2s3b0

# Node should have been deleted (and thus not found) since it had
# the above config.
HTTP 404
