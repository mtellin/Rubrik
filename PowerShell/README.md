# Getting started

## Install Rubrik PowerShell Module

```powershell
Install-Module -Name Rubrik
```

## Authentication and Configuration Options

When running these scripts, it will call the `Setup-Prereq.ps1` file. This will check if the Rubrik PowerShell Module is installed (and exit the script if it isn't). Then it will check for a credential file in the user's home directory. If it exists it will use that for authentication - if not, it will prompt the user for user/pass and create the file for you. Lastly, it will prompt for the Rubrik Cluster to connect to and save this value to a configuration file in the users home directory as well.  
  
One thing to be aware of, you'll want to be in the working directory (Rubrik/PowerShell) when you call the scripts. When they look for the `Setup-Prereq.ps1` file it will default to the current working directory.  
