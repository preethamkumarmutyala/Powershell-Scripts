# Load VMware PowerCLI module
Import-Module VMware.VimAutomation.Core

# ESXi server details
$esxiServer = "172.16.59.40"
$username = "root"
$password = "L0c@1@cces$"

# Template name
$templateName = "Template-10"

# Connect to the ESXi server
Connect-VIServer -Server $esxiServer -User $username -Password $password

# List all VMs and check if the template exists
$allVMs = Get-VM
$template = $allVMs | Where-Object { $_.Name -eq $templateName -and $_.ExtensionData.Config.Template -eq $true }

if ($template -eq $null) {
    Write-Host "Template '$templateName' not found."
    Disconnect-VIServer -Server $esxiServer -Confirm:$false
    exit
}

# Gather template details
$templateInfo = @{
    Name       = $template.Name
    Datastore  = (Get-Datastore -Id $template.ExtensionData.Config.Datastore[0]).Name
    Cluster    = (Get-Cluster -Id $template.ExtensionData.Runtime.Host[0].Parent).Name
    ResourcePool = (Get-ResourcePool -Id $template.ExtensionData.ResourcePool).Name
}

Write-Host "Template Details:"
$templateInfo | Format-Table -AutoSize

# Create 19 VMs
for ($i = 2; $i -le 20; $i++) {
    $vmName = "Node-{0:D2}" -f $i
    Write-Host "Creating VM: $vmName"

    # Clone the VM from the template
    New-VM -Name $vmName -Template $template -VMHost (Get-VMHost -Location (Get-Cluster -Name $templateInfo.Cluster) | Get-Random) `
           -Datastore (Get-Datastore -Name $templateInfo.Datastore) -ResourcePool (Get-ResourcePool -Name $templateInfo.ResourcePool)

    Write-Host "VM $vmName created successfully."
}

# Disconnect from the ESXi server
Disconnect-VIServer -Server $esxiServer -Confirm:$false
