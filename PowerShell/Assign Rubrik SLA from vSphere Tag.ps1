# TODO: Need to add the pre-req line for both Rubrik PS Module/auth as well as vCenter

# Update both vsphereTag and rubrikSla with the names you plan to read from (vSphere Tag)
# and SLA name you plan to apply to the VMs (rubrikSla)
$vsphereTag = "vSphere Gold"
$rubrikSla = "Rubrik Gold"

# Don't need to modify below this line
$vms = get-VM -Tag $vsphereTag

foreach ($vm in $vms) {
    Get-RubrikVM -Name $vm | Protect-RubrikVM -SLA $rubrikSla -Confirm:$false
}