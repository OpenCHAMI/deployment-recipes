#!/usr/bin/env python3
import requests
import os

def getSMD(url):
    r = requests.get(url)
    data = r.json()
    return data


def main():
    smd_endpoint=os.environ['smd_endpoint']
    bss_endpoint=os.environ['bss_endpoint']
    ei_data = getSMD(f'http://{smd_endpoint}:27779/hsm/v2/Inventory/EthernetInterfaces')
    f = open("/etc/dhcp-hostsfile","w")
    #this for loop writes host entries
    for i in ei_data:
        if i['Type'] != 'NodeBMC':
            print(f"{i['MACAddress']},set:{i['ComponentID']},tag:IPXEBOOT,{i['IPAddresses'][0]['IPAddress']},{i['ComponentID']}", file=f)
        else:
           print(f"{i['MACAddress']},{i['IPAddresses'][0]['IPAddress']},{i['ComponentID']}", file=f)
    f.close()
    #TODO actually map all the BMCs straight from redfish, instead of creating dummy endpoints for them.
    #rf_data = getSMD(f'http://{smd_endpoint}:27779/hsm/v2/Inventory/RedfishEndpoints')
    #for r in rf_data['RedfishEndpoints']:
    #    print(r['ID'] + ' ' + r['IPAddress'])
    f = open("/etc/dhcp-optsfile", "w")
    #this for loop writes option entries, we wouldn't need it if the BSS wasn't MAC specific
    for i in ei_data:
      if 'bmc' not in i['Description']:
          print(f"tag:{i['ComponentID']},67,\"http://{bss_endpoint}:27778/boot/v1/bootscript?mac={i['MACAddress']}\"", file=f)

    f.close()

if __name__ == "__main__":
    main()

