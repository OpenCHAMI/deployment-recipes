source hacks/utils.sh

if [ -z "${1}" ]; then
	echo "error: missing hostname"
	exit 1
fi

NODE_IP="$(get_node_ip_cn "${1}")"
MAC_ADDRESS="$(get_node_mac "${1}")"
PASSWORD=$(ssh admin -t "grep \"^POSTGRES_PASSWORD=\" ~/deployment-recipes/quickstart-pcs/.env | sed 's/POSTGRES_PASSWORD=//'" | tr -d '\r')
URL="postgresql://ochami:${PASSWORD}@localhost:5432/hmsds"

psql "${URL}" \
	<<< \
	"
UPDATE \"public\".\"comp_eth_interfaces\"
SET ip_addresses
=
'[{\"IPAddress\":\"${NODE_IP}\",\"Network\":\"cluster\"}]'
where id = '$(echo ${MAC_ADDRESS} | tr -d ':')';
"
