#!/usr/bin/env python3
import requests
import json
import os

POLARIS_SUBDOMAIN = os.environ.get('POLARIS_SUBDOMAIN')
POLARIS_USERNAME = os.environ.get('POLARIS_USERNAME')
POLARIS_PASSWORD = os.environ.get('POLARIS_PASSWORD')
POLARIS_URL = f'https://{POLARIS_SUBDOMAIN}.my.rubrik.com'

#Get access token
URI = POLARIS_URL + '/api/session'
HEADERS = {
    'Content-Type':'application/json',
    'Accept':'application/json'
    }
PAYLOAD = '{"username":"'+POLARIS_USERNAME+'","password":"'+POLARIS_PASSWORD+'"}'
RESPONSE = requests.post(URI, headers=HEADERS, verify=True, data=PAYLOAD)
if RESPONSE.status_code != 200:
        raise ValueError("Something went wrong with the request")
TOKEN = json.loads(RESPONSE.text)["access_token"]
TOKEN = "Bearer "+str(TOKEN)

#GraphQL endpoint and headers
URI = POLARIS_URL + '/api/graphql'
HEADERS = {
    'Content-Type':'application/json',
    'Accept':'application/json',
    'Authorization':TOKEN
    }

QUERY = '''query ComplianceTableQuery($filter: SnappableFilterInput, $sortBy: SnappableSortByEnum, $sortOrder: SortOrderEnum) {
  snappableConnection(filter: $filter, sortBy: $sortBy, sortOrder: $sortOrder) {
    edges {
      node {
        name
        complianceStatus
      }
    }
  }
}'''
VARIABLES = {
    "filter": {
        "objectType": [
            "Ec2Instance"
        ],
        "complianceStatus": [
            "InCompliance",
            "OutOfCompliance",
            "NotAvailable"
        ],
    },
    "sortBy": "Name",
    "sortOrder": "Asc"
}
JSON_BODY = {
    "query": QUERY,
    "variables": VARIABLES
}

# Make the GQL request with the above query
request = requests.post(URI, json=JSON_BODY, headers=HEADERS)

# Convert to JSON Output for iterating with
jsonOutput = json.loads(request.text)
d = jsonOutput['data']['snappableConnection']['edges']

# Print column header and then iterate through each 'node' value to output the ID and Status
print("{:<60s} {:<12s}".format('Instance ID','Compliance Status'))
for x in d:
    print('{:<60s}{:>12s}'.format(x['node']['name'],x['node']['complianceStatus']))
