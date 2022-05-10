#Listing all network adapters in a system 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration

#Listing all network adapters in a system are TCP/IP enabled 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE

#List the IPAddresses of all network IP addresses in your computer in a formated table 
get-wmiobject Win32_NetworkAdapterConfiguration | format-table IPAddress, Description -autosize

#List all MAC addresses for the network adapters 
get-wmiobject Win32_NetworkAdapterConfiguration | format-table MacAddress, Description -autosize

#BONUS: MAC addresses of a remote system
get-wmiobject Win32_NetworkAdapterConfiguration MacAddress -ComputerName RemoteComputerName | select-object MacAddress

#Display the IP config data for every net adapter 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName

#BONUS: if you want to see the data for just TCP/IP only: 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*
