#can use the wim cmdlet
$service = Get-WmiObject -ComputerName DC1 -Class Win32_Service -Filter "Name='wuauserv'"
$service

#to see service methods that are available
$Service | Get-Member -Type Method

#Some examples include:
$service.stopservice()
$service.startservice()

#To perform a resart use the: 
Restart-Service -InputObject $service -Verbose
$service.Refresh()
$service

#They can be run through the pipline (still need the computer name)
Get-Service -ComputerName dc1 -Name wuauserv | Stop-Service -Verbose
Get-Service -ComputerName dc1 -Name wuauserv | Start-Service -Verbose
Get-Service -ComputerName dc1 -Name wuauserv | Restart-Service -Verbose

#---------------------------------Notes-----------------------------------#
#The WIM cmdlet are not dynamic in nature so you need rerun the first wim cmdlet

#You can also use the invoke wim cmdlet to perform the same action: 
Invoke-WmiMethod -Path "Win32_Service.Name='wuauserv'" `
-Name StopService -Computername DC1
#You need to know the computer name

