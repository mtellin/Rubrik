#!/usr/bin/env python3

# See the following to create the necessary environment variables:
# https://github.com/mtellin/Rubrik/blob/master/Python/ReadMe.md

import rubrik_cdm
import os
import urllib3 # Needed along with below command to ignore self-signed cert errors

rubrik_cdm_node_ip = os.environ['RUBRIK_NODE']
rubrik_cdm_username = os.environ['RUBRIK_USER']
rubrik_cdm_password = os.environ['RUBRIK_PASS']

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

vm_name = "am1-miketell-w1"

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

all_vms = rubrik.get('v1', '/vmware/vm')
vms = all_vms['data']
for vm in vms:
   if vm['name'] == vm_name:
        live_vmid = vm['id']

# Need snapshot ID
vm_details = all_vms = rubrik.get('v1', '/vmware/vm/{}'.format(live_vmid))
# Filter down to just the snapshots
all_snaps = vm_details['snapshots']
# Let's grab the most recent snapshot
latest_snap = all_snaps[-1]
# Get the id value to use in our Live Mount call
snap_id = latest_snap['id']

# Giddy up
load = {}
rubrik.post('v1', '/vmware/vm/snapshot/{}/mount'.format(snap_id), load)