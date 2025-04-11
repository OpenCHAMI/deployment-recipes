#!/bin/sh

SUSHY_EMULATOR_PATH="sushy-emulator"

create_ssh() {
	SSH_PATH="${SUSHY_EMULATOR_PATH}/ssh"

	mkdir -p "${SSH_PATH}"

	ssh-keygen -N '' -t ed25519 -f "${SSH_PATH}"/id_ed25519
	cat "${SSH_PATH}"/id_ed25519.pub >> ~/.ssh/authorized_keys

	# ssh-keyscan 172.17.0.1 > ~/.ssh/known_hosts
	# virsh --connect qemu+ssh://cloud-user@172.17.0.1/system
}

create_ssl() {
	local SERVER_PATH="${SUSHY_EMULATOR_PATH}/ssl"
	local SERVER_KEY="${SERVER_PATH}/sushy-emulator.key"
	local SERVER_CSR="${SERVER_PATH}/sushy-emulator.csr"
	local SERVER_CRT="${SERVER_PATH}/sushy-emulator.crt"
	local EXTFILE="${SERVER_PATH}/cert_ext.cnf"

	mkdir -p "${SERVER_PATH}"

	cat > ${EXTFILE} <<- eof
	[req]
	default_bit = 4096
	distinguished_name = req_distinguished_name
	prompt = no
	
	[req_distinguished_name]
	countryName             = CH
	stateOrProvinceName     = Vaud
	localityName            = Lausanne
	organizationName        = EPFL
	commonName              = foobar
	eof

	openssl genrsa -out ${SERVER_KEY} 4096
	openssl req -new -key ${SERVER_KEY} -out ${SERVER_CSR} -config ${EXTFILE}
	openssl x509 -req -days 3650 -in ${SERVER_CSR} -signkey ${SERVER_KEY} -out ${SERVER_CRT}
}

create_htpasswd() {
	local HTPASSWD_PATH="${SUSHY_EMULATOR_PATH}/htpasswd"
	mkdir -p "${HTPASSWD_PATH}"
	htpasswd -cb "${HTPASSWD_PATH}"/auth-file root root_password
}

create_config() {
	local CONFIG_PATH="${SUSHY_EMULATOR_PATH}/config"
	mkdir -p "${CONFIG_PATH}"
	echo 'SUSHY_EMULATOR_AUTH_FILE = /htpasswd/auth-file' > "${CONFIG_PATH}"/config.py
}

main() {
	create_ssh
	create_ssl
	create_config
	create_htpasswd
}

main
