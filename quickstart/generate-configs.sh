#!/bin/bash

# Ochami config file location
OCHAMI_CONFIG=${OCHAMI_CONFIG:-configs/ochami-config.yaml}

if [ -f $OCHAMI_CONFIG ]
then
	echo "A config file exists. Delete to generate a new one"
	exit 1
fi

# Set DB passwords 
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" > .env
echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env

echo "OCHAMI_CONFIG=$OCHAMI_CONFIG" >> .env