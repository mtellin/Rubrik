# Script to take input of a server name and file/folder name and return only the modified versions to allow the user to restore from/export etc.

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

# Get VM search term from user
$vminput = Read-Host -Prompt 'Enter the VM name to restore files from'
Write-Host "Searching for available VMs for '$vminput'..."

# Return list of VMs in case of more than 1 match
$global:i=0
Get-RubrikVM | Where-Object {$_.name -like "*$vminput*"} | Select-Object @{Name="Item";Expression={$global:i++;$global:i}}, name, id -OutVariable vmmenu | format-table -AutoSize
$vmlist = Read-Host "Select the VM to use"
$vm = $vmmenu | Where-Object {$_.item -eq $vmlist}
$vmId = $vm.id

# Grab the file/folder to search for
$fileinput = Read-Host -Prompt 'Enter the file name to search for'
Write-Host "Seaching for '$fileinput' on '$vminput'..."

#Build the URL for API call
$uri = "search?managed_id=$vmId&query_string=$fileinput"

#$result = Invoke-RubrikRESTCall -Endpoint 'search?managed_id=VirtualMachine:::5ed1b046-0bd9-4468-a67c-3293f15f27ed-vm-107&query_string=Critical&20password%20List%2Epdf' -Method 'GET' -api internal
$result = Invoke-RubrikRESTCall -Endpoint $uri -Method 'GET' -api internal

# Prompt for just path, filename to show to user
$result.data | Select-Object path, filename
$global:i=0
# Passing through the fileVersions variable so we can display it later but only outputting line #, path and filename here
$result.data | Select-Object @{Name="Item";Expression={$global:i++;$global:i}}, path, filename, fileVersions -OutVariable filemenu | format-table -Property item, path, filename -AutoSize
$filelist = Read-Host "Select the file to use"
$file = $filemenu | Where-Object {$_.item -eq $filelist}

$uniqueVersions = $file.fileVersions | select-Object -Property lastModified, size, snapshotId -Unique
$uniqueCount = $uniqueVersions.length

Write-Host "The file $fileinput was found with $uniqueCount versions, last modified dates are: "
#Write-Host ($uniqueVersions | Format-Table -AutoSize | Out-String)

$uniqueVersions | Select-Object @{Name="Item";Expression={$global:i++;$global:i}}, lastModified, size, snapshotId -OutVariable restoremenu | format-table -Property Item, lastModified, size -AutoSize
$restorelist = Read-Host "Select the version to restore"
$restore = $restoremenu | Where-Object {$_.item -eq $restorelist}

$filePath = $file.path

# Create nested JSON body for the export_files API call
$restorePath = Read-Host -Prompt 'Enter the path to restore to: '
#$fileUser = Read-Host -Prompt 'Enter the username for restoring the file: '
#$filePass = Read-Host -Prompt 'Enter the password for restoring the file: '
#$fileDomain = Read-Host -Prompt 'Enter the domain: '
#$body = New-Object -TypeName PSObject -Property @{'path'=$filepath;'restorePath'=$restorePath;'domainName'=$fileDomain;'username'=$fileUser;'password'=$filePass;'shouldSaveCredentials'=$false}
$body = New-Object -TypeName PSObject -Property @{'path'=$filepath;'restorePath'=$restorePath;'domainName'='';'username'='';'password'='';'shouldSaveCredentials'=$false}

# Initiate restore
$snapId = $restore.snapshotId
Invoke-RubrikRESTCall -Endpoint "vmware/vm/snapshot/$snapId/restore_file" -Method POST -Body $body
