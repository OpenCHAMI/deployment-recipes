source hacks/utils.sh

check_hostname "${1}"

print_funcname() {
	echo "* [x] $(echo "${1}" | sed 's/_/ /g')"
}

check_if_ip_was_added_in_smd() {
	if [ "$(bash hacks/get-ip.sh h006 | jq -r .IPAddresses)" = "[]" ]; then
		echo "warning: an ip address is missing"
		echo "bash hacks/update-ip.sh ${1}"
		return
	fi

	print_funcname "${FUNCNAME}"
}

check_if_openchami_dhcp_is_running() {
	if [ -z "$(docker -H ssh://admin ps --filter "ancestor=ghcr.io/openchami/coresmd:latest" --format json)" ]; then
		echo "warning: coresmd is not running"
		echo "bash hacks/start-dhcp.sh"
		return
	fi

	print_funcname "${FUNCNAME}"
}

main() {
	check_if_ip_was_added_in_smd
	check_if_openchami_dhcp_is_running
}

main
