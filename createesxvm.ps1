# Set ESXi server connection details
$ESXiServer = "172.16.76.40"
$ESXiUsername = "root"
$ESXiPassword = "L0c@1@cces$"

# Connect to ESXi server
Connect-VIServer -Server $ESXiServer -User $ESXiUsername -Password $ESXiPassword -Force

# Define the template and new VM names
$templateVMName = "Template-2022"
$newVMName = "New-VM-Name"

# Function to log output
function Log-Output {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp - $message"
}

try {
    Log-Output "Connected to ESXi server $ESXiServer."

    # Retrieve the template VM
    $templateVM = Get-VM -Name $templateVMName
    if ($templateVM -eq $null) {
        throw "Template VM '$templateVMName' not found."
    }
    Log-Output "Template VM '$templateVMName' found."

    # Retrieve the datastore of the template VM
    $datastore = Get-Datastore -VM $templateVM
    if ($datastore -eq $null) {
        throw "Datastore for template VM '$templateVMName' not found."
    }
    $datastoreName = $datastore.Name
    Log-Output "Datastore '$datastoreName' found for template VM."

    # Clone the template VM to create a new VM on the same datastore
    New-VM -Name $newVMName -VM $templateVM -Datastore $datastoreName -Confirm:$false -ErrorAction Stop
    Log-Output "New VM '$newVMName' created successfully from template '$templateVMName'."

    # Power on the new VM
    Start-VM -VM $newVMName -Confirm:$false
    Log-Output "New VM '$newVMName' powered on successfully."
} catch {
    Log-Output "Error: $($_.Exception.Message)"
} finally {
    # Disconnect from ESXi server
    Disconnect-VIServer -Server $ESXiServer -Confirm:$false
    Log-Output "Disconnected from ESXi server."
}
