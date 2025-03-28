#!/bin/sh

export VAULT_ADDR=http://vault:8200
export VAULT_TOKEN=hms

KEYS_PATH="${HOME}/keys"

start_service() {
	until docker-compose \
	  -f base.yml \
	  -f postgres.yml \
	  -f jwt-security.yml \
	  -f haproxy-api-gateway.yml \
	  -f  openchami-svcs.yml \
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
	  -f  openchami-svcs.yml \
	  -f autocert.yml \
	  -f coredhcp.yml \
	  -f pcs.yml \
	  -f vault.yml \
	  -f etcd.yml \
	  -f configurator.yml down
	done
}

generate_file() {
	source bash_functions.sh
	gen_access_token > access_token
	get_ca_cert > cacert.pem
}

vault_configure_jwt() {
	if vault auth list --format json | jq -e 'has("jwt/")'
	then
		return
	fi

	vault auth enable -path=jwt jwt
	vault write auth/jwt/role/test-role policies="metrics" user_claim="sub" role_type="jwt" bound_audiences="test"
	vault policy write metrics -<<-EOF
	path "secret/hms-creds" {
	capabilities = ["read", "list"]
	}
	EOF
	vault write auth/jwt/config jwt_supported_algs=RS256 jwt_validation_pubkeys=@$KEYS_PATH/public_key.pem
}

vault_create_keystore() {
	vault secrets disable secret
	vault secrets enable \
	-path "secret/hms-creds" \
	-version=1 kv
}

vault_populate_node() {
	XNAME=x1000c0s0b3

	vault write \
	secret/hms-creds/"${XNAME}" \
	refresh_interval="768h" \
	Password="--REDACTED--" \
	SNMPAuthPass="n/a" \
	SNMPPrivPass="n/a" \
	URL="${XNAME}/redfish/v1/Systems/Node1" \
	Username="root" \
	Xname="${XNAME}"
}

main() {
	start_service
	generate_file
	vault_configure_jwt
	vault_create_keystore
	vault_populate_node
}

main
