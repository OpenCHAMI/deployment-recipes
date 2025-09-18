# 1: hostname

source hacks/utils.sh

IP="$(get_bmc_ip "${1}")"
XNAME="$(get_rfe_xname "${1}")"
PASSWORD=${BMC_PASSWORD}

curl \
	--cacert cacert.pem \
	--request POST \
	-d "
{
  \"RedfishEndpoints\": [
    {
      \"ID\": \"${XNAME}\",
      \"Hostname\": \"${IP}\",
      \"FQDN\": \"${IP}\",
      \"RediscoverOnUpdate\": true,
      \"User\": \"root\",
      \"Password\": \"${PASSWORD}\"
    }
  ]
}
" \
	https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints

until [ "$(curl \
	--cacert cacert.pem \
	-s \
	https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | jq -r '.RedfishEndpoints.[].DiscoveryInfo.LastDiscoveryStatus')" \
	== "DiscoverOK" ]; do
	echo "wait on DiscoverOk $(date +%s)"
	sleep 1
done
