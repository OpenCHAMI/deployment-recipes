source hacks/utils.sh

DATA_NETWORKS="data/networks.csv"
DATA_MACHINES="data/machines.csv"
DHCP_TEMPLATE="coredhcp/config.yaml.template"

export server_id="$(get_node_ip_cn "admin")"
export dns="$(get_node_ip_cn "dns")"
export router="$(get_node_ip_cn "router")"
export netmask=$(get_mask "compute nodes")

template_to_config "${DHCP_TEMPLATE}"
