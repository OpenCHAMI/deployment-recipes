source hacks/utils.sh

check_hostname "${1}"

RFE_IP="$(get_node_ip_bmc "${1}")"
LOCALHOST_PORT="888$(get_latest_ip_digit "${RFE_IP}")"

ssh \
	-N \
	-L ${LOCALHOST_PORT}:${RFE_IP}:443 \
	admin &

echo "create a port forwarding localhost:${LOCALHOST_PORT} -> ${RFE_IP}:443"
firefox "https://localhost:${LOCALHOST_PORT}"
