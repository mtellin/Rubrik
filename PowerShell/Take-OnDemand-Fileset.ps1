# Take an on-demand backup for a specific host attached to a fileset

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$filesetName = 'Only PDFS'
$filesetHost = 'am1-miketell-w1'
$slaName = '12hr-30d-Azure'

$output = Get-RubrikFileset -Name $filesetName -HostName $filesetHost | New-RubrikSnapshot -SLA $slaName -confirm:$false

# Loop every 60 seconds to check the status of the backup, print completed when finished.
while ((Invoke-RubrikRESTCall -endpoint ("fileset/request/" + $output.id) -Method GET).status -ne 'SUCCEEDED') {
    Write-Host 'Backup in progress...'
    Start-Sleep -Seconds 60
}
Write-Host 'Backup completed!'

# Check the status of the backup once completed
# Still a work in progress below
$eventseries = (Invoke-RubrikRESTCall -api internal -Endpoint event_series -Method GET).data
$eventseries | where { $_.jobInstanceId -eq “$($output.id)” }