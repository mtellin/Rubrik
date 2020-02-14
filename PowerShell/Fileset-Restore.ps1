# This script is used to restore an Epic backup taken as a fileset

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$filesetId = 'Fileset:::fddfc2fa-b67a-4f1c-b920-b31c45dc8661'

# Will always be restoring the same config so hard coding the source path to restore from and the destination path to restore to.
$body = ConvertFrom-Json '{"restoreConfig":[{"path":"C:\\temp","restorePath":"C:\\temp2"}],"ignoreErrors":false}'

# Only care about the latest snapshot, and need the ID to pass into the REST call to restore files
$latestId = $(Get-RubrikFileset -id $filesetId | Get-RubrikSnapshot)[-1].id

Invoke-RubrikRESTCall -api internal -Endpoint "fileset/snapshot/$latestId/restore_files" -Method POST -Body $body