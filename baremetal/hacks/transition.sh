# 1: hostname

source hacks/utils.sh

URL="localhost:28007"
#URL="https://foobar.openchami.cluster:8443/power-control/v1"

# 1: transition id
get_transition_status() {
	curl -ks "${URL}"/transitions/${1}
}

# 1: xname
# 2: operation
transition() {
	# start the transition
	TRANSITION_OUTPUT="$(curl \
		-s \
		-d "
{
  \"operation\": \"${2}\",
  \"location\": [
    {
      \"xname\": \"${1}\"
    }
  ]
}
" \
		"${URL}"/transitions)"

	# get the transisiton id
	TRANSITION_ID="$(echo "${TRANSITION_OUTPUT}" | jq -r .transitionID)"
	echo "${TRANSITION_OUTPUT}" | jq ||
		echo "${TRANSITION_OUTPUT}"

	# wait until the transition has succeeded
	TRANSITION_STATUS="$(get_transition_status "${TRANSITION_ID}")"
	echo "${TRANSITION_STATUS}" | jq ||
		echo "${TRANSITION_STATUS}"
	until [ "$(echo "${TRANSITION_STATUS}" | jq -r '.tasks.[].taskStatus')" = "succeeded" ]; do
		TRANSITION_STATUS="$(get_transition_status "${TRANSITION_ID}")"
		echo "${TRANSITION_STATUS}" | jq ||
			echo "${TRANSITION_STATUS}"
		echo "waiting on success... ts $(date +%s)"
		sleep 1
	done
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

if [ $# -eq 0 ]; then
	echo "error: missing argument"
	echo "example:"
	echo "${0} x1000c0s0b3n0 force-off"
	exit 1
fi

transition "$(get_node_xname "${1}")" "${2}"
