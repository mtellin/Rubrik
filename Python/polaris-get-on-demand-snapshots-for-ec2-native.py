# Get a list of all 

import requests

token = raw_input("Enter your Bearer token: ")
gql = 'https://rubrik-se.my.rubrik.com/api/graphql'

headers = {"Authorization": token}