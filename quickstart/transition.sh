transition() {
	echo "${1}" | jq

	TRANSITION_OUTPUT="$(curl \
		-s \
		-d "${1}" \
		localhost:28007/transitions)"

	TRANSITION_ID="$(echo "${TRANSITION_OUTPUT}" | jq -r .transitionID)"
	echo "${TRANSITION_OUTPUT}" | jq
	echo "---- TRANSITION STATUS ----"
	curl -s "localhost:28007/transitions/${TRANSITION_ID}" | jq
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
		"$(echo '{"operation": "${OPERATION}", "location": [{"xname": "${XNAME}"}]}' |
			XNAME="${1}" OPERATION="${2}" envsubst)"
}

if [ $# -eq 0 ]; then
	echo "error: missing argument"
	echo "example:"
	echo "${0} x1000c0s0b3n0 force-off"
	exit 1
fi

main "${@}"
