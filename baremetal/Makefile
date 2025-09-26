re:
	bash hacks/stop-dhcp.sh || true
	ssh -t admin 'pushd quickstart-pcs && make re'
	scp admin:quickstart-pcs/{cacert.pem,access_token} .
	bash hacks/start-dhcp.sh

clean:
	bash hacks/stop-dhcp.sh || true
	ssh -t admin 'pushd quickstart-pcs && make clean'

gettoken:
	bash hacks/recreate-token.sh

forward-port:
	bash hacks/ssh-forward.sh

kill-forward-port:
	kill $(shell pgrep -f "ssh -N -L ")

shfmt:
	shfmt -w $(shell find . -name "*.sh")

getrfe:
	curl -ks https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | jq

getcomponent:
	curl -sk https://foobar.openchami.cluster:8443/hsm/v2/State/Components/ | jq

gete:
	curl -sk https://foobar.openchami.cluster:8443/hsm/v2/Inventory/EthernetInterfaces/ | jq

restart-dhcp:
	bash hacks/stop-dhcp.sh || true
	bash hacks/start-dhcp.sh

# database

rainfrog-hmsds:
	rainfrog --url postgresql://ochami:"$(shell ssh admin -t "grep \"^POSTGRES_PASSWORD=\" ~/deployment-recipes/quickstart-pcs/.env | sed 's/POSTGRES_PASSWORD=//'" | tr -d '\r')"@localhost:5432/hmsds

psql-hmsds:
	psql postgresql://ochami:"$(shell ssh admin -t "grep \"^POSTGRES_PASSWORD=\" ~/deployment-recipes/quickstart-pcs/.env | sed 's/POSTGRES_PASSWORD=//'" | tr -d '\r')"@localhost:5432/hmsds
