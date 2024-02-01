# Create SMD Redfish endpoints for first xname.
POST http://smd:27779/hsm/v2/Inventory/RedfishEndpoints
{
	"ID": "x0c2s1b0",
	"Name": "x0c2s1b0",
	"Hostname": "x0c2s1b0",
	"FQDN": "",
	"User": "admin",
	"Password": "password",
	"MACRequired": true,
	"RediscoverOnUpdate": false,
	"MACAddr": "ae:12:e2:ff:91:9d",
	"IPAddress": "10.254.2.10",
	"Chassis": [
		{
			"@odata.id": "/redfish/v1/Chassis/x0c2s1b0",
			"Id": "x0c2s1b0",
			"Name": "x0c2s1b0",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Card",
			"DepthMm": 0,
			"Description": "SS11 200Gb 2P NIC Mezz",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "R4K44A",
			"PartNumber": "",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "On",
			"SKU": "",
			"SerialNumber": "TII0542809843",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		},
		{
			"@odata.id": "/redfish/v1/Chassis/Enclosure",
			"Id": "Enclosure",
			"Name": "Enclosure",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Enclosure",
			"DepthMm": 0,
			"Description": "BardPeakNC",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "BardPeakNC",
			"PartNumber": "P37085-001.A",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "",
			"SKU": "",
			"SerialNumber": "WFA2537623994",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		},
		{
			"@odata.id": "/redfish/v1/Chassis/x0c2s1b0n0",
			"Id": "x0c2s1b0n0",
			"Name": "x0c2s1b0n0",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Blade",
			"DepthMm": 0,
			"Description": "",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "",
			"PartNumber": "",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "",
			"SKU": "",
			"SerialNumber": "",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		}
	],
	"Systems": [
		{
			"Data": {
				"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0",
				"Id": "x0c2s1b0n0",
				"@odata.context": "",
				"@odata.type": "#ComputerSystem.v1_5_0.ComputerSystem",
				"AssetTag": "",
				"BiosVersion": "ex235a.bios-1.3.6",
				"Boot": {
					"BootOrder": [
						"ME0-PXE-IP4",
						"ME0-PXE-IP6",
						"HSN0-PXE-IP4",
						"HSN0-PXE-IP6",
						"HSN1-PXE-IP4",
						"HSN1-PXE-IP6",
						"HSN2-PXE-IP4",
						"HSN3-PXE-IP4",
						"HSN2-PXE-IP6",
						"HSN3-PXE-IP6",
						"Boot000B"
					]
				},
				"Description": "BardPeakNC",
				"HostName": "",
				"HostWatchdogTimer": {
					"FunctionEnabled": false,
					"Status": {
						"State": ""
					},
					"TimeoutAction": "",
					"WarningAction": ""
				},
				"HostingRoles": null,
				"IndicatorLED": "",
				"Manufacturer": "HPE",
				"MemorySummary": {
					"MemoryMirroring": "",
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"TotalSystemMemoryGiB": 512,
					"TotalSystemPersistentMemoryGiB": 0
				},
				"Model": "HPE CRAY EX235a",
				"Name": "x0c2s1b0n0",
				"PCIeDevices@odata.count": 0,
				"PCIeFunctions@odata.count": 0,
				"PartNumber": "P37085-001.A",
				"PowerRestorePolicy": "",
				"PowerState": "On",
				"ProcessorSummary": {
					"Count": 9,
					"LogicalProcessorCount": 0,
					"Model": "AMD INSTINCT MI200 (MCM) OAM LC",
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					}
				},
				"Redundancy": "",
				"Redundancy@odata.count": "",
				"SKU": "",
				"SerialNumber": "WFA2537623994",
				"Status": {
					"Health": "OK",
					"HealthRollup": "",
					"State": "Enabled"
				},
				"SubModel": "",
				"SystemType": "Physical",
				"TrustedModules": null,
				"UUID": "",
				"SupportedResetTypes": null,
				"ManagedBy": null
			},
			"EthernetInterfaces": [
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet2",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet2",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet2/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/ManagementEthernet",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "Node Maintenance Network",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "ManagementEthernet",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "02:0b:b8:04:30:00",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": null,
					"PermanentMACAddress": "02:0b:b8:04:30:00",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet1",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet1",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet1/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet3",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet3",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet3/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet0",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet0",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s1b0n0/EthernetInterfaces/HPCNet0/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": "Enabled"
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				}
			]
		}
	]
}

