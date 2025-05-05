#!/bin/bash -l

set -euo pipefail

usage() {
	echo "Usage: [options] $0"
	echo ""
	echo "Generate configuration for OpenCHAMI quickstart using example"
	echo "parameters."
	echo ""
	echo "OPTIONS:"
	echo " -h  Print this usage message to stdout."
	echo " -f  Force overwriting config files."
}

while getopts "fh" opt; do
	case "${opt}" in
	f)
		FORCE_OVERWRITE=true
		;;
	h)
		usage
		exit
		;;
	*)
		usage >&2
		exit
		;;
	esac
done
shift $((OPTIND - 1))

if [ -f .env ] && [ -z "${FORCE_OVERWRITE+x}" ]; then
	echo "A config file (.env) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -f configs/opaal.yaml ] && [ -z "${FORCE_OVERWRITE+x}" ]; then
	echo "An OPAAL config (configs/opaal.yaml) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -f configs/coredhcp.yaml ] && [ -z "${FORCE_OVERWRITE+x}" ]; then
	echo "A CoreDHCP config (configs/coredhcp.yaml) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -n "${file_exists+x}" ]; then exit 1; fi

SYSNAME=foobar
SYSDOMAIN="openchami.cluster"

# Check for required commands
if [[ ! -x $(command -v jq) ]]; then
	echo "Command \"jq\" not found"
	exit 1
fi
if [[ ! -x $(command -v sed) ]]; then
	echo "Command \"sed\" not found"
	exit 1
fi

generate_random_alphanumeric() {
	local num_chars=${1:-32}
	dd bs=512 if=/dev/urandom count=1 2>/dev/null | tr -dc '[:alnum:]' | fold -w "${num_chars}" | head -n 1
}

# Generate OPAAL config from configs/opaal-template.yaml. This will populate the
# system name and domain of the config with the values set for SYSTEM_NAME and
# SYSTEM_DOMAIN in this script.
# TODO: Populate GitLab information in OPAAL config.
sed \
	-e "s/<your-subdomain-here>/${SYSNAME}/g" \
	-e "s/<your-domain-here>/${SYSDOMAIN}/g" \
	configs/opaal-template.yaml >configs/opaal.yaml

# Generate CoreDHCP configuration from configs/coredhcp-template.yaml.
sed \
	-e "s|<BASE_URL>|https://${SYSNAME}.${SYSDOMAIN}:8443|g" \
	configs/coredhcp-template.yaml >configs/coredhcp.yaml

# Set the system name
cat >.env <<EOF
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
LOCAL_IP=192.168.0.254
EOF

# ensure permissions are set lax enough that unprivileged container users can read them
chmod -R a+rX configs pg-init
