#For local disk use the following

Get-PSDrive C | Select-Object Used,Free #specifies the used and free
#BONUS: Can also use this basic sctipt to specify different properties such as DeviceID, DriveType, ProviderName, and VolumeSize

#For remote systems use the following script (note: the PowerShell Remoting Nuggets to be installed on your system and the subsiquent systems):

Invoke-Command -ComputerName SRV2 <#make sure you put the system name where SVR2 is#> {Get-PSDrive C} | Select-Object PSComputerName,Used,Free

#BONUS-------------------------------------------------------------------------------------BONUS#
#You can also extract values by assigning them as a vairable. If you use this method on more then one drive or system you will be to consistantly reasign the variable
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName remotecomputer -Filter "DeviceID='C:'" | Select-Object Size,FreeSpace

$disk.Size
$disk.FreeSpace
