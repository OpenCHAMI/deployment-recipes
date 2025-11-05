apply:
	TF_LOG=$(LOG_LEVEL) TF_LOG_PATH=trace.txt terraform apply -auto-approve -var-file=variables.tfvars

destroy:
	terraform destroy -auto-approve -var-file=variables.tfvars

getbss:
	@curl -sk -H "Authorization: Bearer $(shell cat ../access_token)" "http://localhost:27778/boot/v1/bootparameters" | jq

getgroups:
	@curl -ks https://foobar.openchami.cluster:8443/hsm/v2/groups | jq

getgroups-compute:
	@curl -ks https://foobar.openchami.cluster:8443/hsm/v2/groups/Compute | jq

getcloudinit-groups:
	@curl -ks https://foobar.openchami.cluster:8443/cloud-init/admin/groups | jq

getcloudinit-groups-compute:
	@curl -ks https://foobar.openchami.cluster:8443/cloud-init/admin/groups/compute | jq

getcloudinit-clusterdefault:
	@curl -ks https://foobar.openchami.cluster:8443/cloud-init/admin/cluster-defaults | jq

getrfe:
	@curl -ks https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | jq

getrfe-fail:
	@curl -ks https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | \
	jq '.RedfishEndpoints[] | select(.DiscoveryInfo.LastDiscoveryStatus == "ChildVerificationFailed")'

getrfe-wip:
	@curl -ks https://foobar.openchami.cluster:8443/hsm/v2/Inventory/RedfishEndpoints | \
	jq '.RedfishEndpoints[] | select(.DiscoveryInfo.LastDiscoveryStatus == "DiscoveryStarted")'

getcomponent:
	@curl -sk https://foobar.openchami.cluster:8443/hsm/v2/State/Components/ | jq

deletecomponent:
	@curl -sk https://foobar.openchami.cluster:8443/hsm/v2/State/Components/ | \
	jq -r '.Components.[].ID' | \
	xargs -I id curl -k --request DELETE 'https://foobar.openchami.cluster:8443/hsm/v2/State/Components/id'

gete:
	@curl -sk https://foobar.openchami.cluster:8443/hsm/v2/Inventory/EthernetInterfaces/ | jq

state-clear:
	terraform state list | sed "s/^\(.*\)/terraform state rm '\1'/" | bash
