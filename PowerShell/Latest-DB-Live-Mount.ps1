# Script to search for a VM in Rubrik, list the available backups to the user and allow them to perform a Live Mount.

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

# Change the following variables below
$source_server = 'am1-miketell-w1'
# $instance = 'MSSQLSERVER' # This is throwing an error
$source_db = 'SKOL'
$lm_db = 'SKOL_LM'


# Making sure we don't grab a relic/unprotected database as if it returns 2 values the mount will fail
$db = Get-RubrikDatabase -Hostname $source_server -Name $source_db | where {$_.effectiveSlaDomainName -ne 'Unprotected'}
New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName $lm_db -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint) -confirm:$false

# Removing live mount
# Get-RubrikDatabaseMount -MountedDatabaseName $lm_db | Remove-RubrikDatabaseMount -Confirm:$false