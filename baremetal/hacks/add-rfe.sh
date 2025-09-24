# 1: hostname

source hacks/utils.sh

IP="$(get_bmc_ip "${1}")"
XNAME="$(get_rfe_xname "${1}")"
PASSWORD=${BMC_PASSWORD}

ANSWER="$(curl \
	--cacert cacert.pem \
	--request POST \
	-s \
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
	https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints)"

if [ "${ANSWER}" != "[{\"URI\":\"/hsm/v2/Inventory/RedfishEndpoints/${XNAME}\"}]" ]; then
	echo "error: received unexpected answer"
	echo "${ANSWER}"
	exit 1
fi

until [ "$(curl \
	--cacert cacert.pem \
	-s \
	https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | jq -r '.RedfishEndpoints.[].DiscoveryInfo.LastDiscoveryStatus')" \
	== "DiscoverOK" ]; do
	echo "wait on DiscoverOk $(date +%s)"
	sleep 1
done
