# Script to search for a VM in Rubrik, list the available backups to the user and allow them to perform a Live Mount.

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

# Set the following variable for the SLA to use
$sla = '12hr-30d-Aws'

# Get all VMs in SLA
$vms = Get-RubrikVM -SLA $sla 

# Take snapshot
Write-Host ("Taking snapshots for VMs")
foreach($vm in $vms){
    New-RubrikSnapshot -id $vm.id -SLA $sla -Confirm:$false
}