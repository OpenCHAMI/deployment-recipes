source hacks/utils.sh

VARIABLES_TEMPLATE="terraform/variables.tfvars.template"

export SERVER="$(get_machine_ip_cn admin "admin")"

template_to_config "${VARIABLES_TEMPLATE}"
