#!/bin/bash

set -e

IMAGE_URL="http://localhost/file.iso"
SUSHY_URL="https://localhost:8000"

_curl_get() {
	curl \
		--user root:root_password \
		--silent \
		--insecure "${@}"
}

# 1: url
_curl_jq() {
	_curl_get "${SUSHY_URL}${1}" | jq
}

# 1: http method
# 2: url
# 3: data
_curl_json() {
	curl -u root:root_password  -k \
	--request "${1}" \
	--header 'Content-Type: application/json' \
	--data  "${3}" \
	"${SUSHY_URL}${2}"
}

# 1: key
# 2: url
# 3: jq setting
_sushy_getter() {
	if  [ -z "${2}" ]; then
		echo "error ${FUNCNAME}: url is empty"
		exit 1
	fi

	if [ -z "${!1}" ]; then
		CURL_OUTPUT="$(_curl_get "${SUSHY_URL}${2}")"
		VALUE="$(echo "${CURL_OUTPUT}" | jq --raw-output "${3}")"
		export "${1}"="${VALUE}"
	fi
}

_get_virtual_node() {
	_sushy_getter "VIRTUAL_NODE" "/redfish/v1/Systems" '.Members[0]."@odata.id"'
}

_get_virtual_node_reset() {
	_get_virtual_node
	_sushy_getter "VIRTUAL_NODE_RESET" "${VIRTUAL_NODE}" '.Actions."#ComputerSystem.Reset".target'
}

_get_manager_path() {
	_sushy_getter "MANAGER_PATH" "/redfish/v1/Managers" '.Members[0]."@odata.id"'
}

_get_virtual_media_path() {
	_get_manager_path
	_sushy_getter "VIRTUAL_MEDIA_PATH" "${MANAGER_PATH}" '.VirtualMedia."@odata.id"'
}

_get_cd_path() {
	_get_virtual_media_path
	_sushy_getter "CD_PATH" "${VIRTUAL_MEDIA_PATH}" '.Members[0]."@odata.id"'
}

_get_insert_media_path() {
	_get_cd_path
	_sushy_getter "INSERT_MEDIA_PATH" "${CD_PATH}" '.Actions."#VirtualMedia.InsertMedia".target'
}

redfish_check_image_values() {
	_get_cd_path

	VALUES_RECEIVED="$(curl --silent "${SUSHY_URL}${CD_PATH}" \
	| jq --raw-output .Image,.ConnectedVia,.Inserted)"

	VALUES_EXPECTED="$(cat <<-eof
	${IMAGE_URL}
	URI
	true
	eof
	)"

	if [ "$VALUES_RECEIVED" = "$VALUES_EXPECTED" ] ; then
		echo "values are correct"
	else
		echo "values are not correct"
	fi
}

redfish_eject_cdrom() {
	_get_insert_media_path

	_curl_json \
		"POST" \
		"${INSERT_MEDIA_PATH}" \
		'{"Inserted": false}'
}

redfish_insert_virtual_media() {
	_get_insert_media_path

	_curl_json \
		"POST" \
		"${INSERT_MEDIA_PATH}" \
		"{\"Image\":\"${IMAGE_URL}\", \"Inserted\": true}"
}

redfish_get_virtual_node() {
	_get_virtual_node

	if [ "${VIRTUAL_NODE}" = "null" ]
	then
		echo "error: there is no virtual node"
		exit 1
	fi

	_curl_jq "${VIRTUAL_NODE}"
}

redfish_get_virtual_media() {
	_get_cd_path

	_curl_jq "${CD_PATH}"
}

redfish_forceoff_virtual_node() {
	_get_virtual_node_reset

	echo _curl_json \
		"POST" \
		"${VIRTUAL_NODE_RESET}" \
		'{"ResetType":"ForceOff"}'
	_curl_json \
		"POST" \
		"${VIRTUAL_NODE_RESET}" \
		'{"ResetType":"ForceOff"}'
}

redfish_boot_virtual_node() {
	_get_virtual_node_reset

	echo _curl_json \
		"POST" \
		"${VIRTUAL_NODE_RESET}" \
		'{"ResetType":"On"}'
	_curl_json \
		"POST" \
		"${VIRTUAL_NODE_RESET}" \
		'{"ResetType":"On"}'
}

redfish_set_cd_virtual_node() {
	_get_virtual_node

	_curl_json \
		"PATCH" \
		"${VIRTUAL_NODE}" \
		'{ "Boot":{"BootSourceOverrideTarget": "Cd", "BootSourceOverrideMode": "Uefi","BootSourceOverrideEnabled": "Continuous" } }'

	_curl_json \
		"PATCH" \
		"${VIRTUAL_NODE}" \
		'{ "Boot":{"BootSourceOverrideTarget": "Cd"} }'
}

all() {
	redfish_insert_virtual_media
	redfish_check_image_values
	redfish_eject_cdrom
	redfish_forceoff_virtual_node
	redfish_set_cd_virtual_node
	redfish_boot_virtual_node
	redfish_get_virtual_media
}

main() {
	choices=(boot forceoff main)

	case "${1}" in
	    "${choices[0]}")
			redfish_boot_virtual_node
	        ;;

	    "${choices[1]}")
			redfish_forceoff_virtual_node
	        ;;

	    "${choices[2]}")
			main
	        ;;

	    *)
	        echo "All choices: ${choices[@]}"
	esac
}

main "${1}"
