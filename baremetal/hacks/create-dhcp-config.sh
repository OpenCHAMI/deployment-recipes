DATA_NETWORKS="data/networks.csv"
DATA_MACHINES="data/machines.csv"
DHCP_TEMPLATE="coredhcp/config.yaml.template"

# 1: network name
get_mask() {
	xan filter "name eq '${1}'" "${DATA_NETWORKS}" | xan select mask | xan behead
}

# 1: host name
get_node_ip_cn() {
	xan filter "host eq '${1}'" "${DATA_MACHINES}" | xan select node_ip_cn | xan behead
}

_template_to_config() {
	# shellcheck disable=SC2155
	local outfile="$(dirname "${1}")/$(basename --suffix .template "${1}")"

	if [ -e "${outfile}" ]; then
		echo "error: ${outfile} already exists, delete it"
		return
	else
		envsubst <"${1}" >"${outfile}"
	fi
}

export server_id="$(get_node_ip_cn "admin")"
export dns="$(get_node_ip_cn "dns")"
export router="$(get_node_ip_cn "router")"
export netmask=$(get_mask "compute nodes")

_template_to_config "${DHCP_TEMPLATE}"
