# Setup server networking/remote access/timezone
param (
    [array]$TrustedHosts,
    [string]$ServerHostname,
    [string]$ServerIPAddress,
    [string]$DefaultGatewayIPAddress,
    [array]$DNSServerIPAddresses,
    [string]$SubnetPrefix,
    [string]$TimezoneName
)

$interface_index = (Get-NetAdapter).ifindex
New-NetIPAddress -IPAddress $ServerIPAddress -DefaultGateway $DefaultGatewayIPAddress -PrefixLength $SubnetPrefix -InterfaceIndex $interface_index
Set-DnsClientServerAddress -InterfaceIndex $interface_index -ServerAddresses ($DNSServerIPAddresses -join ',')

$timezone = Get-TimeZone -ListAvailable | Where-Object { $_.Id -Like "$TimezoneName*"}
$timezone | Set-TimeZone

Enable-PSRemoting -Force
Set-Item WSMan:\localhost\client\trustedhosts ($TrustedHosts -join ',') -Force
Restart-Service WinRM -Force

Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\‘ -Name “fDenyTSConnections” -Value 0
Set-ItemProperty ‘HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\‘ -Name “UserAuthentication” -Value 1
Enable-NetFirewallRule -DisplayGroup “Remote Desktop”

Rename-Computer -NewName $ServerHostname -Restart -Force