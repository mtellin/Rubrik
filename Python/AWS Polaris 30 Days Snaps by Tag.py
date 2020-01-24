# AWS Polaris Report 30 Day Snaps by Tag

#!/usr/bin/python
import requests
import json
import datetime
import getpass
requests.packages.urllib3.disable_warnings()
# Set our variables
POLARIS_SUBDOMAIN = input("Enter your Rubrik Polaris subdomain: ")
POLARIS_URL = 'https://{}.my.rubrik.com'.format(POLARIS_SUBDOMAIN)
USERNAME = input("Enter your username for {}: ".format(POLARIS_URL))
PROMPT = 'Please enter the password for {} at {}: '.format(USERNAME, POLARIS_URL)
PASSWORD = getpass.getpass(prompt=PROMPT)
TAG_KEY = input("Enter the AWS Tag Key to search: ")
TAG_VALUE = input("Enter the AWS Tag Value to search: ")
START_DT = (datetime.datetime.now() - datetime.timedelta(days=30)).isoformat()
END_DT = datetime.datetime.utcnow().isoformat()
​
# Get access token
URI = POLARIS_URL + '/api/session'
HEADERS = {
    'Content-Type':'application/json',
    'Accept':'application/json'
    }
PAYLOAD = '{"username":"'+USERNAME+'","password":"'+PASSWORD+'"}'
RESPONSE = requests.post(URI, headers=HEADERS, verify=True, data=PAYLOAD)
if RESPONSE.status_code != 200:
        raise ValueError("Something went wrong with the request")
TOKEN = json.loads(RESPONSE.text)["access_token"]
TOKEN = "Bearer "+str(TOKEN)
#print(TOKEN)
# Query for anomalies
URI = POLARIS_URL + '/api/graphql'
HEADERS = {
    'Content-Type':'application/json',
    'Accept':'application/json',
    'Authorization':TOKEN
    }
GRAPH_VARS = '{{ "sortBy": "EC2_INSTANCE_ID", "sortOrder": "ASC", "filters": [ {{ "field": "IS_ARCHIVED", "texts": ["0"] }}, {{ "field": "AWS_TAG", "tagFilterParams": [ {{ "filterType": "TAG_KEY_VALUE", "tagKey": "{}", "tagValue": "{}" }} ] }} ], "snapStart": "{}", "snapEnd": "{}" }}'.format(TAG_KEY, TAG_VALUE, START_DT, END_DT)
​
GRAPH_QUERY = '"query AWSInstancesList($first: Int, $after: String, $sortBy: HierarchySortByField, $sortOrder: HierarchySortOrder, $filters: [Filter!], $snapStart: DateTime!, $snapEnd: DateTime!) {ec2InstancesList: awsNativeEc2InstanceConnection(first: $first, after: $after, sortBy: $sortBy, sortOrder: $sortOrder, filter: $filters) {edges {node { instanceName instanceId awsNativeAccountName region slaAssignment snapshotConnection(first:$first,filter:{ timeRange: { start: $snapStart, end: $snapEnd}}){nodes {id date}}}}}}"'
​
payload = '{{"operationName":"AWSInstancesList","variables":{},"query":{}}}'.format(GRAPH_VARS,GRAPH_QUERY)
#print(payload)
​
response = requests.post(URI, headers=HEADERS, verify=True, data=payload)
if response.status_code != 200:
    raise ValueError("Something went wrong with the request")
​
results = json.loads(response.text)
print(json.dumps(results, indent=4, sort_keys=True))