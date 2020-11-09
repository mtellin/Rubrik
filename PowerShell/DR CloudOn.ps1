# This script will initiate a CloudOn operation for a defined VM using the 
# latest snapshot, eventually will be built out to support .csv list of machines

.\Setup-Prereq.ps1

# Note: this will use a single VM to show the process but can be extended to
# loop through all VMs, a .csv list of VMs etc.
# In the event of a DR on a net-new Rubrik clsuter we could just loop through
# every VM that shows on the system after the archive reconnect process completes.
$vmName = 'am1-cent7-1'

$snapId = (Get-RubrikVM -Name $vmName | Get-RubrikSnapshot -Latest).id
$vmId = (Get-RubrikVM -name $vmName).id


# TODO: may want to add logic so its only doing this is the machine has been converted
# already using Cloud Conversion

# Used double quote for string interpolation and then escaped proper double quotes with backtick
$body = "{`"snappableId`":`"$vmId`",`"snapshotId`":`"$snapId`",`"instantiateLocationId`":`"03da9737-027f-4a4b-9ad5-f556db88cf12`",`"instanceType`":`"t2.small`",`"securityGroup`":`"sg-114c2761`",`"subnet`":`"subnet-7983c000`",`"virtualNetwork`":`"vpc-5a689d22`",`"source`":`"Snapshot`"}"

# Git-r-done - Connect the existing archive location on the cluster as a reader
Invoke-RubrikRESTCall -api internal -Endpoint "cloud_on/aws/instance" -Method POST -Body $body
