transition() {
	echo "${1}" | jq

	curl \
		-s \
		-d "${1}" \
		localhost:28007/transitions | jq
}

print_operation_list() {
	echo "on"
	echo "off"
	echo "soft-restart"
	echo "hard-restart"
	echo "init"
	echo "force-off"
	echo "soft-off"
}

#1 xname
#2 operation
main() {
	transition \
		"$(echo '{"operation": "${OPERATION}", "location": [{"xname": "${XNAME}"}]}' | \
		XNAME="${1}" OPERATION="${2}" envsubst)"
}

# example
# bash transition.sh x1000c0s0b3 on

main "${@}"
transition '{"operation": "force-off", "location": [{"xname": "x1000c0s0b3"}]}'
transition '{"operation": "off", "location": [{"xname": "x1000c0s0b3"}]}'
transition '{"operation": "off", "location": [{"xname": "x1000c0s0b3n0"}]}'
