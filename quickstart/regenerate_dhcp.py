#!/usr/bin/env python3
import requests
import os
import filecmp
import shutil
import sys
import tempfile
import argparse
import logging

#

def getSMD(url, AccessToken=None):
    if AccessToken:
        headers = {'Authorization' : f'Bearer {AccessToken}'}
        r = requests.get(url, headers=headers)
    else:
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
    parser = argparse.ArgumentParser(description='Regenerate DHCP files')
    parser.add_argument('--base-url', help='Base URL for OpenCHAMI endpoint')
    parser.add_argument('--access-token', help='Access token for OpenCHAMI endpoint')
    args = parser.parse_args()

    if args.base_url and args.access_token:
        logging.warning('Ignoring environment variables for base_url and access_token')
        base_url = args.base_url
        access_token = args.access_token
    else:
        if os.environ.get('OCHAMI_BASEURL') is not None:
            base_url = os.environ['OCHAMI_BASEURL']
        else:
            base_url = 'http://localhost'

        if os.environ.get('OCHAMI_ACCESS_TOKEN') is not None:
            access_token = os.environ['OCHAMI_ACCESS_TOKEN']
        else:
            access_token = None

    ei_data = getSMD(f'{base_url}/hsm/v2/Inventory/EthernetInterfaces', access_token)
    component_data = getSMD(f"{base_url}/hsm/v2/State/Components", access_token)['Components']
    hostsfile = open("hostsfile", "w")
    # Rest of the code...

if __name__ == "__main__":
    main()
