#!/usr/bin/env python3
import requests
import os
import filecmp
import shutil
import sys
import tempfile

#

def getSMD(url):
    r = requests.get(url)
    try:
        data = r.json()
        return data
    except:
        print(f"Error: {r.status_code} {r.reason} when querying {url}")
        sys.exit(1)

def getNID(c_data, xname):
    if 'node_prefix' in os.environ:
        node_prefix = os.environ['node_prefix']
    else:
        node_prefix="nid"
    for c in c_data:
        if xname == c['ID']:
            return node_prefix+'%0*d' % (3, c['NID'])
    else:
        return None

def main():

    # Check to see if an envrionment variable is set for the SMD endpoint
    if os.environ.get('SMD_BASEURL') is not None:
        smd_base_url = os.environ['SMD_BASEURL']
    else:
        smd_base_url = 'http://smd:27779'
    if os.environ.get('BSS_BASEURL') is not None:
        bss_base_url = os.environ['BSS_BASEURL']
    else:
        bss_base_url = 'http://bss:27778'

    ei_data = getSMD(f'{smd_base_url}/hsm/v2/Inventory/EthernetInterfaces')
    component_data = getSMD(f"{smd_base_url}/hsm/v2/State/Components")['Components']
    #hostsfile = tempfile.TemporaryFile(mode = "r+")
    hostsfile = open("hostsfile", "w")
    #this for loop writes host entries
    for i in ei_data:
        if i['Type'] != 'NodeBMC':
            nidname=getNID(component_data, i['ComponentID'])
            if nidname:
                print(f"{i['MACAddress']},set:{nidname},{i['IPAddresses'][0]['IPAddress']},{nidname}", file=hostsfile)
            else:
                print(f"{i['MACAddress']},set:{i['ComponentID']},{i['IPAddresses'][0]['IPAddress']},{i['ComponentID']}", file=hostsfile)
        else:
           print(f"{i['MACAddress']},{i['IPAddresses'][0]['IPAddress']},{i['ComponentID']}", file=hostsfile)
    hostsfile.close()

    optsfile = open("optsfile", "w")
    #this for loop writes option entries, we wouldn't need it if the BSS wasn't MAC specific
    for i in ei_data:
      if 'bmc' not in i['Description']:
          nidname=getNID(component_data, i['ComponentID'])
          if nidname:
              print(f"tag:{nidname},tag:IPXEBOOT,option:bootfile-name,\"{bss_base_url}/boot/v1/bootscript?mac={i['MACAddress']}\"", file=optsfile)
          else:
              print(f"tag:{i['ComponentID']},tag:IPXEBOOT,option:bootfile-name,\"{bss_base_url}/boot/v1/bootscript?mac={i['MACAddress']}\"", file=optsfile)
    optsfile.close()

if __name__ == "__main__":
    main()