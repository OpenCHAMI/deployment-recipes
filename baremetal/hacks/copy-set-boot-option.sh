# 1: hostname

source hacks/utils.sh

check_hostname "${1}"
check_password "${BMC_PASSWORD}"

VARIABLES_TEMPLATE="hacks/set-boot-option.sh.template"

upload_file() {
	filename="$(basename --suffix .template "${1}")"

	scp "$(dirname "${1}")/${filename}" admin:
	ssh -t admin "bash ${filename}"
}

export RFE_IP="$(get_bmc_ip "${1}")"
export MAC_ADDRESS="$(get_node_mac "${1}")"

template_to_config "${VARIABLES_TEMPLATE}" '$RFE_IP,$BMC_PASSWORD,$MAC_ADDRESS'

upload_file "${VARIABLES_TEMPLATE}"
