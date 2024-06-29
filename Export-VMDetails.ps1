# Define the export path
$exportPath = "D:\VMExport"

# Create the export directory if it doesn't exist
if (-Not (Test-Path -Path $exportPath)) {
    New-Item -Path $exportPath -ItemType Directory | Out-Null
}

# Get the list of all VMs
$vms = Get-VM

foreach ($vm in $vms) {
    $vmName = $vm.Name
    $vmDetailsPath = "$exportPath\$vmName-Details.json"

    # Get VM details
    $vmDetails = @{
        VMName = $vm.Name
        VHDPath = (Get-VMHardDiskDrive -VMName $vm.Name).Path
        MemoryStartupBytes = $vm.MemoryStartupBytes
        ProcessorCount = $vm.ProcessorCount
        SwitchName = (Get-VMNetworkAdapter -VMName $vm.Name).SwitchName
        IDEDrives = Get-VMHardDiskDrive -VMName $vm.Name -ControllerType IDE | Select-Object ControllerLocation, Path
        SCSIDrives = Get-VMHardDiskDrive -VMName $vm.Name -ControllerType SCSI | Select-Object ControllerLocation, Path
    }

    # Save VM details to a JSON file
    $vmDetails | ConvertTo-Json | Out-File -FilePath $vmDetailsPath

    # Export the VM configuration and state
    Export-VM -Name $vmName -Path "$exportPath\$vmName"
    Write-Output "Exported VM: $vmName"
}

Write-Output "All VMs have been exported to $exportPath"
