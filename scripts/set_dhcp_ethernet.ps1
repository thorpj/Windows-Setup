$interface= (Get-Netadapter -Name "Ethernet")
$ifindex = $interface.InterfaceIndex
Write-Host "Enabling DHCP on interface $($interface.InterfaceDescription)"
$ip_interface = Get-NetIpinterface  -InterfaceIndex $ifindex -AddressFamily IPv4
$ip_interface | Set-NetIPInterface -Dhcp Enabled
$dns = Get-DnsClientServerAddress -InterfaceIndex $ifindex 
Write-Host "Removing previously set DNS servers"
Set-DnsClientServerAddress -InterfaceIndex $ifindex -ResetServerAddresses
$adapter = Get-WmiObject -class Win32_NetworkAdapterConfiguration | Where-Object{$_.Description -eq $interface.InterfaceDescription } 

$dns_addresses = $dns.ServerAddresses
$gateway = $adapter.DefaultIPGateway
$hostname = $adapter.DNSHostName
$subnet = ($adapter.IPSubnet)[0]
$ip_address = ($adapter.IPAddress)[0]
$mac_address = $adapter.MACAddress
$dns_domain = $adapter.DNSDomain

Write-Host "Renewing DHCP Lease for $($ip_address)"
$adapter.RenewDHCPLease() | Out-Null


$output = New-Object -Type PSObject
$output | Add-Member -MemberType NoteProperty -Name DNSAddresses -Value $dns_addresses
$output | Add-Member -MemberType NoteProperty -Name Gateway -Value $gateway
$output | Add-Member -MemberType NoteProperty -Name Hostname -Value $hostname
$output | Add-Member -MemberType NoteProperty -Name Subnet -Value $subnet
$output | Add-Member -MemberType NoteProperty -Name IPAddress -Value $ip_address
$output | Add-Member -MemberType NoteProperty -Name MACAddress -Value $mac_address
$output | Add-Member -MemberType NoteProperty -Name DNSDomain -Value $dns_domain

$output