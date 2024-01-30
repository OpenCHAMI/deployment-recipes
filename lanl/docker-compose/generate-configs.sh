#!/bin/bash

# Ochami config file location
OCHAMI_CONFIG=${OCHAMI_CONFIG:-/etc/ochami/ochami-config.yaml}

if [ -f $OCHAMI_CONFIG ]
then
	echo "A config file exists. Delete to generate a new one"
	exit 1
fi

#Set DB passwords 
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" > .env
echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env
echo "OCHAMI_CONFIG=$OCHAMI_CONFIG" >> .env

#Copy Config template to real config location
mkdir -p $(dirname OCHAMI_CONFIG)
cp configs/ochami-template.yaml $OCHAMI_CONFIG

#replace passwords in template. 
#The sed delimeter is '@' because randomly generated passwds can have slashes and sed doesn't like that
SMDDBPASSWD="$(openssl rand -base64 32)"; sed -i'' -e "s@SMD_DB_PASSWD@$SMDDBPASSWD@" "${OCHAMI_CONFIG}"
BSSDBPASSWD="$(openssl rand -base64 32)"; sed -i'' -e "s@BSS_DB_PASSWD@$BSSDBPASSWD@" ${OCHAMI_CONFIG}
HYDRADBPASSWD="$(openssl rand -base64 32)"; sed -i'' -e "s@HYDRA_DB_PASSWD@$HYDRADBPASSWD@" ${OCHAMI_CONFIG}
