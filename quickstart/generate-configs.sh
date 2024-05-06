#!/bin/bash

if [ -f .env ]
then
	echo "A config file exists. Delete to generate a new one"
	exit 1
fi

if [ -z "$1" ]
then
	echo "Usage: $0 system-name"
	exit 1
fi


get_eth0_ipv4() {
 local ipv4
 local first_eth=$(ip link show | grep UP |grep -v veth | grep -v LOOPBACK |grep -v br- |grep -v NO-CARRIER | head -1 | awk -e '{print $2}' |sed 's/:$//')
 ipv4=$(ip -o -4 addr show $first_eth | awk '{print $4}')
 echo "${ipv4%/*}"
}

generate_random_alphanumeric() {
	local num_chars=${1:-32}
	  cat /dev/urandom | tr -dc '[:alnum:]' | fold -w "$num_chars" | head -n 1
}


# Set the system name
echo "# This file is used by docker compose to set environment variables" > .env
echo "# For more information about how it is read and how to override items in it, see the docs:" >> .env
echo "#   https://docs.docker.com/compose/environment-variables/set-environment-variables/" >> .env

# Set the system name which is used for certs
echo "SYSTEM_NAME=$1" >> .env
# Set DB passwords 
echo "POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "BSS_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(generate_random_alphanumeric 32)" >> .env
echo "HYDRA_SYSTEM_SECRET=$(generate_random_alphanumeric 32)" >> .env
echo "LOCAL_IP"=$(get_eth0_ipv4) >> .env

