# Load the required modules
Import-Module FailoverClusters
Import-Module Hyper-V

# Define the cluster name
$clusterName = "IDCHYVCL-02.gp.cv.commvault.com"

# Function to get the VM count in the cluster
function Get-VMCountInCluster {
    param (
        [string]$clusterName
    )

    try {
        # Connect to the cluster
        $cluster = Get-Cluster -Name $clusterName -ErrorAction Stop
        
        # Get all cluster nodes
        $clusterNodes = Get-ClusterNode -Cluster $cluster
        
        # Initialize VM count
        $vmCount = 0
        
        # Loop through each node and count the VMs
        foreach ($node in $clusterNodes) {
            try {
                # Run the VM count check locally
                $nodeVMs = Invoke-Command -ComputerName $node.Name -ScriptBlock {
                    Get-VM | Measure-Object | Select-Object -ExpandProperty Count
                }
                $vmCount += $nodeVMs
            } catch {
                Write-Host "Failed to get VMs from node ${node.Name}. Error: $_" -ForegroundColor Red
            }
        }

        Write-Host "Total number of VMs in cluster ${clusterName}: $vmCount" -ForegroundColor Green
    } catch {
        Write-Host "Failed to get VM count for cluster ${clusterName}. Error: $_" -ForegroundColor Red
    }
}

# Get the VM count in the specified cluster
Get-VMCountInCluster -clusterName $clusterName
