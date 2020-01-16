#!/usr/bin/env python3
# This script will take an on-demand snapshot for every VM in an SLA
import rubrik_cdm
import urllib3 # Needed along with below command to ignore self-signed cert errors

# Change mv_name to the name of the EAS volume to grab the ID for the script below
sla_name = "1d-30d-NoArchive" 
on_demand_sla = "1d-30d-NoArchive"

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

""" 
Remember to export enviornment variables for Rubrik
export rubrik_cdm_node_ip=fqdn
export rubrik_cdm_username=username
export rubrik_cdm_password=password 
"""

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

# Grab the SLA ID from the SLA Name to use later
all_slas = rubrik.get('v1', '/sla_domain')
for sla in all_slas['data']:
    if sla['name'] == on_demand_sla:
        sla_on_demand_id = sla['id']

all_vms = rubrik.get('v1', '/vmware/vm')
on_demand_vm_list = []
for vm in all_vms['data']:
    if vm['effectiveSlaDomainName'] == sla_name:
        on_demand_vm_list.append(vm['id'])

# Now that we have all the VM IDs, let's take the on demand snaps
data = {}
data['slaId'] = sla_on_demand_id

for on_demand_vm in on_demand_vm_list:
    print(on_demand_vm)
    rubrik.post('v1', '/vmware/vm/{}/snapshot'.format(on_demand_vm), data)



print(all_vms['data'])


all_mvs = rubrik.get('internal', '/managed_volume')
print(all_mvs)
for mv in all_mvs['data']:
    if mv['name'] == mv_name:
        mv_id = mv['id']
print(mv_id)

# Giddy up
load = {}
rubrik.post('internal', '/managed_volume/' + mv_id + '/begin_snapshot', load)

print("blah blah stuff, next we will close the snapshot")
rubrik.post('internal', '/managed_volume/' + mv_id + '/end_snapshot', load)