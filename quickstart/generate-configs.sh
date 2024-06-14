#!/bin/bash -l

set -euo pipefail

if [ -f .env ]
then
	echo "A config file (.env) exists. Delete to generate a new one"
	exit 1
fi

if [ -f configs/opaal.yaml ]
then
	echo "An OPAAL config (configs/opaal.yaml) exists. Delete to generate a new one"
fi

usage() {
	echo "Usage: $0 system-name [system-domain]"
	echo "Example: $0 foobar openchami.cluster"
	echo "Example: $0 foobar"
	echo ""
	echo "Generate configuration for OpenCHAMI quickstart."
	echo ""
	echo "ARGUMENTS:"
	echo " system-name   Subdomain of system to use in certificate and config"
	echo "               generation. E.g. <system-name>.openchami.cluster"
	echo " system-domain (OPTIONAL) Domain of system to use in certificate and"
	echo "               config generation. Defaults to openchami.cluster"
}

# Parse system name (required arg).
if [ -z "${1+x}" ]
then
	usage >&2
	exit 1
fi
SYSNAME="$1"

# Parse system domain (optional arg).
SYSDOMAIN="openchami.cluster"
if [ -n "${2+x}" ]
then
	SYSDOMAIN="$2"
fi

if [[ ! -x $(command -v jq) ]]
then
	echo "Command \"jq\" not found"
	exit 1
fi

if [[ ! -x $(command -v sed) ]]
then
	echo "Command \"sed\" not found"
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
sed \
  -e "s/<your-subdomain-here>/${SYSNAME}/g" \
  -e "s/<your-domain-here>/${SYSDOMAIN}/g" \
  configs/opaal-template.yaml > configs/opaal.yaml

# Set the system name
cat > .env <<EOF
# This file is used by docker compose to set environment variables
# For more information about how it is read and how to override items in it, see the docs:
#   https://docs.docker.com/compose/environment-variables/set-environment-variables/

# Set the system name and domain which are used for certs
SYSTEM_NAME=$SYSNAME
SYSTEM_DOMAIN=$SYSDOMAIN

POSTGRES_USER=ochami

# Set DB passwords
POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)
BSS_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)
SMD_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)
HYDRA_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)
HYDRA_SYSTEM_SECRET=$(generate_random_alphanumeric 32)
LOCAL_IP=$(get_eth0_ipv4)
EOF

# ensure permissions are set lax enough that unprivileged container users can read them
chmod -R a+rX configs pg-init
