# Import necessary modules
Import-Module ActiveDirectory

# Define Azure Service Principal credentials
$tenantId = "40ed1e38-a16e-4622-9d7c-45161b6969d5"           # Tenant ID
$clientId = "3ac6a01a-1564-4043-8fc9-7a9903f7dbed"         # Client ID
$clientSecret = "Bbk8Q~CLZ2qmhtaAdsU5yBGtZZ4GrWyKde1RgbP~" # Client Secret
$subscriptionId = "733cdb1e-7b27-496a-a4af-d72f76a44aeb"  # Your subscription ID

# Authenticate to Azure using the service principal
$secureSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $secureSecret
Connect-AzAccount -ServicePrincipal -TenantId $tenantId -ApplicationId $clientId -SubscriptionId $subscriptionId -Credential $creds

# Define the tag mappings
$tagMappings = @{
    "AZ-Update Jumpbox" = @{ Key = "AUM-Name"; Value = "Jumpbox" }
    "AZ-Update Low"     = @{ Key = "AUM-Name"; Value = "Low" }
    "AZ-Update Medium"  = @{ Key = "AUM-Name"; Value = "Medium" }
    "AZ-Update PAWS"    = @{ Key = "AUM-Name"; Value = "PAWS" }
}

# Step 1: Process each tag group
foreach ($groupName in $tagMappings.Keys) {
    $tagInfo = $tagMappings[$groupName]
    $tagKey = $tagInfo.Key
    $tagValue = $tagInfo.Value

    # Get the computer objects from the on-prem AD DL
    $computersInDL = Get-ADGroupMember -Identity $groupName -Recursive | Where-Object { $_.objectClass -eq "computer" }

    # Store the list of computer names
    $computerNames = $computersInDL | Select-Object -ExpandProperty Name

    # Step 2: Get the list of Azure Arc-enabled machines
    $arcMachines = Get-AzResource -ResourceType "Microsoft.HybridCompute/machines"

    # Step 3: Loop through each computer in the DL and check if it exists in Azure Arc
    foreach ($computer in $computerNames) {
        # Find matching Azure Arc machine
        $arcMachine = $arcMachines | Where-Object { $_.Name -eq $computer }

        if ($arcMachine) {
            # Retrieve current tags
            $existingTags = $arcMachine.Tags

            # Check if the tag already exists and matches the desired value
            if ($existingTags.ContainsKey($tagKey) -and $existingTags[$tagKey] -eq $tagValue) {
                Write-Host "Skipping $computer - Tag '$tagKey' with value '$tagValue' already exists."
            } else {
                # If the tag doesn't exist or has a different value, update the tag
                Write-Host "Tagging Azure Arc machine: $($arcMachine.Name) with $tagKey=$tagValue"

                # Add or update the new tag
                $updatedTags = $existingTags + @{ $tagKey = $tagValue }

                # Apply updated tags using Set-AzResource
                Set-AzResource -ResourceId $arcMachine.ResourceId -Tag $updatedTags -Force
            }
        } else {
            Write-Host "Azure Arc machine not found for: $computer"
        }
    }

    Write-Host "Tagging process completed for group: $groupName."
}

Write-Host "All tagging processes completed."
