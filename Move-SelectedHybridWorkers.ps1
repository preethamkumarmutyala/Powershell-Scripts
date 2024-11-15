 # Import the necessary Azure PowerShell modules
Import-Module Az.Accounts
Import-Module Az.Automation

# Login to Azure
Connect-AzAccount

# Variables - Adjust these as needed
$sourceResourceGroup = "ITAssetManagment"
$sourceAutomationAccount = "AA-PM-DEV2"
$destinationResourceGroup = "ITAssetManagment"
$destinationAutomationAccount = "OutOfBand"

# List of selected machines to move (Hybrid Runbook Workers)
$selectedMachines = @(
    "PlayDC-01.Playdomain.loc",
    "PlayDC-02.Playdomain.loc",
    "Node-01.Playdomain.loc",
    "Node-02.Playdomain.loc",
    "Node-03.Playdomain.loc",
    "Node-04.Playdomain.loc",
    "Node-05.Playdomain.loc",
    "Node-06.Playdomain.loc"
)

# Function to move selected Hybrid Runbook Workers
function Move-SelectedHybridWorkers {
    param (
        [string]$sourceResourceGroup,
        [string]$sourceAutomationAccount,
        [string]$destinationResourceGroup,
        [string]$destinationAutomationAccount,
        [array]$selectedMachines
    )
    
    # Loop through each selected machine
    foreach ($machineName in $selectedMachines) {
        # Get Hybrid Worker Group for the machine
        $hrwGroup = Get-AzAutomationHybridWorkerGroup -ResourceGroupName $sourceResourceGroup -AutomationAccountName $sourceAutomationAccount | Where-Object { $_.Name -eq $machineName }
        
        if ($hrwGroup) {
            # Get Hybrid Worker node
            $hrwNode = Get-AzAutomationHybridWorker -ResourceGroupName $sourceResourceGroup -AutomationAccountName $sourceAutomationAccount -HybridWorkerGroupName $hrwGroup.Name | Where-Object { $_.Name -eq $machineName }
            
            if ($hrwNode) {
                # Remove node from source Automation Account
                Remove-AzAutomationHybridWorker -ResourceGroupName $sourceResourceGroup -AutomationAccountName $sourceAutomationAccount -HybridWorkerGroupName $hrwGroup.Name -Name $hrwNode.Name -Force
                
                # Register node to destination Automation Account
                Register-AzAutomationDscNode -ResourceGroupName $destinationResourceGroup -AutomationAccountName $destinationAutomationAccount -NodeConfigurationName $hrwNode.NodeConfigurationName -ConfigurationMode $hrwNode.ConfigurationMode -RebootIfNeeded $hrwNode.RebootIfNeeded -ConfigurationModeFrequencyMins $hrwNode.ConfigurationModeFrequencyMins -RefreshFrequencyMins $hrwNode.RefreshFrequencyMins
                
                Write-Output "Successfully moved $machineName to $destinationAutomationAccount."
            } else {
                Write-Output "Hybrid Worker node $machineName not found in $sourceAutomationAccount."
            }
        } else {
            Write-Output "Hybrid Worker group for $machineName not found in $sourceAutomationAccount."
        }
    }
}

# Move selected Hybrid Runbook Workers
Move-SelectedHybridWorkers -sourceResourceGroup $sourceResourceGroup -sourceAutomationAccount $sourceAutomationAccount -destinationResourceGroup $destinationResourceGroup -destinationAutomationAccount $destinationAutomationAccount -selectedMachines $selectedMachines
