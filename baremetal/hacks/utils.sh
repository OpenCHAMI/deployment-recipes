DATA_MACHINES="data/machines.csv"

get_node_ip_cn() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select node_ip_cn | xan behead
}

get_bmc_ip() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select bmc_ip | xan behead
}

get_node_mac() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select mac_address | xan behead
}

get_rfe_xname() {
	IP="$(get_node_ip_cn "${1}")"
	LATEST_DIGIT="$(echo ${IP} | sed 's/.*\.\([0-9]\+\)$/\1/')"
	echo "x0c0s${LATEST_DIGIT}b0"
}

get_node_xname() {
	IP="$(get_node_ip_cn "${1}")"
	LATEST_DIGIT="$(echo ${IP} | sed 's/.*\.\([0-9]\+\)$/\1/')"
	echo "x0c0s${LATEST_DIGIT}b0n0"
}
