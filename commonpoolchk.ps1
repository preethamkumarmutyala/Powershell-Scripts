# Define the range of HYDCPHV computer names
$hydComputerNames = 8..25 | ForEach-Object { "hydcphv" + $_.ToString("D2") }

# Define the range of BDCCPHV computer names
$bdcComputerNames = 25..49 | ForEach-Object { "bdccphv$_" }

# Combine both ranges of computer names
$computerNames = $hydComputerNames + $bdcComputerNames

# Define the suffix
$suffix = ".gp.cv.commvault.com"

# Function to check if a server is online using Test-WSMan
function Test-ServerOnline {
    param (
        [string]$computerName
    )

    try {
        # Use Test-WSMan to check if the server is online
        if (Test-WSMan -ComputerName $computerName -ErrorAction Stop) {
            Write-Host "$computerName is Online" -ForegroundColor Green
        }
    } catch {
        Write-Host "$computerName is Offline" -ForegroundColor Red
    }
}

# Check each server in the list
foreach ($computerName in $computerNames) {
    $fullComputerName = "$computerName$suffix"
    Test-ServerOnline -computerName $fullComputerName
}
