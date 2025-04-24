#!/bin/sh

set -e

install_packages() {
	sudo apt update -y
	sudo apt install -y \
		libvirt-daemon \
		libvirt-daemon-system \
		qemu-system \
		pkg-config \
		libvirt-dev \
		build-essential \
		libssl-dev \
		libffi-dev
}

add_user_to_libvirt() {
	sudo usermod -aG libvirt "$(whoami)"
}

main() {
	install_packages
	add_user_to_libvirt
}

main
