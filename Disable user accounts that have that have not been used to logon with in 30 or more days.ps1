#Step 1: create the text file: 

New-Item D:\temp\test\test.txt #put the location for the the txt file here

Search-ADAccount -AccountDisabled -UsersOnly | Select-Object Name,LastLogonDate,Enabled | Set-Content D:\temp\test\test.txt #Make this the same location as above

#Step 3: Disable multiple accounts from the txt file
$users=Get-Content c:\ps\users.txt #This need to be the txt file that was referenced prior

ForEach ($user in $users)
    {Disable-ADAccount -Identity $($user.name)}

#Check and Disable user accounts that have that have not been used to logon with in 30

$timespan = New-Timespan -Days 30
Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $timespan | Disable-ADAccount