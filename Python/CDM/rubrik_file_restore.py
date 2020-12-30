#!/usr/bin/env python3
import rubrik_cdm
import urllib3 # Needed along with below command to ignore self-signed cert errors

# Disable certificate warnings and connect to Rubrik Cluster
urllib3.disable_warnings()

""" 
Remember to export enviornment variables for Rubrik
export rubrik_cdm_node_ip=fqdn
export rubrik_cdm_username=username
export rubrik_cdm_password=password 
"""

rubrik = rubrik_cdm.Connect(rubrik_cdm_node_ip, rubrik_cdm_username, rubrik_cdm_password)

file_name = input('Enter the file to search for: ')

all_filesets = rubrik.get('v1', '/fileset')
all_vms = rubrik.get('v1', '/vmware/vm')
print(all_vms)
print(len(all_vms))
print(all_vms['hasMore'])
print(type(all_vms['data']))
print(type(all_vms['data'][0]))
#List you specify the index you want returned - [0] or [1] etc
#Dict you specify the key to return the value for - ['Sla'] returns Gold
print(all_vms['data'][0]['effectiveSlaDomainId'])

print(dir(all_filesets))
# This is a dictionary output
print("Filesets: ", all_filesets)
print("Type: ", type(all_filesets))

# This returns a dict
print("Data: ", all_filesets['data'][0])
filesets = all_filesets['data'][0]
print(filesets['hostName']) # returns value of hostName
print(filesets['templateName'])