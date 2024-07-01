# Define the old and new switch names
$oldSwitchName = "1Touchnvmedell"
$newSwitchName = "PrivateSwitch"

# Get all VMs
$vms = Get-VM

# Loop through each VM
foreach ($vm in $vms) {
    # Get the network adapters for the VM
    $adapters = Get-VMNetworkAdapter -VM $vm
    
    foreach ($adapter in $adapters) {
        # Check if the adapter is connected to the old switch
        if ($adapter.SwitchName -eq $oldSwitchName) {
            # Change the adapter to the new switch
            Connect-VMNetworkAdapter -VMNetworkAdapter $adapter -SwitchName $newSwitchName
            Write-Output "Changed switch for VM '$($vm.Name)' from '$oldSwitchName' to '$newSwitchName'"
        }
    }
}
