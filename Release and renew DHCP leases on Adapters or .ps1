#Find DHCP-enabled adaptors 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=true" -ComputerName

#DHCP-enabled adaptors with TCP/IP
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true and DHCPEnabled=true" -ComputerName

#Enable DHCP on all network adapters 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName . | ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)} | Format-Table

#Releasing DHCP Leases (disconnects that adapter from the network and releases the IP address)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true and DHCPEnabled=true" -ComputerName . | Where-Object -FilterScript {$_.DHCPServer -contains "192.168.1.1"} | ForEach-Object -Process {$_.InvokeMethod("ReleaseDHCPLease",$null)}

#Renewing DHCP Leases (allows leases to be manually or programmatically renewed on the client, bypassing the normal renegotiation process between client and server)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true and DHCPEnabled=true" -ComputerName . | Where-Object -FilterScript {$_.DHCPServer -contains "192.168.1.254"} | ForEach-Object -Process {$_.InvokeMethod("ReleaseDHCPLease",$null)}

#Releasing and Renewing DHCP Leases on All Adapters (global DHCP address releases or renewals on all adapters)
    #Release DHCP Lease (all)
( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"} ) | InvokeMethod("ReleaseDHCPLeaseAll", $null)
    #Renew DHCP Lease (all)
( Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"} ) | InvokeMethod("RenewDHCPLeaseAll", $null)
