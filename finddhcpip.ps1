# Function to convert an IP address to a long integer for comparison
function ConvertTo-IntIP {
    param (
        [string]$ipAddress
    )
    
    $octets = $ipAddress -split '\.'
    [int64]($octets[0]) * 16777216 + [int64]($octets[1]) * 65536 + [int64]($octets[2]) * 256 + [int64]($octets[3])
}

# Prompt the user to enter the MAC address
$macAddress = Read-Host -Prompt "Enter the MAC Address (format: 00-15-5D-3F-0C-55)"

# Prompt the user to enter the DHCP server address or name
$dhcpServer = Read-Host -Prompt "Enter the DHCP Server Address or Name"

# Initialize the found flag
$found = $false

# Fetch all DHCP scopes from the specified DHCP server
$scopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer

# Iterate through each scope to find the MAC address
foreach ($scope in $scopes) {
    $leases = Get-DhcpServerv4Lease -ComputerName $dhcpServer -ScopeId $scope.ScopeId

    foreach ($lease in $leases) {
        if ($lease.ClientId -eq $macAddress) {
            # Convert IP addresses to integers for comparison
            $startRange = ConvertTo-IntIP $scope.StartRange
            $endRange = ConvertTo-IntIP $scope.EndRange
            $leaseIP = ConvertTo-IntIP $lease.IPAddress

            if ($leaseIP -ge $startRange -and $leaseIP -le $endRange) {
                $found = $true
                Write-Host "Match Found!"
                Write-Host "MAC Address: $macAddress"
                Write-Host "Assigned IP Address: $($lease.IPAddress)"
                Write-Host "Scope: $($scope.Name)"
                break
            }
        }
    }

    if ($found) { break }
}

# If no match was found, notify the user
if (-not $found) {
    Write-Host "No match found for MAC Address: $macAddress"
}
