# List of servers and their IPs
$servers = @(
    @{Name="HYDSNAPSERVER"; IP="172.16.76.22"},
    @{Name="HYDFASTPASS-5"; IP="172.16.76.28"},
    @{Name="HYDFASTPASS-6"; IP="172.16.76.29"},
    @{Name="HYDFASTPASS-2"; IP="172.16.76.25"},
    @{Name="HYDBUILDSYMBOLS"; IP="172.16.76.21"},
    @{Name="HYDFASTPASS-1"; IP="172.16.76.65"},
    @{Name="HYDDEVSRVHV01"; IP="172.16.80.188"},
    @{Name="HYDFSHV02"; IP="172.16.80.198"},
    @{Name="HYDFSHV01"; IP="172.16.80.185"},
    @{Name="HYDK8SHV01"; IP="172.16.66.73"},
    @{Name="IDCWINAPPHOST5"; IP="172.16.80.194"},
    @{Name="HYDFASTPASS-4"; IP="172.16.76.27"},
    @{Name="HYDCPHV13"; IP="172.16.80.73"},
    @{Name="HYDDEVSRV01"; IP="172.16.80.193"},
    @{Name="SRVTESTIND2"; IP="172.16.80.215"},
    @{Name="HYDDEVVSAHV-03"; IP="172.16.80.216"},
    @{Name="HYDVSAHV02"; IP="172.16.65.217"},
    @{Name="HVHYD19"; IP="172.16.65.74"},
    @{Name="HYDVSAHV03"; IP="172.16.64.209"},
    @{Name="MM-SCALEMA10"; IP="172.16.64.120"},
    @{Name="HOTFIXCS-3"; IP="172.16.65.209"},
    @{Name="ISVM"; IP="172.16.60.75"},
    @{Name="SNAINDIAHYPERV"; IP="172.16.66.72"},
    @{Name="AZURE-HYD"; IP="172.16.59.81"},
    @{Name="HVIDC1"; IP="172.16.64.222"},
    @{Name="MM-SCALEMA-02"; IP="172.16.60.166"},
    @{Name="MMHYD1"; IP="172.16.64.113"},
    @{Name="1TOUCHNVMEDELL"; IP="172.16.60.73"},
    @{Name="HYDUNIXFS001A"; IP="172.16.66.93"},
    @{Name="IDCDEVREPORTS1"; IP="172.16.64.124"},
    @{Name="HYDVSA2K16"; IP="172.16.61.211"},
    @{Name="BLOCKSCALE"; IP="172.16.66.194"},
    @{Name="IDCSNAPCENTEROL"; IP="172.16.76.30"},
    @{Name="HYDNASHV01"; IP="172.16.80.218"},
    @{Name="HYDUNIXFSHV01"; IP="172.16.80.226"},
    @{Name="DOMINOHOST"; IP="172.16.80.245"},
    @{Name="HYPPKTR01"; IP="172.16.65.91"},
    @{Name="HPVINDEX"; IP="172.16.64.237"},
    @{Name="DEPLOYMENT09"; IP="172.16.62.203"},
    @{Name="HYDSRVTEST02"; IP="172.16.80.43"},
    @{Name="HPVMA"; IP="172.16.61.109"},
    @{Name="INDEXINGCSIDC"; IP="172.16.62.10"}
)

# Function to get iDRAC IP
function Get-iDRACIP {
    param (
        [string]$Server
    )
    try {
        $idracIP = Invoke-Command -ComputerName $Server -ScriptBlock {
            $idracInfo = & racadm getniccfg
            $idracIP = ($idracInfo | Select-String -Pattern "IP Address").Line.Split('=')[1].Trim()
            return $idracIP
        }
        return $idracIP
    } catch {
        return $null
    }
}

# Loop through servers and get iDRAC IP
foreach ($server in $servers) {
    $idracIP = Get-iDRACIP -Server $server.Name
    if ($idracIP) {
        Write-Host "$($server.Name) = $idracIP" -ForegroundColor Green
    } else {
        Write-Host "$($server.Name) = Not Reachable" -ForegroundColor Red
    }
}
