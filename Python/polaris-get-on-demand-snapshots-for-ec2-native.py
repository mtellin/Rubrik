# Get a list of all snapshots for every instance that have an On Demand backup

import requests

token = raw_input("Enter your Bearer token: ")
gql = 'https://rubrik-se.my.rubrik.com/api/graphql'

headers = {"Authorization": token}

body = 

request = requests.post(gql, json=body, headers=headers)




###
{"operationName":"DeletePolarisSnapshotMutation","variables":{"snapshotFid":"2e988a2d-8c75-4bab-b59c-98375d746df9"},"query":"mutation DeletePolarisSnapshotMutation($snapshotFid: UUID!) {\n  deletePolarisSnapshot(snapshotFid: $snapshotFid)\n}\n"}
data.snappable.snapshotConnection.nodes[2].isOnDemandSnapshot