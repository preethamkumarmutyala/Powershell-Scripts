# Function to retrieve BitLocker recovery password from AD
function Get-BitLockerRecoveryKey {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )
    
    try {
        # Get the computer object from Active Directory
        $computer = Get-ADComputer -Filter { Name -eq $ComputerName }

        if ($computer) {
            # Retrieve BitLocker recovery information
            $recoveryInfo = Get-ADObject -Filter { objectClass -eq 'msFVE-RecoveryInformation' } `
                                        -SearchBase $computer.DistinguishedName `
                                        -Property 'msFVE-RecoveryPassword' |
                                        Select-Object -Property 'msFVE-RecoveryPassword'

            if ($recoveryInfo) {
                Write-Host "BitLocker Recovery Password for ${ComputerName}:" -ForegroundColor Green
                $recoveryInfo.'msFVE-RecoveryPassword'
            } else {
                Write-Host "No BitLocker recovery information found for ${ComputerName}." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Computer ${ComputerName} not found in Active Directory." -ForegroundColor Red
        }
    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}

# Prompt user for the computer name
$computerName = Read-Host "Enter the computer name"
Get-BitLockerRecoveryKey -ComputerName $computerName
