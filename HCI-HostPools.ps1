# Import the required Azure PowerShell modules
Import-Module -Name Az.Accounts
Import-Module -Name Az.HCI

# Define the function to pull Azure HCI information
function Get-AzureHCIInformation {
    <#
    .SYNOPSIS
    This function retrieves information about Azure HCI.

    .DESCRIPTION
    This function retrieves information about Azure HCI, including the name, location, and status of the HCI cluster.

    .EXAMPLE
    Get-AzureHCIInformation

    This example retrieves information about the Azure HCI cluster.

    .NOTES
    Author: CodePal
    #>

    try {
        # Connect to Azure
        Connect-AzAccount

        # Get the Azure HCI cluster
        $hciCluster = Get-AzHCICluster

        # Output the HCI cluster information
        Write-Output "Azure HCI Cluster Information:"
        Write-Output "Name: $($hciCluster.Name)"
        Write-Output "Location: $($hciCluster.Location)"
        Write-Output "Status: $($hciCluster.Status)"
    }
    catch {
        # Log the error
        Write-Error $_.Exception.Message
    }
}