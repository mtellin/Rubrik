# Script to search for a VM in Rubrik, list the available backups to the user and allow them to perform a Live Mount.

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

# Change the following variables below
$source_server = 'am1-miketell-w1'
# $instance = 'MSSQLSERVER' # This is throwing an error
$source_db = 'SKOL'
$lm_db = 'SKOL_LM'

$db=Get-RubrikDatabase -Hostname $source_server -Database $source_db | where {$_.effectiveSlaDomainName -ne 'Unprotected'}
New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName $lm_db -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint) -confirm:$false

# SLEEP FOR 120 SECONDS, NEED TO USE BETTER LOGIC HERE
Start-Sleep -s 120

# BEGIN DBCC CHECK FROM LOCAL SQL SERVER
$Sql = "DBCC CHECKDB ([$lm_db]);"
$CheckDbMessages = @()
$CheckDbWatch = [System.Diagnostics.Stopwatch]::StartNew()
SQLCMD.EXE -E -Q $Sql |
ForEach-Object {
  $CheckDbMessages += $_
  "  {0:s}Z  $_" -f ([System.DateTime]::UtcNow)
}
$CheckDbWatch.Stop()

"{0:s}Z  Database [$DatabaseName] integrity check done in $($CheckDbWatch.Elapsed.ToString()) [hh:mm:ss.ddd]." -f ([System.DateTime]::UtcNow)
if ($CheckDbMessages[($CheckDbMessages.Count) - 2] -clike 'CHECKDB found 0 allocation errors and 0 consistency errors in database *') {
  "{0:s}Z  Database [$DatabaseName] integrity check is OK." -f ([System.DateTime]::UtcNow)
}
else {
  "{0:s}Z  Error in integrity check of the database [$DatabaseName]:`n  $($CheckDbMessages[($CheckDbMessages.Count) - 2])" -f ([System.DateTime]::UtcNow)
  throw "Integrity check of the database [$DatabaseName] failed."
}