# Used to request vRA workloads in Gaia lab

import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

def vra_auth(vrafqdn,user,password,tenant):
    url = "https://{}/identity/api/tokens".format(vrafqdn)
    payload = '{{"username":"{}","password":"{}","tenant":"{}"}}'.format(user, password, tenant)
    headers = {
        'accept': "application/json",
        'content-type': "application/json",
        }
    response = requests.request("POST", url, data=payload, headers=headers, verify=False)
    j = response.json()['id']
    auth = "Bearer "+j
    return auth