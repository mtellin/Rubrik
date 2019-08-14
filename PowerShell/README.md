# Getting started

Creating a credential file (for OSX, change path to appropriate value for Windows)  

```ps
$credential = Get-Credential | Export-Clixml -path '~/.cred.xml'
```

Setting credential variable  

```ps
$credential = Import-Clixml '~/.cred.xml'
```

Authorization section for beginning of scripts
```ps
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