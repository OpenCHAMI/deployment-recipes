# 1: hostname

source hacks/utils.sh

MAC_ADDRESS="$(get_node_mac "${1}")"
SERVER="$(get_node_ip_cn "admin")"
XNAME="$(get_node_xname "${1}")"

ochami --cacert cacert.pem \
	bss boot params add \
	--mac "${MAC_ADDRESS}" \
	--kernel "http://${SERVER}/vmlinuz-linux" \
	--initrd "http://${SERVER}/initramfs-linux.img" \
	--params "bootname=${XNAME} console=ttyS0,115200 console=tty0 unregistered=1 archisobasedir=arch archiso_http_srv=http://${SERVER}/ cms_verify=y ip=dhcp"
