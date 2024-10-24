#!/bin/bash -l

set -euo pipefail

usage() {
	echo "Usage: [options] $0 system-name [system-domain]"
	echo "Example: $0 foobar openchami.cluster"
	echo "Example: $0 foobar"
	echo "Example: $0 \\"
	echo "  -c 30s \\"
	echo "  -d 1.1.1.1,8.8.8.8 \\"
	echo "  -g 172.16.0.254 \\"
	echo "  -i 172.16.0.1 \\"
	echo "  -j 172.16.0.252 \\"
	echo "  -l 1h \\"
	echo "  -m 5m \\"
	echo "  -m 255.255.255.0 \\"
	echo "  -s 172.16.0.253 \\"
	echo "  -u http://172.16.0.253:8081 \\"
	echo "  foobar \\"
	echo "  openchami.cluster"
	echo ""
	echo "Generate configuration for OpenCHAMI quickstart."
	echo ""
	echo "OPTIONS:"
	echo " -c  Duration of DHCP cache validity. Defaults to 30s."
	echo " -d  Comma-separated list of DNS servers to use for DHCP. Defaults"
	echo "     to 8.8.8.8."
	echo " -f  Force overwriting config files."
	echo " -g  DHCP gateway IP. Defaults of value of LOCAL_IP in generated"
	echo "     .env file."
	echo " -h  Print this usage message to stdout."
	echo " -k  DHCP long lease time. 1 hour by default."
	echo " -l  DHCP short lease time. 5 minutes by default."
	echo " -m  DHCP netmask. Defaults to 255.255.255.0."
	echo " -s  DHCP server IP. Defaults to value of LOCAL_IP in generated"
	echo "     .env file."
	echo " -u  Base URL for fetching boot scripts. Defaults to"
	echo '     http://${LOCAL_IP}:8081.'
	echo ""
	echo "ARGUMENTS:"
	echo " system-name   Subdomain of system to use in certificate and config"
	echo "               generation. E.g. <system-name>.openchami.cluster"
	echo " system-domain (OPTIONAL) Domain of system to use in certificate and"
	echo "               config generation. Defaults to openchami.cluster"
}

get_eth0_ipv4() {
 local ipv4
 local first_eth=$(ip -j addr | jq -c '.[]' | grep UP |grep -v veth | grep -v LOOPBACK |grep -v br- |grep -v NO-CARRIER | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1 | jq -rc '.ifname')
 ipv4=$(ip -o -4 addr show $first_eth | awk '{print $4}')
 echo "${ipv4%/*}"
}

CACHE_VALIDITY=30s
LONG_LEASE_TIME=1h
SHORT_LEASE_TIME=5m
GATEWAY_IP=$(get_eth0_ipv4)
IP_POOL_START=172.16.0.1
IP_POOL_END=172.16.0.252
DNS_SERVERS=8.8.8.8
DHCP_NETMASK=255.255.255.0
DHCP_SERVER_IP=$(get_eth0_ipv4)
while getopts "c:d:fg:hi:j:k:l:m:s:u:" opt; do
	case "${opt}" in
		c)
			CACHE_VALIDITY="${OPTARG}"
			;;
		d)
			DNS_SERVERS="${OPTARG}"
			;;
		f)
			FORCE_OVERWRITE=true
			;;
		g)
			GATEWAY_IP="${OPTARG}"
			;;
		h)
			usage
			;;
		i)
			IP_POOL_START="${OPTARG}"
			;;
		j)
			IP_POOL_END="${OPTARG}"
			;;
		k)
			LONG_LEASE_TIME="${OPTARG}"
			;;
		l)
			SHORT_LEASE_TIME="${OPTARG}"
			;;
		m)
			DHCP_NETMASK="${OPTARG}"
			;;
		s)
			DHCP_SERVER_IP="${OPTARG}"
			;;
		u)
			SCRIPT_URL="${OPTARG}"
			;;
		*)
			usage >&2
			;;
	esac
done
shift $((OPTIND-1))

if [ -f .env ] && [ -z "${FORCE_OVERWRITE+x}" ]
then
	echo "A config file (.env) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -f configs/opaal.yaml ] && [ -z "${FORCE_OVERWRITE+x}" ]
then
	echo "An OPAAL config (configs/opaal.yaml) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -f configs/coredhcp.yaml ] && [ -z "${FORCE_OVERWRITE+x}" ]
then
	echo "A CoreDHCP config (configs/coredhcp.yaml) exists. Delete to generate a new one or -f to overwrite."
	file_exists=true
fi

if [ -n "${file_exists+x}" ]; then exit 1; fi

# Parse system name (required arg).
if [ -z "${1+x}" ]
then
	echo 'System name required.' >&2
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

# If script URL was not set with -u, set it to default value here.
if [ -z "${SCRIPT_URL+x}" ]
then
	SCRIPT_URL="http://$(get_eth0_ipv4):8081"
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
configs/opaal-template.yaml > configs/opaal.yaml

DNS_SERVERS="${DNS_SERVERS//,/ }"

# Generate CoreDHCP configuration from configs/coredhcp-template.yaml.
sed \
  -e "s/<CACHE_VALIDITY>/${CACHE_VALIDITY}/g" \
  -e "s/<IP_POOL_START>/${IP_POOL_START}/g" \
  -e "s/<IP_POOL_END>/${IP_POOL_END}/g" \
  -e "s/<LONG_LEASE_TIME>/${LONG_LEASE_TIME}/g" \
  -e "s/<SHORT_LEASE_TIME>/${SHORT_LEASE_TIME}/g" \
  -e "s|<SCRIPT_URL>|${SCRIPT_URL}|g" \
  -e "s|<BASE_URL>|https://${SYSNAME}.${SYSDOMAIN}|g" \
  -e "s/<DNS_SERVERS>/${DNS_SERVERS}/g" \
  -e "s/<SERVER_IP>/${DHCP_SERVER_IP}/g" \
  -e "s/<GATEWAY_IP>/${GATEWAY_IP}/g" \
  -e "s/<DHCP_NETMASK>/${DHCP_NETMASK}/g" \
  configs/coredhcp-template.yaml > configs/coredhcp.yaml

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
