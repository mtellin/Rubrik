#!/usr/bin/env python3
# This script will take an on-demand snapshot for every VM in an SLA

# Enter the SLA name to take the on-demand snapshot of as well as the SLA to assign to it
sla_name = "12hr-30d-AWS" 
on_demand_sla = "12hr-30d-AWS"

""" 
Remember to export enviornment variables for Rubrik
export rubrik_cdm_node_ip=fqdn
export rubrik_cdm_username=username
export rubrik_cdm_password=password 
"""

import rubrik_cdm
import urllib3 # Needed along with below command to ignore self-signed cert errors

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

# Grab the SLA ID from the SLA Name to use later
all_slas = rubrik.get('v1', '/sla_domain')
for sla in all_slas['data']:
    if sla['name'] == on_demand_sla:
        sla_on_demand_id = sla['id']

# Iterate through all the VMs and match only the ones in specific SLA
all_vms = rubrik.get('v1', '/vmware/vm')
on_demand_vm_list = []
for vm in all_vms['data']:
    if vm['effectiveSlaDomainName'] == sla_name:
        on_demand_vm_list.append(vm['id'])

# Now that we have all the VM IDs, let's take the on demand snaps
data = {}
data['slaId'] = sla_on_demand_id

for on_demand_vm in on_demand_vm_list:
    rubrik.post('v1', '/vmware/vm/{}/snapshot'.format(on_demand_vm), data)