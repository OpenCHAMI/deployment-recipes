#!/bin/sh

set -e

VBMC_DOMAIN_NAME="virtual-node"

install_packages() {
	sudo apt update -y
	sudo apt install -y virtinst
}

sushy_create_domain() {
	tmpfile=$(mktemp /tmp/sushy-domain.XXXXXX)
	sudo virt-install \
		--name "${VBMC_DOMAIN_NAME}" \
		--ram 1024 \
		--disk size=4,format=qcow2 \
		--vcpus 2 \
		--os-variant fedora28 \
		--graphics vnc \
		--network network=vbmc \
		--print-xml >$tmpfile
	sudo virsh define --file $tmpfile
	rm $tmpfile
}

sushy_create_network() {
	tmpfile=$(mktemp /tmp/sushy-domain.XXXXXX)
	cat >"${tmpfile}" <<-XML
		<network>
		  <name>vbmc</name>
		  <forward mode='nat'/>
		  <bridge name='virbr1' stp='on' delay='0'/>
		  <domain name='vbmc.local'/>
		  <ip family='ipv4' address='10.0.200.1' prefix='24'>
		  </ip>
		</network>
	XML
	sudo virsh net-create "${tmpfile}"
	rm "${tmpfile}"
}

sushy_clean_domain() {
	sudo virsh shutdown "${VBMC_DOMAIN_NAME}" || true
	sudo virsh destroy "${VBMC_DOMAIN_NAME}" || true
	sudo virsh undefine "${VBMC_DOMAIN_NAME}" || true
}

main() {
	install_packages
	sushy_create_network
	sushy_create_domain
	sudo virsh start "${VBMC_DOMAIN_NAME}"
}

main
