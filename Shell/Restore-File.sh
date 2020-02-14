#!/bin/bash
#
# REQUIREMENTS:
#   - curl is required to interact with the API
#   - jq is required to parse JSON responses

#Set the following environment variables:
#$RUBRIK_NODE
#$RUBRIK_USER
#$RUBRIK_PASS

FILESET_ID='Fileset:::fddfc2fa-b67a-4f1c-b920-b31c45dc8661'

# Grab this from developer tools after running the restore in the UI. Copy and paste after clicking 'view source'
BODY='{"restoreConfig":[{"path":"C:\\Users\\mike.tellinghuisen\\Documents\\Critical Password List.pdf","restorePath":"c:\\temp"}],"ignoreErrors":false}'

# Swap out the ::: in fileset with %3A%3A%3A
LATEST_ID=$(curl -k -s -u "$RUBRIK_USER:$RUBRIK_PASS" -X GET "https://$RUBRIK_NODE/api/v1/fileset/"${FILESET_ID//:/$'%3A'}"" | jq -r '.snapshots[-1].id')

curl -k -s -u "$RUBRIK_USER:$RUBRIK_PASS" -X POST -d $BODY \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    "https://$RUBRIK_NODE/api/internal/fileset/snapshot/$LATEST_ID/restore_files"
