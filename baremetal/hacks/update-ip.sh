# 1: hostname

source hacks/utils.sh

if [ -z "${1}" ]; then
	echo "error: missing hostname"
	exit 1
fi

NODE_IP="$(get_node_ip_cn "${1}")"
MAC_ADDRESS="$(get_node_mac "${1}")"
ethInterfaceID="$(echo ${MAC_ADDRESS} | tr -d ':')"

curl \
	--request PATCH \
	--cacert cacert.pem \
	-d "
{
  \"Description\": \"\",
  \"IPAddresses\": [
    {
      \"IPAddress\": \"${NODE_IP}\"
    }
  ]
}
" \
	"https://foobar.openchami.cluster:8443/hsm/v2/Inventory/EthernetInterfaces/${ethInterfaceID}"
