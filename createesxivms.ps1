# Prompt for vCenter IP, template name, and VM creation details
$vCenterIP = Read-Host "Enter the vCenter IP Address"
$templateName = Read-Host "Enter the Template Name"
$vmCount = [int](Read-Host "Enter the number of VMs to create")

# Connect to the vCenter
$vCenterUser = Read-Host "Enter your vCenter username (e.g. administrator@vsphere.local)"
$vCenterPassword = Read-Host "Enter your vCenter password" -AsSecureString
Connect-VIServer -Server $vCenterIP -User $vCenterUser -Password $vCenterPassword

# Initialize an array to hold VM names
$vmNames = @()

# Loop to collect VM names
for ($i = 1; $i -le $vmCount; $i++) {
    $vmName = Read-Host "Enter the name for VM $i"
    $vmNames += $vmName
}

# Prompt to select the target ESXi host and datastore
$targetHost = Get-VMHost | Out-GridView -Title "Select the Target ESXi Host" -PassThru
$targetDatastore = Get-Datastore | Out-GridView -Title "Select the Target Datastore" -PassThru

# Clone VMs from the template
foreach ($vmName in $vmNames) {
    try {
        Write-Host "Cloning $vmName from template $templateName..."
        
        # Use the New-VM cmdlet to clone the VM on the selected ESXi host and datastore
        New-VM -Name $vmName -VM $templateName -VMHost $targetHost -Datastore $targetDatastore
        
        Write-Host "Successfully created VM $vmName"
    } catch {
        Write-Host "Failed to create VM $vmName"
        Write-Host "Error: $($Error[0].Exception.Message)"
    }
}

# Disconnect from the vCenter
Disconnect-VIServer -Confirm:$false
