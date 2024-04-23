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

# Set the system name
echo "# This file is used by docker compose to set environment variables" > .env
echo "# For more information about how it is read and how to override items in it, see the docs:" >> .env
echo "#   https://docs.docker.com/compose/environment-variables/set-environment-variables/" >> .env

# Set the system name which is used for certs
echo "SYSTEM_NAME=$1" >> .env
# Set DB passwords 
echo "POSTGRES_PASSWORD=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 32 | head -n 1)" >> .env
echo "BSS_POSTGRES_PASSWORD=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 32 | head -n 1)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 32 | head -n 1)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 32 | head -n 1)" >> .env
echo "HYDRA_SYSTEM_SECRET=$(cat /dev/urandom | tr -dc '[:alnum:]' | fold -w 32 | head -n 1)" >> .env
