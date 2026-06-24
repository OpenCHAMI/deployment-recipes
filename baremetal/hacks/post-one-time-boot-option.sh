#1: hostname

source hacks/utils.sh

check_hostname "${1}"

URL="https://$(get_bmc_ip "${1}")"

# not working :(
__post() {
	curl \
		-sku \
		root:"${BMC_PASSWORD}" \
		-H "Content-Type: application/json" -d '
{
  "Boot": {
    "BootSourceOverrideEnabled": "Continuous",
    "BootSourceOverrideMode": "UEFI",
    "BootSourceOverrideTarget": "UefiTarget"
  }
}
' \
		"${URL}"/"${1}"
}

# both path are not working :(
__post "redfish/v1/Systems/1/BootOptions"
__post "redfish/v1/Systems/1"
