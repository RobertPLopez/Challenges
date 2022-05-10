#Retrieves the username and lockout status
Get-ADUser -Identity 'username' -Properties LockedOut | Select-Object Name,Lockedout

#Unlocks a specfic user if you know the username of the person. 
Unlock-ADAccount -Identity 'username'

##Combined script: 
Get-ADUser -Identity 'username' -Properties LockedOut | Select-Object Name,Lockedout | Unlock-ADAccount -Identity 'username'

#----------------------------------------------------------Multiple Users------------------------------------------------------------#

#Find all locked user accounts
Search-ADAccount -lockedout | Select-Object Name, SamAccountName

#Unlock all users 
Search-ADAccount -Lockedout | Unlock-AdAccount

#Combined script: 
Search-ADAccount -lockedout | Select-Object Name, SamAccountName | Unlock-AdAccount

#Verify all previsouly locked users were unlocked
Search-ADAccount -lockedout | Select-Object Name, SamAccountName