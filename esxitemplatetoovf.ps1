# Define variables
$vCenterServer = 'blrvsavc.idcprodcert.loc'
$vCenterUser = 'administrator@vsphere.local'
$vCenterPassword = 'L0c@1@cces$'
$localExportPath = 'e:\ESXI-OVF'
$templateNames = @(
    'Rocky_Linux-8.8',
    'Template_RHEL-09',
    'centos7',
    'CV_VLAB_GATEWAY_CENTOS79_STORE',
    'Template-Win-2019-ESX01',
    'Template_Win_2022-ESX01',
    'Windows 2016 (KDESAI)'
)

# Connect to vCenter server
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPassword

# Ensure the export directory exists
if (-not (Test-Path -Path $localExportPath)) {
    New-Item -Path $localExportPath -ItemType Directory
}

# Export templates to OVF
foreach ($templateName in $templateNames) {
    $template = Get-Template | Where-Object { $_.Name -eq $templateName }
    if ($template) {
        Write-Host "Exporting template: $templateName"
        $destinationPath = Join-Path -Path $localExportPath -ChildPath "$templateName"
        # Ensure the template directory exists
        if (-not (Test-Path -Path $destinationPath)) {
            New-Item -Path $destinationPath -ItemType Directory
        }
        # Export the template as OVF
        Export-VApp -VM $template -Destination $destinationPath -Format OVF
    } else {
        Write-Host "Template not found: $templateName"
    }
}

# Disconnect from vCenter server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
