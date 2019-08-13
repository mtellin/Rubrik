# Script to search for a VM in Rubrik, list the available backups to the user and allow them to perform a Live Mount.

### Variables to set
$cred = Import-Clixml ('~/.cred.xml')
$server = 'amer1-rbk01.rubrikdemo.com'

### Do not modify below this line
Connect-Rubrik $server -Credential $cred

# Get VM search term from user
$vminput = Read-Host -Prompt 'Enter the VM name to display available Live Mount options'
Write-Host "Searching for available live mounts for '$vminput'..."

# Return list of VMs in case of more than 1 match
$global:i=0
Get-RubrikVM | where {$_.name -like "*$vminput*"} | Select-Object @{Name="Item";Expression={$global:i++;$global:i}}, name, id -OutVariable vmmenu | format-table -AutoSize
$vmlist = Read-Host "Select the VM to use"
$vm = $vmmenu | where {$_.item -eq $vmlist}

# Iterate through results, use a counter to number the output for easier user selection
$global:i=0
get-rubriksnapshot $vm.id | Select-Object @{Name="Item";Expression={$global:i++;$global:i}}, date, consistencyLevel,
vmName, id -outvariable snapmenu | format-table -AutoSize
$snaplist = Read-Host "Select a snapshot to live mount"
$snap = $snapmenu | where {$_.item -eq $snaplist}
Write-Host "Live mounting " $snap.id

# Initiate Live Mount
New-RubrikMount -id $snap.id -confirm:$false