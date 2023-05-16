#$Folder = "/home/kali/Documents/PortScans/$(get-date -Format yyyy-MM-dd)/"
$Folder = "port_scans/$(get-date -Format yyyy-MM-dd)/"
#$Folder = "C:\Scripts\port_scans\2022-09-10"

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
        #DNS= $(Resolve-DnsName $($_.ip) | where section -eq "Answer" | select -First 1).NameHost
        #DNS2= [System.Net.Dns]::GetHostEntry("$($_.ip)").HostName
    }
}
$OpenIPPorts | where port -eq 9000
$OpenIPPorts| where port -eq 443 | select -First 20 -Skip 300 | %{
    write-output $_.ip
    $IP1 = $($_.ip)
    $Ports1 = $OpenIPPorts | where {$_.IP -eq "$IP1"}
    $PortList = $Ports1 | where {$_.IP -eq "$IP1"}
    $Ports1 = $PortList | where $_.port -Like "9000"
    $Ports1
}



$OpenIPPorts | group port | sort count -Descending | select -First 10
$OpenIPPorts | group IP | sort count


($OpenIPPorts | where port -eq 80).count