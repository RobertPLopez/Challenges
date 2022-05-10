#Get a list of all expired user accounts 
Search-ADAccount -Server $ThisDomain -Credential $Creds -AccountExpired -UsersOnly -ResultPageSize 2000 -resultSetSize $null| Select-Object Name, SamAccountName, DistinguishedName

#Lists all accounts by when they expire
Get-ADUser -Filter 'enabled -eq $true' -Properties AccountExpirationDate | Select-Object sAMAccountName, distinguishedName, AccountExpirationDate
#^^^You will get and expiration date and time for a complete list of your AD users.

#Export the above command to a .csv file. 
Get-ADUser -Filter 'enabled -eq $true' -Searchbase "OU=IT,DC=enterprise,DC=com" -Properties AccountExpirationDate | Select-Object SAMAccountName, distinguishedName, AccountExpirationDate |export-csv C:\Temp\ExpiryDate.csv -NoTypeInformation

#List in the past 24 hours 
Search-ADAccount -AccountExpired | Where-Object {$_.AccountExpirationDate -ge ((Get-Date).AddDays(-1))}
