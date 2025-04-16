#!/bin/sh

set -e

install_packages(){
	sudo apt update -y
	sudo apt install -y jq git
}

install_last_docker_version_debian() {
	# Add Docker's official GPG key:
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	sudo apt-get update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	sudo usermod -aG docker "$(whoami)"
}

clone_openchami() {
	git clone https://github.com/t-h2o/deployment-recipes
	cd deployment-recipes/quickstart/
	git checkout work-in-progress
	./generate-configs.sh
}

main() {
	install_packages
	install_last_docker_version_debian
	clone_openchami
	ln -s "${HOME}/deployment-recipes/quickstart/" "${HOME}/"
}

main
