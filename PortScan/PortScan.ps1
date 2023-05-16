#$Folder = "/home/kali/Documents/PortScans/$(get-date -Format yyyy-MM-dd)/"
$Folder = "port_scans/$(get-date -Format yyyy-MM-dd)/"
#$Folder = "port_scans/2022-06-27"

if (Test-Path $Folder){Write-output "Folder Ready"}else{mkdir $Folder}

#$Subs = 8,9,14,15,62
$Subs = 1..255
$Subs | % {
    $Sub = $_
    $aDate = get-date -Format FileDateTime
    #& {sudo masscan "139.67.$sub.0/24" -p 80 -oJ Scan_$Sub.json}
    "139.67.$sub.0/24"
    #& {sudo masscan "139.67.$sub.0/24" --rate 1000 -p 22,3389 --wait 5 -oJ $Folder/Scan_$($aDate)_$($Sub).json}
    #& {sudo masscan "139.67.$sub.0/24" --rate 100000 --top-ports 10 -oJ $Folder/Scan_$($aDate)_$($Sub).json}
    & {sudo masscan "139.67.$sub.0/24" --rate 10000 --top-ports 1000 -oJ $Folder/Scan_$($aDate)_$($Sub).json}
}

<#
$Files = dir $Folder
$IPInfoAll  = @()
$Files | %{
    $IPInfo = Get-Content $_.fullname | ConvertFrom-Json
    $IPInfoAll = $IPInfoAll + $IPInfo
}

$OpenIPPorts = $IPInfoAll | % {
[PSCustomObject]@{
        IP = "$($_.ip)"
        Port = "$($_.ports.port)"
        DNS= $(Resolve-DnsName $($_.ip) | where section -eq "Answer" | select -First 1).NameHost
    }
}
$OpenIPPorts | where port -eq 1
$OpenIPPorts | group IP | sort count
#>

