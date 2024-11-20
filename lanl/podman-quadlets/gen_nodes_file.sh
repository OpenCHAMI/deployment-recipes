#!/bin/bash
nid=1
SN=${SN:-nid}
echo "nodes:"
for i in {1..9}
do
	NDATA=$(curl -sk -u $rf_pass https://172.16.0.10${i}:443/redfish/v1/Chassis/FCP_Baseboard/NetworkAdapters/Nic259/NetworkPorts/NICChannel0)
	if [[ $? -ne 0 ]]
	then
		>&2 echo "172.16.0.10${i} unreachable, generating a random MAC"
		RMAC=$(printf '02:00:00:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
		NDATA="{\"AssociatedNetworkAddresses\": [\"$RMAC\"]}"
	fi
	MAC=$(echo $NDATA | jq -r '.AssociatedNetworkAddresses|.[]')
	BDATA=$(curl -sk -u $rf_pass https://172.16.0.10${i}:443/redfish/v1/Managers/bmc/EthernetInterfaces/eth0)
        if [[ $? -ne 0 ]]
        then
                >&2 echo "172.16.0.10${i} unreachable, generating a random BMC MAC"
                RMAC=$(printf '02:00:00:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
                BDATA="{\"AssociatedNetworkAddresses\": [\"$RMAC\"]}"
        fi
        MAC=$(echo $NDATA | jq -r '.AssociatedNetworkAddresses|.[]')
	BMC_MAC=$(echo $BDATA | jq -r '.MACAddress')
	echo "- name: ${SN}00${i}
  nid: ${nid}
  xname: x1000c1s7b${i}n0
  bmc_mac: ${BMC_MAC}
  bmc_ip: 172.16.0.10${i}
  group: compute
  interfaces:
  - mac_addr: ${MAC}
    ip_addrs:
    - name: internal
      ip_addr: 172.16.0.$i"

  	nid=$((nid+1))
done



#- name: node01
#  nid: 1
#  xname: x1000c1s7b0n0
#  bmc_mac: de:ca:fc:0f:ee:ee
#  bmc_ip: 172.16.0.101
#  group: compute
#  interfaces:
#  - mac_addr: de:ad:be:ee:ee:f1
#    ip_addrs:
#    - name: internal
#      ip_addr: 172.16.0.1
#  - mac_addr: de:ad:be:ee:ee:f2
#    ip_addrs:
#    - name: external
#      ip_addr: 10.15.3.100
#  - mac_addr: 02:00:00:91:31:b3
#    ip_addrs:
#    - name: HSN
#      ip_addr: 192.168.0.1
