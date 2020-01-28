# Take an on-demand backup for a specific host attached to a fileset

### Load prereq.ps1 for checking Module installation and loading credentials
& .\Setup-Prereq.ps1

$filesetName = 'Only PDFS'
$filesetHost = 'am1-miketell-w1'

Get-RubrikFileset -Name $filesetName -HostName $filesetHost | New-RubrikSnapshot