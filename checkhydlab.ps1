# Define the list of server names and IP addresses as a hashtable
$servers = @{
    "HYDREPLICATION" = "172.16.76.20"
    "HYDSNAPSERVER" = "172.16.76.22"
    "HYDSRVDEVBUILD2" = @("172.16.26.79", "172.26.160.1")
    "HYDFASTPASS-5" = "172.16.76.28"
    "HYDFASTPASS-6" = "172.16.76.29"
    "HYDFASTPASS-2" = "172.16.76.25"
    "HYDBUILDSYMBOLS" = "172.16.76.21"
    "HYDFASTPASS-1" = "172.16.76.65"
    "IDCHYVCL-02 HYDCPHV18" = "172.16.80.78"
    "HYDDEVSRVHV01" = "172.16.80.188"
    "HYDFSHV02" = "172.16.80.198"
    "HYDFSHV01" = "172.16.80.185"
    "HYDK8SHV01" = @("172.16.66.73", "172.16.80.186")
    "IDCWINAPPHOST5" = "172.16.80.194"
    "SRVTESTIND4" = "172.16.80.211"
    "SRVTESTIND3" = @("172.16.62.75", "172.16.80.222")
    "HYDBIGDATASRV" = "172.16.80.200"
    "ENG-HYD.TESTLAB.COMMVAULT.COM ENG-HYD.GP.CV.COMMVAULT.COM" = "172.16.66.60"
    "HYDUNIXDB01" = @("172.16.61.127", "172.16.80.207")
    "HYDUNIXDB03" = "172.16.80.226"
    "HYDDEVVSAHV-02" = "172.16.80.209"
    "INSHYDIDC01" = "172.16.80.217"
    "IDCEXCHAPP" = "172.16.80.208"
    "HYDINDEXHV01" = "172.16.80.227"
    "HYDFASTPASS-4" = "172.16.76.27"
    "IDCWINAPPHOST4" = "172.16.80.204"
    "BIGB" = "172.16.80.218"
    "HYDFASTPASS-3" = "172.16.76.26"
    "HYDSATEST-1" = "172.16.80.205"
    "HYD-SRVDEVBUILD" = "172.16.80.177"
    "HYDAPPLIHV01" = "172.16.80.220"
    "IDCEXCHAPP02" = "172.16.80.199"
    "HYDVSAHV01" = "172.16.80.197"
    "HYDUNIXDB02" = "172.16.80.233"
    "HYDFSHV03" = "172.16.80.189"
    "HYDDEVVSAHV-01" = "172.16.80.178"
    "HYDSRVTEST-03" = "172.16.80.213"
    "HYDDEVVSAHV-03" = "172.16.80.216"
    "HYDVSAHV02" = "172.16.65.217"
    "HV2K161" = @("172.16.64.178", "172.16.66.82")
    "MMHYD3" = @("172.16.65.227", "172.16.66.48")
    "HYDMMSCALEOUT01" = "172.16.65.5"
    "HYDSRVTEST01" = "172.16.76.62"
    "IDCDEVSRV01" = "172.16.80.193"
    "SRVTESTIND2" = "172.16.80.240"
    "HYDVSAHV03" = @("172.16.64.209", "172.16.65.32")
    "MM-SCALEMA10" = "172.16.64.120"
    "HOTFIXCS-3" = @("172.16.65.209", "192.168.200.1")
    "ISVM" = @("172.16.60.75", "192.168.5.1")
    "SNAINDIAHYPERV" = "172.16.66.72"
    "AZURE-HYD" = "172.16.59.81"
    "HVIDC1" = "172.16.64.222"
    "MM-SCALEMA-02" = "172.16.60.166"
    "MMHYD1" = @("172.16.64.113", "172.16.64.114")
    "1TOUCHNVMEDELL" = "172.16.60.73"
    "HYDUNIXFS001A" = "172.16.66.93"
    "IDCDEVREPORTS1" = "172.16.64.124"
    "HYDVSA2K16" = "172.16.61.211"
    "BLOCKSCALE" = "172.16.66.194"
    "IDCSNAPCENTEROL" = "172.16.76.30"
    "HYDNASHV01" = "172.16.80.218"
    "HYDUNIXFSHV01" = "172.16.80.226"
    "DOMINOHOST" = "172.16.80.245"
    "HYPPKTR01" = @("172.16.65.91", "172.16.67.6")
    "HPVINDEX" = "172.16.64.237"
    "DEPLOYMENT09" = "172.16.62.203"
    "HYDSRVTEST02" = "172.16.80.43"
    "HPVMA" = "172.16.61.109"
    "INDEXINGCSIDC" = "172.16.62.10"
}

# Function to display messages in color
function Write-Color {
    param (
        [string]$Message,
        [ConsoleColor]$Color
    )
    $oldColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Output $Message
    $Host.UI.RawUI.ForegroundColor = $oldColor
}

# Initialize arrays for reachable and unreachable servers
$reachableServers = @()
$unreachableServers = @()

# Loop through each server and check reachability
foreach ($server in $servers.GetEnumerator()) {
    $serverName = $server.Key
    # Skip entries starting with "HYDCPHV"
    if ($serverName -like "HYDCPHV*") {
        continue
    }
    $ipList = $server.Value
    if (-not ($ipList -is [System.Array])) {
        $ipList = @($ipList)
    }

    $allReachable = $true
    foreach ($ip in $ipList) {
        $pingResult = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue
        if (-not $pingResult) {
            $allReachable = $false
            break
        }
    }

    if ($allReachable) {
        $reachableServers += @("$serverName = $($ipList -join ', ')")
    } else {
        $unreachableServers += @("$serverName = $($ipList -join ', ')")
    }
}

# Output the reachable and unreachable servers
Write-Output "`nReachable Servers:"
foreach ($entry in $reachableServers) {
    Write-Color -Message "$entry" -Color Green
}

Write-Output "`nUnreachable Servers:"
foreach ($entry in $unreachableServers) {
    Write-Color -Message "$entry" -Color Red
}
