# This script is used to restore an Epic backup taken as a fileset

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$rHostName = 'am1-miketell-w1'
$filesetName = 'Only PDFS'

# Will always be restoring the same config so hard coding the source path to restore from and the destination path to restore to.
# Grab this directly from Chrome Developer Tools, copy the source JSON at the bottom of headers.
$body = ConvertFrom-Json '{"restoreConfig":[{"path":"C:\\temp","restorePath":"C:\\temp2"}],"ignoreErrors":false}'

### NOTHING SHOULD NEED TO BE MODIFIED BELOW THIS LINE

$filesetId = $(Get-RubrikFileset -Name $filesetName -HostName $rHostName).id

# Only care about the latest snapshot, and need the ID to pass into the REST call to restore files
$latestId = $(Get-RubrikFileset -id $filesetId | Get-RubrikSnapshot)[-1].id

Invoke-RubrikRESTCall -api internal -Endpoint "fileset/snapshot/$latestId/restore_files" -Method POST -Body $body