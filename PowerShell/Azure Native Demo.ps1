# Connect-AzAccount

$vm = "th-win12"

$snaps = Get-AzSnapshot

foreach ($snap in $snaps | where {$_.Tags.item("rk_source_vm_name") -contains "am2-hv-win"}) {
    Write-Output $snap
}

$snaps.Tags[0].item("rk_source_vm_name") # This returns right value


$allsnaps = Get-AzSnapshot

$allsnaps.where{$_.Tags.item("rk_source_vm_name") -contains 'th-win12'}

# Build the hash table for the output
$azuresnaps = @{}

for ($snap in $allsnaps)
{
    $azuresnaps.Add($snap.Name, $snap.TimeCreated, $snap.DiskSizeGB)
}


$allsnaps | Select Name, TimeCreated, DiskSizeGB, Tags.item("rk_source_vm_name")
