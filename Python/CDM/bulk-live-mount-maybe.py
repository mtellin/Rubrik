#!/usr/bin/env python3
import rubrik_cdm
import urllib3 # Needed along with below command to ignore self-signed cert errors

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

vm_name = "am1-miketell-w1"

""" 
Remember to export enviornment variables for Rubrik
export rubrik_cdm_node_ip=fqdn
export rubrik_cdm_username=username
export rubrik_cdm_password=password 
"""

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

all_vms = rubrik.get('v1', '/vmware/vm')
vms = all_vms['data']
for vm in vms:
   if vm['name'] == vm_name:
        live_vmid = vm['id']
        live_vmname = vm['name']
print(live_vmid, live_vmname)

# Need snapshot ID
vm_details = all_vms = rubrik.get('v1', '/vmware/vm/' + live_vmid)
all_snaps = vm_details['snapshots']
latest_snap = all_snaps[-1]
snap_id = latest_snap['id']

# Giddy up
load = {}
rubrik.post('v1', '/vmware/vm/snapshot/' + snap_id + '/mount', load)