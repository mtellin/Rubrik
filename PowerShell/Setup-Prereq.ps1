### This script utilizes 2 files that will be created for you if they do not
### exist, ~/.cred.xml for a hashed user/password for authentication and 
### ~/.rbkcfg.json that has configuration options such as Rubrik cluster name
### to connect to.

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
    $cred = Import-Clixml '~/.cred.xml'
}
else {
    $cred = Get-Credential
    $cred | Export-Clixml -Path '~/.cred.xml'
}

### Check if configuration file exists, if not - prompt for server name and save
if ((Test-Path '~/.rbkcfg.json' -PathType Leaf) -eq 'True') {
    $rbkcfg = Get-Content -path '~/.rbkcfg.json' -Raw | ConvertFrom-Json
}
else {
    $rbkcfg = @{}
    $rbkcfg.server = Read-Host -Prompt 'Enter the Rubrik cluster FQDN: '
    $rbkcfg | ConvertTo-Json | Set-Content '~/.rbkcfg.json' -Encoding Unicode
}

Connect-Rubrik $rbkcfg.server -Credential $cred