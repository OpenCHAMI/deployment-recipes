DATA_MACHINES="data/machines.csv"
DATA_NODES="data/nodes.csv"

# 1: network name
get_mask() {
	xan filter "name eq '${1}'" "${DATA_NETWORKS}" | xan select mask | xan behead
}

get_node_ip_bmc() {
	xan filter "host eq '${1}'" "${DATA_NODES}" | xan select rfe_ip | xan behead
}

get_node_ip_cn() {
	xan filter "host eq '${1}'" "${DATA_NODES}" | xan select node_ip | xan behead
}

get_machine_ip_cn() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select ip_cn | xan behead
}

get_bmc_ip() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select bmc_ip | xan behead
}

get_node_mac() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select mac_address | xan behead
}

get_latest_ip_digit() {
	echo "${1}" | sed 's/.*\.\([0-9]\+\)$/\1/'
}

check_hostname() {
	if [ -z "${1}" ]; then
		echo "error: missing hostname"
		exit 1
	fi
}

check_password() {
	if [ -z "${1}" ]; then
		echo "error: missing password"
		exit 1
	fi
}

# 1: file
# 2: variables
template_to_config() {
	# shellcheck disable=SC2155
	local outfile="$(dirname "${1}")/$(basename --suffix .template "${1}")"

	if [ -e "${outfile}" ]; then
		echo "error: ${outfile} already exists, delete it"
		exit 1
	else
		if [ -z "${2}" ]; then
			envsubst <"${1}" >"${outfile}"
		else
			envsubst "${2}" <"${1}" >"${outfile}"
		fi
	fi
}
