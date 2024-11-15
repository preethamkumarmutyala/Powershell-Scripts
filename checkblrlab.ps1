# Define server list
$servers = @(
    @{ Name = "INGPDC09"; IP = "172.16.191.9" }
    @{ Name = "INGPDC10"; IP = "172.16.192.10" }
    @{ Name = "BDCSNAPSERVER"; IP = "172.16.182.23" }
    @{ Name = "BDCFASTPASS-3"; IP = "172.16.182.26" }
    @{ Name = "PDCSNAPSERVER-2"; IP = "172.16.182.33" }
    @{ Name = "BDCFASTPASS-4"; IP = "172.16.182.27" }
    @{ Name = "BDCFASTPASS-5"; IP = "172.16.182.28" }
    @{ Name = "BDCDBTEST01"; IP = "172.16.191.213" }
    @{ Name = "BDCSNAPCENTER"; IP = "172.16.182.32" }
    @{ Name = "BDCFASTPASS-7"; IP = "172.16.182.57" }
    @{ Name = "BDCWINAPP01"; IP = "172.16.191.188" }
    @{ Name = "BDCREPLICATION.TESTLAB.COMMVAULT.COM"; IP = "172.16.176.22" }
    @{ Name = "BDCREPLICATION.GP.CV.COMMVAULT.COM"; IP = "172.16.176.22" }
    @{ Name = "BDCDBTEST03"; IP = "172.16.191.206" }
    @{ Name = "BDCSRVTEST01"; IP = "172.16.191.192" }
    @{ Name = "BDCFASTPASS-2"; IP = "172.16.182.25" }
    @{ Name = "BDCDBTEST06"; IP = "172.16.191.196" }
    @{ Name = "BDCMMHV07"; IP = "172.16.191.199" }
    @{ Name = "BDCSRVTEST07"; IP = "172.16.191.209" }
    @{ Name = "BDCUNIXFSHV02"; IP = "172.16.191.202" }
    @{ Name = "PDCFASTPASS-2"; IP = "172.16.182.31" }
    @{ Name = "BDCFSHV01"; IP = "172.16.191.203" }
    @{ Name = "BDCDBTEST07"; IP = "172.16.191.235" }
    @{ Name = "BDCLINUX01.COMMVAULT.COM"; IP = "172.16.182.34" }
    @{ Name = "BDCSRVNWHV01"; IP = "172.16.191.212" }
    @{ Name = "IDCSRVTEST01"; IP = "172.16.191.187" }
    @{ Name = "BDCSRVTEST08"; IP = "172.16.191.205" }
    @{ Name = "BDCWINFS01"; IP = "172.16.191.194" }
    @{ Name = "BDCMMHV06"; IP = "172.16.182.67" }
    @{ Name = "BDCFASTPASS-6"; IP = "172.16.182.29" }
    @{ Name = "BDCSRVTEST02"; IP = "172.16.191.214" }
    @{ Name = "BDCSRVTEST02"; IP = "192.168.200.100" }
    @{ Name = "UNIXDEVIND"; IP = "172.16.191.211" }
    @{ Name = "BDCDBTEST02"; IP = "172.16.191.189" }
    @{ Name = "BDCMDT01"; IP = "172.16.191.208" }
    @{ Name = "BDCSOCHV01"; IP = "172.16.182.58" }
    @{ Name = "BDCUNIXFS01"; IP = "172.16.191.191" }
    @{ Name = "BDCCSHV01"; IP = "172.16.191.200" }
    @{ Name = "BDCCSHV01"; IP = "192.168.0.1" }
    @{ Name = "BDCWINFS02"; IP = "172.16.182.52" }
    @{ Name = "BDCSATEST1"; IP = "172.16.198.83" }
    @{ Name = "BDCFASTPASS-8"; IP = "172.16.182.54" }
    @{ Name = "INASHCI-B01.HV.CVLT.NET"; IP = "172.16.232.32" }
    @{ Name = "BDCDBTEST05"; IP = "172.16.191.233" }
    @{ Name = "BDCFSTESTPERF01"; IP = "172.16.196.5" }
    @{ Name = "BLRVSAHV1"; IP = "172.16.177.71" }
    @{ Name = "BLRVSAHV1"; IP = "172.16.197.64" }
    @{ Name = "BDCDRHV01"; IP = "172.16.177.188" }
    @{ Name = "INASHCI-02.HV.CVLT.NET"; IP = "172.16.232.28" }
    @{ Name = "INASHCI-02.HV.CVLT.NET"; IP = "172.17.5.15" }
    @{ Name = "BDCSRVTEST03"; IP = "172.16.197.83" }
    @{ Name = "INASHCI-01.HV.CVLT.NET"; IP = "172.16.232.27" }
    @{ Name = "INASHCI-01.HV.CVLT.NET"; IP = "172.17.5.14" }
    @{ Name = "BDCSRVTEST05"; IP = "172.16.196.56" }
    @{ Name = "BDCSRVTEST05"; IP = "172.16.199.123" }
    @{ Name = "BDCMMTEST03"; IP = "172.16.196.215" }
    @{ Name = "BDCTESTPERF02"; IP = "172.16.199.40" }
    @{ Name = "BDCFASTPASS-1"; IP = "172.16.199.141" }
    @{ Name = "BDCVSAHV03"; IP = "172.16.199.141" }
    @{ Name = "BDCWINAPPHV02"; IP = "172.16.197.109" }
    @{ Name = "BDCENHV01"; IP = "172.16.222.11" }
    @{ Name = "BDCENHV02"; IP = "172.16.222.12" }
    @{ Name = "BDCDBTEST04"; IP = "172.16.191.231" }
    @{ Name = "BDCENHV03"; IP = "172.16.222.13" }
    @{ Name = "BDCENHV03"; IP = "172.16.222.14" }
    @{ Name = "INASHCI-B02.HV.CVLT.NET"; IP = "172.16.232.30" }
    @{ Name = "INASHCI-B02.HV.CVLT.NET"; IP = "172.16.232.51" }
    @{ Name = "BDCVSAHYPERV01"; IP = "172.16.198.119" }
    @{ Name = "OSTENTATIOUS"; IP = "172.16.199.150" }
    @{ Name = "BDCREPORTS01"; IP = "172.16.199.177" }
    @{ Name = "BDCMMHV08"; IP = "172.16.221.173" }
    @{ Name = "BDCMMHV08"; IP = "172.16.221.77" }
    @{ Name = "BDCSRVTEST06"; IP = "172.16.199.149" }
    @{ Name = "BDCSRVTEST06"; IP = "172.16.199.152" }
    @{ Name = "BDCREPORTS02"; IP = "172.16.177.228" }
    @{ Name = "BDCENGCSHV01"; IP = "172.16.198.136" }
    @{ Name = "BDCVSAHV02"; IP = "172.16.199.118" }
    @{ Name = "UNIVERSE"; IP = "172.16.196.236" }
    @{ Name = "INDC1"; IP = "172.16.232.25" }
    @{ Name = "BDCFSTESTPERF02"; IP = "172.16.199.17" }
    @{ Name = "BDCSRVTEST04"; IP = "172.16.199.128" }
    @{ Name = "BDCSRVTEST04"; IP = "172.16.199.147" }
    @{ Name = "BDCUNIX3DFS02"; IP = "172.16.199.20" }
    @{ Name = "BDCWINAPPHV03"; IP = "172.16.198.117" }
    @{ Name = "BDCWINAPPHV04"; IP = "172.16.201.0" }
    @{ Name = "BDCWINAPPHV04"; IP = "172.16.198.121" }
    @{ Name = "BDCFASTPASS-9"; IP = "172.16.232.45" }
    @{ Name = "BDCVSAHV04"; IP = "172.16.199.130" }
    @{ Name = "BDCSTORAGE"; IP = "172.16.182.11" }
    @{ Name = "STORAGE"; IP = "172.16.232.57" }
    @{ Name = "BDCVSAHV03"; IP = "172.16.199.125" }
    @{ Name = "BDCVSAHV01"; IP = "172.16.199.124" }
    @{ Name = "BDCSRVTEST04"; IP = "172.16.199.147" }
    @{ Name = "BDCVSAHV04"; IP = "172.16.199.130" }
    @{ Name = "BDCVSAHV02"; IP = "172.16.199.118" }
    @{ Name = "BDCSRVTEST04"; IP = "172.16.199.128" }
    @{ Name = "BDCSRVTEST04"; IP = "172.16.199.127" }
)

# Function to check server online status
function Check-ServerStatus {
    param (
        [string]$ServerName,
        [string]$ServerIP
    )
    $ping = Test-Connection -ComputerName $ServerIP -Count 1 -Quiet
    if ($ping) {
        Write-Host "$ServerName ($ServerIP) is ONLINE" -ForegroundColor Green
    } else {
        Write-Host "$ServerName ($ServerIP) is OFFLINE" -ForegroundColor Red
    }
}

# Check each server status
foreach ($server in $servers) {
    Check-ServerStatus -ServerName $server.Name -ServerIP $server.IP
}
