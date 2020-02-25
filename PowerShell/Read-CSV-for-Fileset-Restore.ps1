# This script is used to restore an Epic backup taken as a fileset
# It will look for a CSV named inputs.csv in the same location as the .ps1 script
# Format of the inputs.csv should look like:
# srcPath,dstPath
# /home/test.txt,/tmp
# /home/folder1,/tmp

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

# Browse to the filest in the GUI and in the URL it will display the fileset ID
$filesetId = 'Fileset:::fddfc2fa-b67a-4f1c-b920-b31c45dc8661'

$restore = Import-Csv -Path .\inputs.csv

# Loop through the rows in inputs.csv to build the restore body
$body = @{}
foreach ($r in $restore) {
    $body["restoreConfig"] += @(
        @{
            "path" = $r.path
            "restorePath" = $r.restorePath
        }
    )
}
$body["ignoreErrors"] = $false

# Only care about the latest snapshot, and need the ID to pass into the REST call to restore files
$latestId = $(Get-RubrikFileset -id $filesetId | Get-RubrikSnapshot)[-1].id

Invoke-RubrikRESTCall -api internal -Endpoint "fileset/snapshot/$latestId/restore_files" -Method POST -Body $body