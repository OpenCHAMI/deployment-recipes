#!/bin/sh

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=hms
export SUSHY_URL="http://localhost:8000"

XNAME=x1000c0s0b3

KEYS_PATH="keys"

start_service() {
	until docker-compose \
	  -f base.yml \
	  -f postgres.yml \
	  -f jwt-security.yml \
	  -f haproxy-api-gateway.yml \
	  -f openchami-svcs.yml \
	  -f autocert.yml \
	  -f coredhcp.yml \
	  -f pcs.yml \
	  -f vault.yml \
	  -f etcd.yml \
	  -f configurator.yml up -d
	do
	docker-compose \
	  -f base.yml \
	  -f postgres.yml \
	  -f jwt-security.yml \
	  -f haproxy-api-gateway.yml \
	  -f openchami-svcs.yml \
	  -f autocert.yml \
	  -f coredhcp.yml \
	  -f pcs.yml \
	  -f vault.yml \
	  -f etcd.yml \
	  -f configurator.yml down
	done
}

_sushy_getter() {
	if [ -z "${!1}" ]; then
		export "${1}"="$(curl \
			--silent \
			"${SUSHY_URL}${2}" \
			| jq --raw-output "${3}")"
	fi
}

get_virtual_node_url() {
	_sushy_getter "VIRTUAL_NODE" "/redfish/v1/Systems" '.Members[0]."@odata.id"'

	echo "localhost:8000${VIRTUAL_NODE}"
}

generate_file() {
	source bash_functions.sh
	gen_access_token > access_token
	get_ca_cert > cacert.pem
}

vault_configure_jwt() {
	if docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault auth list --format json | jq -e 'has("jwt/")'
	then
		return
	fi

	docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault auth enable -path=jwt jwt
	docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault write auth/jwt/role/test-role policies="metrics" user_claim="sub" role_type="jwt" bound_audiences="test"
	cat > policy.yml <<-\EOF
	path "secret/hms-creds" {
	capabilities = ["read", "list"]
	}
	EOF
        docker cp policy.yml vault:/policy.yml
        docker exec -e VAULT_TOKEN=hms vault vault policy write metrics /policy.yml
	docker cp $KEYS_PATH/public_key.pem vault:/public_key.pem
	docker exec -e VAULT_TOKEN=hms vault vault write auth/jwt/config jwt_supported_algs=RS256 jwt_validation_pubkeys=@/public_key.pem
}

vault_create_keystore() {
	docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault secrets disable secret
	docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault secrets enable \
	-path "secret/hms-creds" \
	-version=1 kv
}

vault_populate_node() {
	docker exec -e VAULT_TOKEN=$VAULT_TOKEN vault vault write \
	secret/hms-creds/"${XNAME}" \
	refresh_interval="768h" \
	Password="--REDACTED--" \
	SNMPAuthPass="n/a" \
	SNMPPrivPass="n/a" \
	URL="$(get_virtual_node_url)" \
	Username="root" \
	Xname="${XNAME}"
}

smd_populate() {
	manta add redfish-endpoint --id "${XNAME}" --hostname "${XNAME}" -u root -M 02:05:78:02:34:00
}

main() {
	start_service
	generate_file
	vault_configure_jwt
	vault_create_keystore
	vault_populate_node
	#smd_populate
}

main
