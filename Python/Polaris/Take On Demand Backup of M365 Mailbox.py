# Take an on demand backup for a single M365 mailbox, mailboxId is specified under VARIABLES

import requests

token = input("Enter your Bearer token: ")
gql = 'https://rubrik-se-beta.my.rubrik.com/api/graphql'

headers = {"Authorization": token}

# Use the Apollo Chrome extension to copy/paste the mutation for query and 
# variable output below
QUERY = '''
  mutation TakeO365MailboxSnapshotMutation($mailboxId: UUID!) {
    backupO365Mailbox(mailboxId: $mailboxId) {
      taskchainId
    }
  }
'''

VARIABLES = '''
{
	"mailboxId": "6b93b438-e777-49d5-86ca-ec76739a6baa"
}
'''

JSON_BODY = {
    "query": QUERY,
    "variables": VARIABLES
}

request = requests.post(gql, json=JSON_BODY, headers=headers)