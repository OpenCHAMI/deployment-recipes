#
# Get ComponentEndpoints we added corresponding to the XNames
#

GET http://smd-noauth:27779/hsm/v2/Inventory/ComponentEndpoints/x0c2s1b0

# Response should be:
#
# {
#	 "ID": "x0c2s1b0",
#	 "Type": "Node",
#	 "RedfishType": "ComputerSystem",
#	 "RedfishSubtype": "Physical",
#	 "OdataID": "",
#	 "RedfishEndpointID": "x0c2s1b0",
#	 "Enabled": true,
#	 "RedfishEndpointFQDN": "x0c2s1b0",
#	 "RedfishURL": "x0c2s1b0",
#	 "ComponentEndpointType": "ComponentEndpointComputerSystem",
#	 "RedfishSystemInfo": {
#		 "EthernetNICInfo": [
#			 {
#				 "RedfishId": "HPCNet2",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet2",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "ManagementEthernet",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/ManagementEthernet",
#				 "Description": "Node Maintenance Network",
#				 "MACAddress": "02:0b:b8:04:30:00"
#			 },
#			 {
#				 "RedfishId": "HPCNet1",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet1",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "HPCNet3",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet3",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "HPCNet0",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet0",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 }
#		 ]
#	 }
# }
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.ID" == "x0c2s1b0"
jsonpath "$.RedfishSystemInfo.EthernetNICInfo[1].MACAddress" == "02:0b:b8:04:30:00"

GET http://smd-noauth:27779/hsm/v2/Inventory/ComponentEndpoints/x0c2s3b0

# Response should be:
#
# {
#	 "ID": "x0c2s3b0",
#	 "Type": "Node",
#	 "RedfishType": "ComputerSystem",
#	 "RedfishSubtype": "Physical",
#	 "OdataID": "",
#	 "RedfishEndpointID": "x0c2s3b0",
#	 "Enabled": true,
#	 "RedfishEndpointFQDN": "x0c2s3b0",
#	 "RedfishURL": "x0c2s3b0",
#	 "ComponentEndpointType": "ComponentEndpointComputerSystem",
#	 "RedfishSystemInfo": {
#		 "EthernetNICInfo": [
#			 {
#				 "RedfishId": "HPCNet2",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet2",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "ManagementEthernet",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/ManagementEthernet",
#				 "Description": "Node Maintenance Network",
#				 "MACAddress": "02:0b:b8:04:30:04"
#			 },
#			 {
#				 "RedfishId": "HPCNet1",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet1",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "HPCNet3",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet3",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 },
#			 {
#				 "RedfishId": "HPCNet0",
#				 "@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet0",
#				 "Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
#				 "MACAddress": "Not Available"
#			 }
#		 ]
#	 }
# }
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.ID" == "x0c2s3b0"
jsonpath "$.RedfishSystemInfo.EthernetNICInfo[1].MACAddress" == "02:0b:b8:04:30:04"
