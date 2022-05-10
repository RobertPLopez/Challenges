# Import the AD Module
Import-Module ActiveDirectory

# List all accounts which are already disabled on your AD
Search-ADAccount -AccountDisabled | Select-Object Name, DistinguishedName

# Move all disabled AD users from others OU to the disabled users OU
Search-ADAccount -AccountDisabled | Where-Object {$_.DistinguishedName -notlike “*OU=Disabled Users*”} | Move-ADObject -TargetPath “OU=Disabled Users,OU=losangeles,DC=world,DC=com”

#---------------------------------------------------------------If you want to disable the entire ou---------------------------------------------------------------------------------#

# Now, disable all users in that disabled users OU either they are already disabled or not
Get-ADUser -Filter {Enabled -eq $True} -SearchBase “OU=Disabled Users,OU=losangeles,DC=world,DC=com” | Disable-ADAccount