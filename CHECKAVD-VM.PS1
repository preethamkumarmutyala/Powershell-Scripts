# Ask for the VM name to search for
$vmName = Read-Host -Prompt "Enter the VM name you want to search for"

# Define the clusters with their FQDNs
$clusterFQDNs = @(
    "INASHCI-CL-A1.hv.cvlt.net",
    "INASHCI-CL-B1.hv.cvlt.net",
    "USASHCI-CL-A.hv.cvlt.net",
    "USASHCI-CL-B.hv.cvlt.net",
    "USASHCI-CL-C.hv.cvlt.net",
    "USASHCI-CL-D.hv.cvlt.net",
    "USASHCI-CL-E.hv.cvlt.net",
    "USASHCI-CL-F.hv.cvlt.net",
    "USASHCI-CL-X.hv.cvlt.net",
    "USASHCI-CL-Y.hv.cvlt.net",
    "USASHCI-CL-Z.hv.cvlt.net"
)

# Loop through each cluster
foreach ($clusterFQDN in $clusterFQDNs) {
    Write-Host "Checking cluster: $clusterFQDN"
    
    # Get all nodes in the current cluster
    $nodes = Get-ClusterNode -Cluster $clusterFQDN
    
    # Loop through each node in the cluster
    foreach ($node in $nodes) {
        # Get all VMs on the current node
        $vms = Get-VM -ComputerName $node.Name

        # Check if the desired VM exists on this node
        foreach ($vm in $vms) {
            if ($vm.Name -eq $vmName) {
                Write-Host "VM '$vmName' found on cluster: $($clusterFQDN) and host: $($node.Name)"
                break
            }
        }
    }
}
