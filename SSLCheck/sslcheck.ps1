#sudo masscan 139.67.0.0/16 -p 443 -oJ /home/allisonaaronb/Documents/scans/Scan_EIU_443.json
$Folder = "ssl_scans"
$IP = Import-Csv "ipcheck.csv" | select ip
cd ssl_scans
$SSLInfo = $IP | %{
    sslscan --no-cipher-details --no-ciphersuites --no-groups -ipv4 --xml=$($_.ip).xml $($_.ip)
}


$SSLInfoAll = @()
$Files = dir $Folder
$Files | %{
    [xml]$SSLInfo = Get-Content $_.fullname 
    
$SSLInfo2 = [PSCustomObject]@{
            SSL_host = $SSLInfo.document.ssltest.host
            SSL_Protocol = $SSLInfo.document.ssltest.protocol
     }

$SSLInfoAll = $SSLInfoAll + $SSLInfo2
}
$SSLInfoAll.SSL_Protocol| ft
