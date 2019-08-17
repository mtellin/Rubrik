# Script to Register RBS on all VMs that are powered on.

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$vms = Get-RubrikVM | where {$_.powerStatus -eq "poweredOn"}
Foreach ($vm in $vms) {
    $id = [System.Web.HttpUtility]::UrlEncode($vm.id)
    Write-Host "Registering VM with name" $vm.name "and ID of "$id
    # Added SilentlyContinue to not break out of script on VMs that don't have RBS installed
    Invoke-RubrikRESTCall -Endpoint "vmware/vm/$id/register_agent" -Method POST -ErrorAction SilentlyContinue