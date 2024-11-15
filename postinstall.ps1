# Function to install PSWindowsUpdate module if not already installed
function Install-PSWindowsUpdateModule {
    try {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Write-Host "PSWindowsUpdate module is not installed. Installing now..." -ForegroundColor Yellow

            # Register PSGallery if not already registered
            if (-not (Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue)) {
                Write-Host "PSGallery repository is not registered. Registering now..." -ForegroundColor Yellow
                Register-PSRepository -Default
            }

            # Ensure NuGet provider is available
            if (-not (Get-PackageSource -Name 'nuget' -ErrorAction SilentlyContinue)) {
                Write-Host "NuGet provider is not installed. Installing now..." -ForegroundColor Yellow
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            }

            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
            Write-Host "PSWindowsUpdate module installed." -ForegroundColor Green
        } else {
            Write-Host "PSWindowsUpdate module is already installed." -ForegroundColor Green
        }
    } catch {
        Write-Host "Error installing PSWindowsUpdate module: $_" -ForegroundColor Red
    }
}

# Function to turn off the Windows Firewall for all profiles
function Disable-Firewall {
    try {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
        Write-Host "Firewall is OFF" -ForegroundColor Green -BackgroundColor Black
    } catch {
        Write-Host "Error turning off the firewall: $_" -ForegroundColor Red
    }
}

# Function to enable Remote Desktop
function Enable-RemoteDesktop {
    try {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "UserAuthentication" -Value 0
        Write-Host "Remote Desktop is enabled" -ForegroundColor Green -BackgroundColor Black
    } catch {
        Write-Host "Error enabling Remote Desktop: $_" -ForegroundColor Red
    }
}

