# Instant Recovery script

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$rubrik=@()

# Read in a text file containing simply a list of server names that we will build out a PS array for
$servers = (get-content .\VM-List.txt)
foreach ($s in $servers) {
  $rubrik += New-Object -TypeName psobject -Property @{vmName=$s; snapId=""; vmId=""; hostId=""}
}  

ForEach ($r in $rubrik) {
  $r.vmId = ($(Get-RubrikVM -Name $r.vmName).id)
  $r.snapId = $(Get-RubrikSnapshot -id $r.vmId)[0].id
  $r.hostId = ($(Get-RubrikVM -Name $r.vmName).hostId)
  $body = New-Object -TypeName PSObject -Property @{'snapshotId'=$($r.snapId);'hostId'=$($r.hostId);'preserveMoid'=$false;'removeNetworkDevices'=$false;'keepMacAddresses'=$false;'shouldRecoverTags'=$true}
  $response = Invoke-RubrikRESTCall -Endpoint "vmware/vm/$($r.vmId)/instant_recover" -Method POST -Body $body -api 2
}

Write-Host "Relocating storage from Rubrik to Production"
Start-Sleep -Seconds 30

#do {
#    $status = (Get-RubrikEvent | where {$_.jobinstanceid -eq $response.id -and $_.eventStatus -ne "TaskSuccess"})

#} While ($status.count -ne 0) {
#    Write-host "Waiting for 15 seconds for jobs to finish"
#    Start-Sleep -Seconds 15
#}

ForEach ($r in $rubrik) {
  $datastore = ((Get-RubrikVMwareHost | where {$_.id -eq $r.hostId}).datastores | where {$_.islocal -eq $false} | get-random).id
  $body = New-Object -TypeName PSObject -Property @{'datastoreId'=$datastore}
  Invoke-RubrikRESTCall -Endpoint "vmware/vm/snapshot/mount/$((Get-RubrikMount | where {$_.vmId -eq $r.vmId}).id)/relocate" -Method POST -Body $body
}


$test = New-Object -TypeName PSObject -Property @{'snapshotId'=$($r.snapId);'hostId'=$($r.hostId);'preserveMoid'=$false;'removeNetworkDevices'=$false;'keepMacAddresses'=$false;'shouldRecoverTags'=$true}
$test2 = New-Object -TypeName PSObject -Property @{
  'snapshotId'=$($r.snapId);
  'hostId'=$($r.hostId);
  'preserveMoid'=$false;
  'removeNetworkDevices'=$false;
  'keepMacAddresses'=$false;
  'shouldRecoverTags'=$true
}