HTTP 201
Content-Type: application/json
[Asserts]
jsonpath "$[0].URI" == "/hsm/v2/Inventory/RedfishEndpoints/x0c2s1b0"

# Create SMD Redfish endpoints for third xname (the second will be deleted).
POST http://smd:27779/hsm/v2/Inventory/RedfishEndpoints
{
	"ID": "x0c2s3b0",
	"Name": "x0c2s3b0",
	"Hostname": "x0c2s3b0",
	"FQDN": "",
	"User": "admin",
	"Password": "password",
	"MACRequired": true,
	"RediscoverOnUpdate": false,
	"MACAddr": "ae:12:e2:ff:91:9e",
	"IPAddress": "10.254.2.11",
	"Chassis": [
		{
			"@odata.id": "/redfish/v1/Chassis/x0c2s3b0",
			"Id": "x0c2s3b0",
			"Name": "x0c2s3b0",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Card",
			"DepthMm": 0,
			"Description": "SS11 200Gb 2P NIC Mezz",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "R4K44A",
			"PartNumber": "",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "On",
			"SKU": "",
			"SerialNumber": "TII0542809843",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		},
		{
			"@odata.id": "/redfish/v1/Chassis/Enclosure",
			"Id": "Enclosure",
			"Name": "Enclosure",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Enclosure",
			"DepthMm": 0,
			"Description": "BardPeakNC",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "BardPeakNC",
			"PartNumber": "P37085-001.A",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "",
			"SKU": "",
			"SerialNumber": "WFA2537623994",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		},
		{
			"@odata.id": "/redfish/v1/Chassis/x0c2s3b0n0",
			"Id": "x0c2s3b0n0",
			"Name": "x0c2s3b0n0",
			"@odata.context": "",
			"@odata.type": "#Chassis.v1_5_1.Chassis",
			"AssetTag": "",
			"ChassisType": "Blade",
			"DepthMm": 0,
			"Description": "",
			"Drives@odata.count": 0,
			"EnvironmentalClass": "",
			"HeightMm": 0,
			"IndicatorLED": "",
			"Location": {
				"AltitudeMeters": 0,
				"Contacts": null,
				"Info": "",
				"InfoFormat": "",
				"Latitude": 0,
				"Longitude": 0,
				"PartLocation": {
					"LocationOrdinalValue": 0,
					"LocationType": "",
					"Orientation": "",
					"Reference": "",
					"ServiceLabel": ""
				},
				"Placement": {
					"AdditionalInfo": "",
					"Rack": "",
					"RackOffset": 0,
					"RackOffsetUnits": "",
					"Row": ""
				},
				"PostalAddress": {
					"AdditionalCode": "",
					"AdditionalInfo": "",
					"Building": "",
					"City": "",
					"Community": "",
					"Country": "",
					"District": "",
					"Division": "",
					"Floor": "",
					"GPSCoords": "",
					"HouseNumber": 0,
					"HouseNumberSuffix": "",
					"Landmark": "",
					"LeadingStreetDirection": "",
					"Location": "",
					"Name": "",
					"Neighborhood": "",
					"POBox": "",
					"PlaceType": "",
					"PostalCode": "",
					"Road": "",
					"RoadBranch": "",
					"RoadPostModifier": "",
					"RoadPreModifier": "",
					"RoadSection": "",
					"RoadSubBranch": "",
					"Room": "",
					"Seat": "",
					"Street": "",
					"StreetSuffix": "",
					"Territory": "",
					"TrailingStreetSuffix": "",
					"Unit": ""
				}
			},
			"Manufacturer": "HPE",
			"Model": "",
			"PartNumber": "",
			"PhysicalSecurity": {
				"IntrusionSensor": "",
				"IntrusionSensorNumber": 0,
				"IntrusionSensorReArm": ""
			},
			"PowerState": "",
			"SKU": "",
			"SerialNumber": "",
			"Status": {
				"Health": "OK",
				"HealthRollup": "",
				"State": "Enabled"
			},
			"UUID": "",
			"WeightKg": 0,
			"WidthMm": 0,
			"SupportedResetTypes": null
		}
	],
	"Systems": [
		{
			"Data": {
				"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0",
				"Id": "x0c2s3b0n0",
				"@odata.context": "",
				"@odata.type": "#ComputerSystem.v1_5_0.ComputerSystem",
				"AssetTag": "",
				"BiosVersion": "ex235a.bios-1.3.6",
				"Boot": {
					"BootOrder": [
						"ME0-PXE-IP4",
						"ME0-PXE-IP6",
						"HSN0-PXE-IP4",
						"HSN0-PXE-IP6",
						"HSN1-PXE-IP4",
						"HSN1-PXE-IP6",
						"HSN2-PXE-IP4",
						"HSN3-PXE-IP4",
						"HSN2-PXE-IP6",
						"HSN3-PXE-IP6",
						"Boot000B"
					]
				},
				"Description": "BardPeakNC",
				"HostName": "",
				"HostWatchdogTimer": {
					"FunctionEnabled": false,
					"Status": {
						"State": ""
					},
					"TimeoutAction": "",
					"WarningAction": ""
				},
				"HostingRoles": null,
				"IndicatorLED": "",
				"Manufacturer": "HPE",
				"MemorySummary": {
					"MemoryMirroring": "",
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"TotalSystemMemoryGiB": 512,
					"TotalSystemPersistentMemoryGiB": 0
				},
				"Model": "HPE CRAY EX235a",
				"Name": "x0c2s3b0n0",
				"PCIeDevices@odata.count": 0,
				"PCIeFunctions@odata.count": 0,
				"PartNumber": "P37085-001.A",
				"PowerRestorePolicy": "",
				"PowerState": "On",
				"ProcessorSummary": {
					"Count": 9,
					"LogicalProcessorCount": 0,
					"Model": "AMD INSTINCT MI200 (MCM) OAM LC",
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					}
				},
				"Redundancy": "",
				"Redundancy@odata.count": "",
				"SKU": "",
				"SerialNumber": "WFA2537623994",
				"Status": {
					"Health": "OK",
					"HealthRollup": "",
					"State": "Enabled"
				},
				"SubModel": "",
				"SystemType": "Physical",
				"TrustedModules": null,
				"UUID": "",
				"SupportedResetTypes": null,
				"ManagedBy": null
			},
			"EthernetInterfaces": [
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet2",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet2",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet2/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/ManagementEthernet",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "Node Maintenance Network",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "ManagementEthernet",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "02:0b:b8:04:30:04",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": null,
					"PermanentMACAddress": "02:0b:b8:04:30:04",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet1",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet1",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet1/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet3",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet3",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet3/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": ""
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				},
				{
					"@odata.context": "",
					"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet0",
					"@odata.type": "#EthernetInterface.v1_3_0.EthernetInterface",
					"AutoNeg": false,
					"DHCPv4": {
						"DHCPEnabled": false,
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseGateway": false,
						"UseNTPServers": false,
						"UseStaticRoutes": false
					},
					"DHCPv6": {
						"OperatingMode": "",
						"UseDNSServers": false,
						"UseDomainName": false,
						"UseNTPServers": false,
						"UseRapidCommit": false
					},
					"Description": "SS11 200Gb 2P NIC Mezz REV02 (HSN)",
					"EndpointsCount": 0,
					"EthernetInterfaceType": "",
					"FQDN": "",
					"FullDuplex": false,
					"HostName": "",
					"IPv4Addresses": null,
					"IPv4StaticAddresses": null,
					"IPv6AddressPolicyTable": null,
					"IPv6Addresses": null,
					"IPv6DefaultGateway": "",
					"IPv6StaticAddresses": null,
					"IPv6StaticDefaultGateways": null,
					"Id": "HPCNet0",
					"InterfaceEnabled": false,
					"LinkStatus": "",
					"MACAddress": "Not Available",
					"MTUSize": 0,
					"MaxIPv6StaticAddresses": 0,
					"Name": "",
					"NameServers": null,
					"Oem": {
						"Hpe": {
							"CassiniMetrics": {
								"@odata.id": "/redfish/v1/Systems/x0c2s3b0n0/EthernetInterfaces/HPCNet0/Oem/Hpe/CassiniMetrics"
							}
						}
					},
					"PermanentMACAddress": "",
					"SpeedMbps": 0,
					"StatelessAddressAutoConfig": {
						"IPv4AutoConfigEnabled": false,
						"IPv6AutoConfigEnabled": false
					},
					"StaticNameServers": null,
					"Status": {
						"Health": "",
						"HealthRollup": "",
						"State": "Enabled"
					},
					"UefiDevicePath": "",
					"VLAN": {
						"VLANEnable": false,
						"VLANId": 0
					}
				}
			]
		}
	]
}

