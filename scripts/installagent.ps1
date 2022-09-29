
######## install elastic Agent + sysmon and sysmon modular #######

$AgentURL = 'https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.4.1-windows-x86_64.zip'

$enrollmentToken = 'RE9iNDdZSUJySjVpSTRXV1A3TVg6TTdTV1NSUk1UWXFxeGNQUkgwZnpodw=='
$fleetUrl = 'https://@IP:8220'


$elasticRunning = Get-Service | where {($_.Name -like "Elastic*") -and ($_.Status -eq "Running")}

$source ='https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml'
$destination ='C:\ProgramData\Sysmon\sysmonconfig.xml'


If ($elasticRunning -eq $null)
{
    write-host 'Installing Elastic Agent'

    $randomString = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_})
    $tempDir = $env:TEMP + "\" + $randomString
    mkdir $tempDir
    $zipFile = $tempDir + "\" + "elastic-agent.zip"
    write-host $zipFile
    Start-BitsTransfer -Source "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.4.1-windows-x86_64.zip" -Destination $zipFile
    
    Expand-Archive -LiteralPath $zipFile -DestinationPath $tempDir

    $exeFile = $tempDir + "\" + "elastic-agent-8.1.0-windows-x86_64" + "\" + "elastic-agent.exe"
    $b64 = 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURTVENDQWpHZ0F3SJDSLSSDKZDMZDZ1OGwySytxK2lJNDlaMUt3bE52MmNvd0RRWUpLb1pJaHZjTkFRRUwKQlFBd05ERXlNREFHQTFVRUF4TXBSV3hoYzNScFl5QkRaWEowYVdacFkyRjBaU0JVYjI5c0lFRjFkRzluWlc1bApjbUYwWldRZ1EwRXdIaGNOTWpJd09ETXdNRGd6TnpFMFdoY05NalV3T0RJNU1EZ3pOekUwV2pBME1USXdNQVlEClZRUURFeWxGYkdGemRHbGpJRU5sY25ScFptbGpZWFJsSUZSdmIyd2dRWFYwYjJkbGJtVnlZWFJsWkNCRFFUQ0MKQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dFUEFEQ0NBUW9DZ2dFQkFLQ1BrRUcrMkJFSDdLeGVEbmZ5MjJYego5OXdpR05kbk9kYms3WEpZZlliQll3S1QzUWNQMUE1R29BZnFwODJQRHN5ejZZZm9VNy8zYjlBWklXVGpnQWMzCnJSRmtGTmozSVMvYkEwZmlweXMzNi9wNmVzU2hjV0tBOGdjUUpKUWVQZXR5UnVxSkVsMFdYOGttbDloemdrYncKTTIvZmdiUWI0ZVhwT1k4UDM2a2pubC9WeVI2aEthMUFpdWM0bDdnM3dOM1R0Z1VEeVdJYWZ5dzFpMHk5Um9FKwpXVXBZNUJLZndiT1N5ZEVTdXM3azRaOU5vTitVdGRFY3BVSkx2NTlnYlhsUzEvOTlwRVpyQlZvTzhCT2FxTy9BClpNbTZ2aEtxQ2djL2MwQ2djU25XK1A2cmlHOUhJR09hbktJc1hBc2xqSWtQaGJyZGZJSUtUaCsrbUsybXBLOEMKQXdFQUFhTlRNRkV3SFFZRFZSME9CQllFRkpjSWlpSDJ6Z1VZWDdXZkFDZS9PT3RzNlYvNU1COEdBMVVkSXdRWQpNQmFBRkpjSWlpSDJ6Z1VZWDdXZkFDZS9PT3RzNlYvNU1BOEdBMVVkRXdFQi93UUZNQU1CQWY4d0RRWUpLb1pJCmh2Y05BUUVMQlFBRGdnRUJBQTJVSHVhbTIwWXl1Wk5mQkVBUG00WWZBMVdUTjJQdDVtKzNsSVlHN1REVkk5a2gKQnQrL1c4aXVSbU5MdDJ5eFRBM2FlMVRUQk9GdGxySmdDTENiOHlVV3N0UjRaL3JTU2xoMmQ2RmlWNmgyWEF6Vgo4UGwwcHp6ek5sN2xWeXNJbEt6SzVBLzBmelFlODNhOXdsRHRBMlhJNW0rSWwzRlROcmllWlFKeks2eHVUM1BhCmx1eDNFZFppUnJaWmxCYlk0U21zN0g2WnJReDlOV0RqN3lRYlQvamJQSmVOdUVPWCtmL25xcHc0TzUwSkx4OUUKN2t3WE00RzJlWGJsSDhiOWtaZkd0TGVhYnQ5TVNNRkU5OHh6SlphYkQ1b1Y2ajdpc1YwRWx5TjQxYktCV2k4ZwpZYUswZnRHSzhUWW0rVFNmWFhxdG5qU0xPNVN3ZGxKdDEwcU12Z0U9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0='
    $filename = "C:\ca.crt" 
    $bytes =[Convert]::FromBase64String($b64)
    [IO.file]::WriteAllBytes($filename, $bytes)
    Start-Sleep 2
    Start-Process -FilePath $exeFile -ArgumentList "install","-f","--url=$fleetUrl","--enrollment-token=$enrollmentToken","-a",`"$filename`"
    write-host "[+] Processing Sysmon Installation.."

    $URL = "https://download.sysinternals.com/files/Sysmon.zip"
    Resolve-DnsName download.sysinternals.com
    Resolve-DnsName github.com
    Resolve-DnsName raw.githubusercontent.com

    $OutputFile = Split-Path $Url -leaf
    $File = "C:\ProgramData\$OutputFile"

    # Download File
    write-Host "[+] Downloading $OutputFile .."
    $wc = new-object System.Net.WebClient
    $wc.DownloadFile($Url, $File)
    if (!(Test-Path $File)) { Write-Error "File $File does not exist" -ErrorAction Stop }

    # Decompress if it is zip file
    if ($File.ToLower().EndsWith(".zip"))
    {
    # Unzip file
        write-Host "  [+] Decompressing $OutputFile .."
        $UnpackName = (Get-Item $File).Basename
        $SysmonFolder = "C:\ProgramData\$UnpackName"
        $SysmonBinary = "$SysmonFolder\Sysmon.exe"
        expand-archive -path $File -DestinationPath $SysmonFolder
        if (!(Test-Path $SysmonFolder)) { Write-Error "$File was not decompressed successfully" -ErrorAction Stop }
    }

    # Downloading Sysmon Configuration
    write-Host "[+] Downloading Sysmon config.."
    Invoke-WebRequest -Uri $source -Outfile $destination
    

    # Installing Sysmon
    write-Host "[+] Installing Sysmon.."
    & $SysmonBinary -i $destination -accepteula 
    write-Host "[+] Setting Sysmon to start automatically.."
    #& sc.exe config Sysmon start= auto

    # Setting Sysmon Channel Access permissions
    write-Host "[+] Setting up Channel Access permissions for Microsoft-Windows-Sysmon/Operational "
    wevtutil set-log Microsoft-Windows-Sysmon/Operational /ca:'O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;NS)'
    #New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Sysmon/Operational" -Name "ChannelAccess" -PropertyType String -Value "O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;NS)" -Force

    write-Host "[+] Restarting Sysmon .."
    Restart-Service -Name Sysmon 

    write-Host "  [*] Verifying if Sysmon is running.."
    $s = Get-Service -Name Sysmon
    while ($s.Status -ne 'Running') { Start-Service Sysmon; Start-Sleep 3 }
    Start-Sleep 5
    write-Host "  [*] Sysmon is running.."
    Restart-Service -DisplayName "Elastic Agent"
}
else
{
    write-host 'Elastic agent is already running, skipping'
}
