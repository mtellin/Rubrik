.\Setup-Prereq.ps1

# Note: this will add a single AG, will need to update script to handle multiple AGs
# and properly add it into the $body parameter
$agName = 'am1-sql16ag-1ag'
$orgName = 'miket-test2'

$agId = (Get-RubrikAvailabilityGroup -name $agName).id
$roleId = (Get-RubrikOrganization -name $orgName).roleId
$body = '{"authorizationSpecifications":[{"privilege":"ManageRestoreSource","resources":["$agId"]}],"roleTemplate":"Organization"}'

# Using ExecutionContext to handle expanding the $agId property within the single quote
$bodyProperty = ConvertFrom-Json ($ExecutionContext.InvokeCommand.ExpandString($body))

# Git-r-done
Invoke-RubrikRESTCall -api internal -Endpoint "role/$roleId/authorization" -Method POST -Body $bodyProperty