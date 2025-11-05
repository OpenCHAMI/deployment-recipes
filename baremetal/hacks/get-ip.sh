# 1: hostname

source hacks/utils.sh

check_hostname "${1}"

MAC_ADDRESS="$(get_node_mac "${1}")"
ethInterfaceID="$(echo ${MAC_ADDRESS} | tr -d ':')"

curl \
	-s \
	--cacert cacert.pem \
	"https://foobar.openchami.cluster:8443/hsm/v2/Inventory/EthernetInterfaces/${ethInterfaceID}"
