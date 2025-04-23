#!/bin/sh

SUSHY_EMULATOR_PATH="sushy-emulator"

install_packages() {
	if type htpasswd; then
		return
	fi

	sudo apt install -y apache2-utils # for htpasswd
}

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
	htpasswd -cbB "${HTPASSWD_PATH}"/auth-file root root_password
}

create_config() {
	local CONFIG_PATH="${SUSHY_EMULATOR_PATH}/config"
	mkdir -p "${CONFIG_PATH}"
	NODE_UUID="$(sudo virsh dumpxml virtual-node | grep uuid | sed 's|  <uuid>\(....................................\)</uuid>|\1|')"
	cat > "${CONFIG_PATH}"/config.py <<-eof
	SUSHY_EMULATOR_AUTH_FILE = "/htpasswd/auth-file"
	SUSHY_EMULATOR_STORAGE = {
	    "${NODE_UUID}": [
	        {
	            "Id": "1",
	            "Name": "Local Storage Controller",
	            "StorageControllers": [
	                {
	                    "MemberId": "0",
	                    "Name": "Contoso Integrated RAID",
	                    "SpeedGbps": 12
	                }
	            ],
	            "Drives": [
	                "32ADF365C6C1B7BD"
	            ]
	        }
	    ]
	}

	SUSHY_EMULATOR_DRIVES = {
	    ("${NODE_UUID}", "1"): [
	        {
	            "Id": "32ADF365C6C1B7BD",
	            "Name": "Drive Sample",
	            "CapacityBytes": 899527000000,
	            "Protocol": "SAS"
	        }
	    ]
	}

	SUSHY_EMULATOR_VOLUMES = {
	    ('${NODE_UUID}', '1'): [
	        {
	            "libvirtPoolName": "sushyPool",
	            "libvirtVolName": "testVol",
	            "Id": "1",
	            "Name": "Sample Volume 1",
	            "VolumeType": "Mirrored",
	            "CapacityBytes": 23748
	        },
	        {
	            "libvirtPoolName": "sushyPool",
	            "libvirtVolName": "testVol1",
	            "Id": "2",
	            "Name": "Sample Volume 2",
	            "VolumeType": "StripedWithParity",
	            "CapacityBytes": 48395
	        }
	    ]
	}
	eof
}

main() {
	install_packages
	create_ssh
	create_ssl
	create_config
	create_htpasswd
}

main
