# Get all VMs
$vms = Get-VM

# Iterate over each VM to retrieve IP addresses
foreach ($vm in $vms) {
    $vmName = $vm.Name
    $vmNetworkAdapters = Get-VMNetworkAdapter -VMName $vmName
    
    $ipv4Addresses = @()

    foreach ($adapter in $vmNetworkAdapters) {
        # Query IP addresses using the network adapter details
        $adapterIPAddresses = (Get-VMNetworkAdapter -VMName $vmName -Name $adapter.Name).IPAddresses

        if ($adapterIPAddresses) {
            # Filter to include only IPv4 addresses
            $ipv4Addresses += $adapterIPAddresses | Where-Object { $_ -match '^\d{1,3}(\.\d{1,3}){3}$' }
        }
    }

    $ipv4Addresses = $ipv4Addresses -join ", "
    if ([string]::IsNullOrEmpty($ipv4Addresses)) {
        $ipv4Addresses = "Not available"
    }

    Write-Output "VM Name: $vmName, IPv4 Address(es): $ipv4Addresses"
}
