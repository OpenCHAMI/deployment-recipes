#!/bin/bash

if [ -f .env ]
then
	echo "A config file (.env) exists. Delete to generate a new one"
	exit 1
fi

if [ -f configs/opaal.yaml ]
then
	echo "An OPAAL config (configs/opaal.yaml) exists. Delete to generate a new one"
fi

SYSNAME="$1"
if [ -z "$SYSNAME" ]
then
	echo "Usage: $0 system-name [domain]"
	echo "Example: $0 foobar openchami.cluster"
	echo "Example: $0 foobar"
	exit 1
fi

SYSDOMAIN="openchami.cluster"
if [ -n "$2" ]
then
	SYSDOMAIN="$2"
fi

if [[ ! -x $(command -v jq) ]]
then 
        echo "Command \"jq\" Not Found"
	exit 1 
fi

get_eth0_ipv4() {
 local ipv4
 local first_eth=$(ip -j addr | jq -c '.[]' | grep UP |grep -v veth | grep -v LOOPBACK |grep -v br- |grep -v NO-CARRIER | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1 | jq -rc '.ifname')
 ipv4=$(ip -o -4 addr show $first_eth | awk '{print $4}')
 echo "${ipv4%/*}"
}

generate_random_alphanumeric() {
	local num_chars=${1:-32}
	  cat /dev/urandom | tr -dc '[:alnum:]' | fold -w "$num_chars" | head -n 1
}

# Generate OPAAL config from configs/opaal-template.yaml. This will populate the
# system name and domain of the config with the values set for SYSTEM_NAME and
# SYSTEM_DOMAIN in this script.
# TODO: Populate GitLab information in OPAAL config.
sed "s/<your-subdomain-here>/${SYSTEM_NAME}/g" configs/opaal-template.yaml > configs/opaal.yaml
sed "s/<your-domain-here>/${SYSTEM_DOMAIN}/g" configs/opaal-template.yaml > configs/opaal.yaml


# Set the system name
echo "# This file is used by docker compose to set environment variables" > .env
echo "# For more information about how it is read and how to override items in it, see the docs:" >> .env
echo "#   https://docs.docker.com/compose/environment-variables/set-environment-variables/" >> .env

# Set the system name and domain hich are used for certs
echo "SYSTEM_NAME=$SYSNAME" >> .env
echo "SYSTEM_DOMAIN=$SYSDOMAIN" >> .env
# Set DB passwords 
echo "POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "BSS_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "HYDRA_SYSTEM_SECRET=$(generate_random_alphanumeric 32)" >> .env
echo "LOCAL_IP"=$(get_eth0_ipv4) >> .env

