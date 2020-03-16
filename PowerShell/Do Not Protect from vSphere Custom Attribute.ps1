# Need to have both PowerCLI and the Rubrik PowerShell Module installed
# Need to be connected to both vCenter Server and Rubrik

# Get all the VMs with a value of True for the custom attribute AdvBackup
$vms = Get-VM | Get-Annotation -CustomAttribute AdvBackup | Where {$_.Value -eq "True"}

foreach ($vm in $vms) {
    Get-RubrikVM -Name $vm | Protect-RubrikVM -DoNotProtect -Confirm:$false
}