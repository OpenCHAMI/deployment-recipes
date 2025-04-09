#!/bin/sh

echo "check the if pcs is running"

check_pcs_logs() {
	if ! docker logs pcs 2>&1 | grep --color "${1}" ; then
		echo "error: pcs miss \"${1}\""
	fi
}

check_vault_list() {
	for secret in $(docker exec -e VAULT_TOKEN=hms vault vault list --format json secret/hms-creds/ | jq -r  | tr -d '[],\n"'); do
		echo $secret
		docker exec -e VAULT_TOKEN=hms vault vault read secret/hms-creds/$secret
	done
}

check_pcs_logs '**RUNNING -- Listening'
check_pcs_logs 'ETCD connection succeeded.'

check_vault_list
