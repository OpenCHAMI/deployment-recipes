add_node_vault() {
	VAULT_ADDR=http://127.0.0.1:8200 VAULT_TOKEN=hms XNAME="${1}" vault write \
	secret/hms-creds/"${XNAME}" \
	refresh_interval="768h" \
	Password="--REDACTED--" \
	SNMPAuthPass="n/a" \
	SNMPPrivPass="n/a" \
	URL="${XNAME}/redfish/v1/Systems/Node1" \
	Username="root" \
	Xname="${XNAME}"
}

add_node_vault "x1000c0s0b3n0"
add_node_vault "x1000c1s7b0"
add_node_vault "x1000c1s7b0n0"