HTTP 201
Content-Type: application/json
[Asserts]
jsonpath "$[0].URI" == "/hsm/v2/Inventory/RedfishEndpoints/x0c2s3b0"

# Get RedfishEndpoints we just added.
GET http://smd:27779/hsm/v2/Inventory/RedfishEndpoints

# Response should be:
#
# {
#	 "RedfishEndpoints": [
#		 {
#			 "ID": "x0c2s1b0",
#			 "Type": "NodeBMC",
#			 "Name": "x0c2s1b0",
#			 "Hostname": "x0c2s1b0",
#			 "Domain": "",
#			 "FQDN": "x0c2s1b0",
#			 "Enabled": true,
#			 "User": "admin",
#			 "Password": "password",
#			 "MACRequired": true,
#			 "MACAddr": "ae:12:e2:ff:91:9d",
#			 "IPAddress": "10.254.2.10",
#			 "RediscoverOnUpdate": false,
#			 "DiscoveryInfo": {
#				 "LastDiscoveryStatus": "NotYetQueried"
#			 }
#		 },
#		 {
#			 "ID": "x0c2s3b0",
#			 "Type": "NodeBMC",
#			 "Name": "x0c2s3b0",
#			 "Hostname": "x0c2s3b0",
#			 "Domain": "",
#			 "FQDN": "x0c2s3b0",
#			 "Enabled": true,
#			 "User": "admin",
#			 "Password": "password",
#			 "MACRequired": true,
#			 "MACAddr": "ae:12:e2:ff:91:9e",
#			 "IPAddress": "10.254.2.11",
#			 "RediscoverOnUpdate": false,
#			 "DiscoveryInfo": {
#				 "LastDiscoveryStatus": "NotYetQueried"
#			 }
#		 }
#	 ]
# }
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.RedfishEndpoints[*].ID" includes "x0c2s1b0"
jsonpath "$.RedfishEndpoints[*].ID" includes "x0c2s3b0"
jsonpath "$.RedfishEndpoints[*].Hostname" includes "x0c2s3b0"
jsonpath "$.RedfishEndpoints[*].Hostname" includes "x0c2s3b0"
jsonpath "$.RedfishEndpoints[*].MACAddr" includes "ae:12:e2:ff:91:9d"
jsonpath "$.RedfishEndpoints[*].MACAddr" includes "ae:12:e2:ff:91:9e"
jsonpath "$.RedfishEndpoints[*].IPAddress" includes "10.254.2.10"
jsonpath "$.RedfishEndpoints[*].IPAddress" includes "10.254.2.11"
