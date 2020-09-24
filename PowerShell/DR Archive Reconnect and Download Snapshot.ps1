# This script will attach an archive reader and restore the latest snapshot
# from the VM on the archive

.\Setup-Prereq.ps1

# Note: this will use a single VM to show the process but can be extended to
# loop through all VMs, a .csv list of VMs etc.
# In the event of a DR on a net-new Rubrik clsuter we could just loop through
# every VM that shows on the system after the archive reconnect process completes.
$vmName = 'sx1-win16-2'
$encryptionKey = Read-Host -Prompt 'Enter your encryption key for the archive'
$bucketName = Read-Host -Prompt 'Enter the S3 bucket name'
$s3AccessKey = Read-Host -Prompt 'Enter your S3 Access Key'
$s3SecretKey = Read-Host -Prompt 'Enter your S3 Secret Key'

#$agId = (Get-RubrikAvailabilityGroup -name $agName).id
#$roleId = (Get-RubrikOrganization -name $orgName).roleId
$body = '{"secretKey":'$s3SecretKey',"defaultRegion":"us-west-2","pemFileContent":'$encryptionKey',"bucket":'$bucketName',"storageClass":"STANDARD","accessKey":'$s3AccessKey',"name":"S3:'$bucketName'","objectStoreType":"S3","shouldRecoverSnappableMetadataOnly":true}'


# Using ExecutionContext to handle expanding the $bucketName etc property within the single quote
$bodyProperty = ConvertFrom-Json ($ExecutionContext.InvokeCommand.ExpandString($body))

# Git-r-done - Connect the existing archive location on the cluster as a reader
Invoke-RubrikRESTCall -api internal -Endpoint "archive/object_store/reader/connect" -Method POST -Body $bodyProperty

# Need to loop here for a job for fetching metadata from archive
# Looks like the Last Refreshed time on the archive location, perhaps the loop will check for that

# For the object(s) we will get the Rubrik snapshot ID so that we can initiate the download
# from archive location on the next step
$snapId = (Get-RubrikUnmanagedObject -Name $vmName | Get-RubrikSnapshot -Latest).id

# POST but it's an empty body that is sent
Invoke-RubrikRESTCall -api 1 -Endpoint "vmware/vm/snapshot/$snapId/download" -Method POST

# this will create an event under that object ($vmName) for downloading the snapshot, loop through until this activity completes

# Once the download is complete the next step would be to move to whatever type of 
# restore is needed - live mount and storage vMotion, Export etc