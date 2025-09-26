# 1: hostname

source hacks/utils.sh

XNAME="$(get_rfe_xname "${1}")"

curl \
	--cacert cacert.pem \
	--request DELETE \
	https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints/${XNAME}
