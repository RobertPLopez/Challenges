Import-Module ActiveDirectory; 

$date = Get-Date;
#Get Computers
Get-ADComputer -filter * -Properties LastLogonDate,Name,Description,Created |
#filters such as last login
Where-Object {$_.LastLogonDate -lt $date.AddDays(-30)}|
Where-Object {$_.Created -lt $date.AddDays(-30)}| 
#Write / record the results
Select-Object Name,DistinguishedName,Created,LastLogonDate,Description,DNSHostName,Enabled|
export-csv staleComputers.csv   

#------------------------------------------------------------------------------------------#

# Specify inactivity range value below
$DaysInactive = 30
# $time variable converts $DaysInactive to LastLogonTimeStamp property format for the -Filter switch to work

$time = (Get-Date).Adddays(-($DaysInactive))

# Identify inactive computer accounts

Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName, LastLogonDate | 
Export-CSV “C:\Temp\StaleComps.CSV” –NoTypeInformation