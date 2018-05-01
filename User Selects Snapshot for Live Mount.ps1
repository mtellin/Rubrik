# Script to search for a VM in Rubrik, list the available backups to the user and allow them to perform a Live Mount.

# Get VM search term from user
$vminput = Read-Host -Prompt 'Enter the VM name to display available Live Mount options'
Write-Host "Searching for available live mounts for '$vminput'..."

# Return list of backups from the VM
$vm = Get-RubrikVM | where {$_.name -like "*$vminput*"}
# Iterate through results, use a counter to number the output for easier user selection
$global:i=0
get-rubriksnapshot $vm.id | select @{Name="Item";Expression={$global:i++;$global:i}}, date, consistencyLevel,
vmName, id -outvariable menu | format-table -AutoSize
$r = Read-Host "Select a snapshot to live mount"
$snap = $menu | where {$_.item -eq $r}
Write-Host "Live mounting " $snap.id

# Initiate Live Mount
New-RubrikMount -id $snap.id -confirm:$false