# Function to update Windows
function Update-Windows {
    try {
        Install-PSWindowsUpdateModule
        Import-Module PSWindowsUpdate

        Write-Host "Checking for Windows updates..." -ForegroundColor Yellow

        # Check for updates
        $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

        if ($updates) {
            Write-Host "Updates found:" -ForegroundColor Cyan
            $updates | Format-Table -Property Title, KB, Size

            Write-Host "Downloading and installing updates..." -ForegroundColor Yellow

            # Install updates
            Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose

            Write-Host "Updates installed." -ForegroundColor Green
            
            # Prompt user to reboot
            $reboot = Read-Host "Do you want to reboot the system now? (Y/N)"
            if ($reboot -eq 'Y') {
                Write-Host "Rebooting the system..." -ForegroundColor Yellow
                Restart-Computer -Force
            } else {
                Write-Host "Please reboot the system later to complete the update process." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No updates available." -ForegroundColor Green
        }
    } catch {
        Write-Host "Error updating Windows: $_" -ForegroundColor Red
    }
}

# Function to change the computer name
function Change-ComputerName {
    try {
        $newName = Read-Host "Enter the new computer name"
        Rename-Computer -NewName $newName -Force
        Write-Host "Computer name changed to $newName." -ForegroundColor Green -BackgroundColor Black

        # Prompt user to reboot
        $reboot = Read-Host "Do you want to reboot the system now to apply the name change? (Y/N)"
        if ($reboot -eq 'Y') {
            Write-Host "Rebooting the system..." -ForegroundColor Yellow
            Restart-Computer -Force
        } else {
            Write-Host "Please reboot the system later to apply the name change." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error changing computer name: $_" -ForegroundColor Red
    }
}

# Function to list, select, rename, and configure network adapters
function Manage-NetworkAdapters {
    try {
        # List all network adapters
        $adapters = Get-NetAdapter
        if ($adapters.Count -eq 0) {
            Write-Host "No network adapters found." -ForegroundColor Red
            return
        }

        Write-Host "Available network adapters:" -ForegroundColor Cyan
        $adapters | Format-Table -Property Name, Status, LinkSpeed

        # Select an adapter
        $adapterName = Read-Host "Enter the name of the adapter to configure"
        $selectedAdapter = $adapters | Where-Object { $_.Name -eq $adapterName }

        if (-not $selectedAdapter) {
            Write-Host "Adapter not found." -ForegroundColor Red
            return
        }

        Write-Host "Selected adapter: $($selectedAdapter.Name)" -ForegroundColor Green

        # Rename the adapter
        $newName = Read-Host "Enter the new name for the adapter"
        Rename-NetAdapter -Name $selectedAdapter.Name -NewName $newName -Confirm:$false
        Write-Host "Adapter renamed to $newName." -ForegroundColor Green

        # Configure IP settings
        $ipConfig = Read-Host "Set IP configuration - DHCP or Static? (Enter 'DHCP' or 'Static')"
        if ($ipConfig -eq 'DHCP') {
            Set-NetIPInterface -InterfaceAlias $newName -Dhcp Enabled
            Write-Host "Adapter set to DHCP." -ForegroundColor Green
        } elseif ($ipConfig -eq 'Static') {
            $ipAddress = Read-Host "Enter the static IP address"
            $subnetMask = Read-Host "Enter the subnet mask"
            $gateway = Read-Host "Enter the default gateway"
            $dnsServers = Read-Host "Enter DNS servers (comma-separated)"

            # Remove existing IP configurations
            Remove-NetIPAddress -InterfaceAlias $newName -Confirm:$false

            # Add static IP configuration
            New-NetIPAddress -InterfaceAlias $newName -IPAddress $ipAddress -PrefixLength $subnetMask -DefaultGateway $gateway
            Set-DnsClientServerAddress -InterfaceAlias $newName -ServerAddresses $dnsServers.Split(',')

            Write-Host "Adapter set to Static IP with address $ipAddress." -ForegroundColor Green
        } else {
            Write-Host "Invalid option. Please enter 'DHCP' or 'Static'." -ForegroundColor Red
        }
    } catch {
        Write-Host "Error managing network adapters: $_" -ForegroundColor Red
    }
}

# Function to change the time zone
function Change-TimeZone {
    try {
        Set-TimeZone -Id "India Standard Time"
        Write-Host "Time zone changed to (UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi." -ForegroundColor Green -BackgroundColor Black
    } catch {
        Write-Host "Error changing time zone: $_" -ForegroundColor Red
    }
}

# Function to change the Administrator password
function Change-AdministratorPassword {
    try {
        $newPassword = Read-Host -Prompt "Enter the new password for Administrator" -AsSecureString
        $adminAccount = Get-LocalUser -Name "Administrator"
        $adminAccount | Set-LocalUser -Password $newPassword
        Write-Host "Administrator password changed." -ForegroundColor Green -BackgroundColor Black
    } catch {
        Write-Host "Error changing Administrator password: $_" -ForegroundColor Red
    }
}

# Function to execute all tasks one by one
function Execute-AllTasks {
    Disable-Firewall
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Enable-RemoteDesktop
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Change-ComputerName
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Manage-NetworkAdapters
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Change-TimeZone
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Change-AdministratorPassword
    if ($? -eq $false) { return }
    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()

    Update-Windows
}

# Main menu loop
while ($true) {
    Write-Host ""
    Write-Host "Select an option to execute:"
    Write-Host "  1: Turn off the Firewall"
    Write-Host "  2: Enable Remote Desktop"
    Write-Host "  3: Update Windows"
    Write-Host "  4: Change Computer Name"
    Write-Host "  5: Manage Network Adapters"
    Write-Host "  6: Change Time Zone to (UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi"
    Write-Host "  7: Change Administrator Password"
    Write-Host "  8: All of the Above"
    Write-Host "  9: Exit"
    $choice = Read-Host "Enter your choice (1, 2, 3, 4, 5, 6, 7, 8, or 9)"

    switch ($choice) {
        1 { Disable-Firewall }
        2 { Enable-RemoteDesktop }
        3 { Update-Windows }
        4 { Change-ComputerName }
        5 { Manage-NetworkAdapters }
        6 { Change-TimeZone }
        7 { Change-AdministratorPassword }
        8 { Execute-AllTasks }
        9 { exit }
        default { Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Red }
    }

    Write-Host "Press Enter to continue..." -ForegroundColor Cyan
    [void][System.Console]::ReadLine()
}
