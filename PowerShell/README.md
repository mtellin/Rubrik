# Getting started

Install Rubrik PowerShell Module
```powershell
Install-Module -Name Rubrik
```

Creating a credential file (for OSX, change path to appropriate value for Windows)  

```powershell
$credential = Get-Credential | Export-Clixml -path '~/.cred.xml'
```

Setting credential variable  

```powershell
$credential = Import-Clixml '~/.cred.xml'
```

Authorization section for beginning of scripts
```powershell
### Variables to set
$server = 'amer1-rbk01.rubrikdemo.com'
$credpath = '~/.cred.xml'

### Check if credential file exists, if not - prompt for credentials and save
if ((Test-Path ~/.cred.xml -PathType Leaf) -eq 'True') {
    $cred = Import-Clixml $credpath
}
else {
    $cred = Get-Credential
    $cred | Export-Clixml -Path $credpath
}

### Do not modify below this line
Connect-Rubrik $server -Credential $cred
```

Exiting the script if the Rubrik PowerShell module is not found
```powershell
### Check if Rubrik PowerShell module is installed, exit script if not
if (Get-Module -ListAvailable -Name Rubrik) {
    Write-Host "Rubrik PowerShell module found, continuing..."
} 
else {
    Write-Host "Please install the Rubrik PowerShell module first: Install-Module -Name Rubrik"
    exit
}
```