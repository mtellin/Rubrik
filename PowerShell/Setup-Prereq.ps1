### Set variable for location of credential file
$credpath = '~/.cred.xml'

### Check if Rubrik PowerShell module is installed, exit script if not
if (Get-Module -ListAvailable -Name Rubrik) {
    Write-Host "Rubrik PowerShell module found, continuing..."
} 
else {
    Write-Host "Please install the Rubrik PowerShell module first: Install-Module -Name Rubrik"
    exit
}

### Check if credential file exists, if not - prompt for credentials and save
if ((Test-Path '~/.cred.xml' -PathType Leaf) -eq 'True') {
    $cred = Import-Clixml $credpath
}
else {
    $cred = Get-Credential
    $cred | Export-Clixml -Path $credpath
}

return $cred