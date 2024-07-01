Import-Module DHCPServer

$ComputerNames = @(
    '4DP5N62', '5J6C152', '1F8L542', 'F7MRXX1', '76WM622', '7SBGS62',
    'D4T0X02', '54T0X02', 'JP6GVQ1', 'FYZVGY1', 'CMZ1NV1', '6X7X4BS',
    'DSWSQ02', '7WSHQ12', '8BYF833', '8MZ1BB3', 'GS6CW22', '6PGW022',
    '726PH32', '4Y5PH32', '126PH32', 'C8GD152', 'F8GD152', 'CZFF152',
    '3Y4HH92', '3VCFH92', '3V4M6C2', '4DCM6C2', 'BG7D9F2', 'BG8G9F2',
    '39LMXH2', 'CWZ5NK2', '5RR4233', '6RR4233', 'CPDZW63', 'DPDZW63',
    '3WPRBD3', '4WPRBD3', '7VVL7R1', '2LN8QM3', '1LN8QM3', '3YPLPM3',
    '8DKG0Z3', 'DGVG9F2', '1Q0MD02', '4W6CW22', '2RF27BS', 'HV48NK2',
    '8MFDQF3', '2MPQPQ1', 'H4T0X02', '970J9V2', 'G4CK542', '7VVLWQ1',
    'HK3XFY1', '93F68R1', 'GS108R1', 'D6RWH32', '2W6CW22', '1FCK542',
    '613KX52', '2NKW022', 'B17QH32', '6DS4RG2', '5W4XFY1', '82W0T02',
    '2ZZVGY1', 'CSLMD02', '7SBCS62', '7SBHS62', '06B867T', '7094W23',
    '7093W23', '5P22B92'
)

$DhcpServers = @('172.16.72.50', '172.16.72.51')
$Results = @()

foreach ($Computer in $ComputerNames) {
    $IpAddress = $null
    $DhcpServer = $null
    
    foreach ($DhcpServer in $DhcpServers) {
        $Lease = Get-DhcpServerv4Lease -ComputerName $DhcpServer -ClientId $Computer -ErrorAction SilentlyContinue
        if ($Lease) {
            $IpAddress = $Lease.IPAddress
            break
        }
    }
    
    if (!$IpAddress) {
        $IpAddress = "Not Found"
    }

    $Results += [PSCustomObject]@{
        ComputerName = $Computer
        IPAddress = $IpAddress
        DhcpServer = $DhcpServer
    }
}

$Results | Export-Excel -Path "$PSScriptRoot\IP_Lease_Results.xlsx" -AutoSize -AutoFilter -Title "IP Lease Results"
