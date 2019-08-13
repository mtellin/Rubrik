# Creating a credential file (for OSX, change path to appropriate value for Windows)

```ps
$credential = Get-Credential | Export-Clixml -path '~/.cred.xml'
```

Setting credential variable  

```ps
$credential = Import-Clixml '~/.cred.xml'
```
