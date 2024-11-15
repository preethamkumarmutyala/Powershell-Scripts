# Define the output file
$OutputPath = "C:\Temp\IP_Audit_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".csv"

# Create or clear the output file
"IP Address,Host Name,MAC Address" | Out-File -FilePath $OutputPath -Encoding UTF8

# List of IP addresses
$IPList = @(
    "172.16.60.1",
    "172.16.60.61",
    "172.16.60.62",
    "172.16.60.63",
    "172.16.60.64",
    "172.16.60.67",
    "172.16.60.68",
    "172.16.60.69",
    "172.16.60.70",
    "172.16.60.71",
    "172.16.60.72",
    "172.16.60.73",
    "172.16.60.74",
    "172.16.60.75",
    "172.16.60.77",
    "172.16.60.78",
    "172.16.60.79",
    "172.16.60.80",
    "172.16.60.81",
    "172.16.60.82",
    "172.16.60.83",
    "172.16.60.84",
    "172.16.60.85"
)

# Function to get MAC address from ARP
function Get-Arp {
    param (
        [string]$IPAddress
    )

    # Execute the arp command and get the output
    $arpOutput = arp -a
    $arpTable = $arpOutput | Select-String $IPAddress

    if ($arpTable) {
        $parts = $arpTable -split '\s+'
        return [PSCustomObject]@{
            IPAddress  = $parts[0]
            MACAddress = $parts[1]
        }
    } else {
        return $null
    }
}

# Loop through each IP address and gather details
foreach ($ip in $IPList) {
    Write-Host "Scanning $ip..."
    
    # Get the host name
    $hostName = "No response"
    try {
        $hostInfo = [System.Net.Dns]::GetHostEntry($ip)
        if ($hostInfo) { $hostName = $hostInfo.HostName }
    } catch {
        # Ignore the error and keep the default "No response"
    }
    
    # Get the MAC address
    $arp = Get-Arp -IPAddress $ip
    $macAddress = if ($arp) { $arp.MACAddress } else { "No MAC address" }

    # Write the details to the output file
    "$ip,$hostName,$macAddress" | Out-File -FilePath $OutputPath -Append -Encoding UTF8
}

# Count total IP addresses scanned
$totalCount = $IPList.Count
"Total IP Addresses: $totalCount" | Out-File -FilePath $OutputPath -Append -Encoding UTF8

Write-Host "Audit completed. Results saved in $OutputPath."
