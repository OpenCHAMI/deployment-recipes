#!/bin/sh

echo "check the if pcs is running"

check_pcs_logs() {
	if ! docker logs pcs 2>&1 | grep --color "${1}" ; then
		echo "error: pcs miss \"${1}\""
	fi
}

check_pcs_logs '**RUNNING -- Listening'
check_pcs_logs 'ETCD connection succeeded.'
