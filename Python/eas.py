#!/usr/bin/env python3
import rubrik_cdm
import urllib3 # Needed along with below command to ignore self-signed cert errors

# Change mv_name to the name of the EAS volume to grab the ID for the script below
mv_name = "mv-test-001" 

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

""" 
Remember to export enviornment variables for Rubrik
export rubrik_cdm_node_ip=fqdn
export rubrik_cdm_username=username
export rubrik_cdm_password=password 
"""

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

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