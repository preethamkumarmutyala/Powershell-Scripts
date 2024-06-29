# Parameters
$vmName = "NewVMName"         # Name of the new VM
$vmMemory = 4GB               # Memory size for the VM
$vhdxPath = "D:\Path\To\Your\VHDXFile.vhdx"   # Path to the existing VHDX file
$vmPath = "D:\Hyper-V\$vmName"  # Path where the VM configuration will be stored
$switchName = "PrivateSwitch"  # Name of the virtual switch to connect the VM to

# Create the VM
New-VM -Name $vmName -MemoryStartupBytes $vmMemory -Path $vmPath

# Add IDE controller if not already present
$ideController = Get-VM $vmName | Get-VMHardDiskDrive | Where-Object { $_.ControllerType -eq 'IDE' }

if (-not $ideController) {
    Add-VMHardDiskDrive -VMName $vmName -ControllerType IDE -Path $vhdxPath
} else {
    Write-Output "IDE controller already exists. Attaching VHDX to the existing controller."
    Add-VMHardDiskDrive -VMName $vmName -ControllerNumber 0 -ControllerLocation 0 -Path $vhdxPath
}

# Connect the VM to the network switch
Add-VMNetworkAdapter -VMName $vmName -SwitchName $switchName

# Optionally, set the number of virtual processors
Set-VMProcessor -VMName $vmName -Count 2

# Start the VM
Start-VM -Name $vmName

Write-Output "VM '$vmName' created and started successfully."
