# Define the username and password
$username = "Administrator@playdomain.loc"
$password = "L0c@1@cces$"

# Create a credential object
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Define the remote server
$remoteServer = "playdc-02.playdomain.loc"

# Create a new PowerShell session with credentials
$session = New-PSSession -ComputerName $remoteServer -Credential $credential

# Verify the session
if ($session) {
    Write-Output "Successfully created a session to $remoteServer."

    # Run the command to trigger DHCP scope replication
    Invoke-Command -Session $session -ScriptBlock {
        Invoke-DhcpServerv4FailoverReplication -ComputerName "playdc-01" -Force
    }
} else {
    Write-Output "Failed to create a session to $remoteServer."
}

# Close the session
Remove-PSSession -Session $session
