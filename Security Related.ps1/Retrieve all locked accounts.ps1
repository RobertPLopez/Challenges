#------------------------------------Step By Step--------------------------------------#

#Finding all lockedout accounts in Active Directory with PowerShell 
Search-AdAccount -LockedOut

#To find the source of an Active Directory lockout, you’ll first need to ensure you’re querying the right domain controller. In this case, this will be the domain controller with the PDC emulator role.

$pdce = (Get-ADDomain).PDCEmulator

#Once you have the DC holding the PDCe role, you’ll then need to query the security event log (security logs) of this DC for event ID 4740. Event ID 4740 is the event that’s registered every time an account is locked out.
Get-WinEvent -ComputerName $pdce -FilterHashTable @{'LogName' ='Security';'Id' = 4740}

#This will return all of the lockout events including events with the username and computers
$filter = @{'LogName' = 'Security';'Id' = 4740}
$events = Get-WinEvent -ComputerName $pdce -FilterHashTable $filter
$events | Select-Object @{'Name' ='UserName'; Expression={$_.Properties[0]}}, @{'Name' ='ComputerName';Expression={$_.Properties[1]}}

#Unlocking those AD Accounts
Unlock-ADAccount -Identity '' #You need to replace the '' with the accounts names that are needed to be unlocked

    #BONUS: The following will unlock all unlocked users in the ADAccount 
    Search-ADAccount -LockedOut | Unlock-ADAccount

#--------------------------------Compiled Script--------------------------------------#

$pdce = (Get-ADDomain).PDCEmulator
$filter = @{'LogName' = 'Security';'Id' = 4740}
$events = Get-WinEvent -ComputerName $pdce -FilterHashTable $filter
$events | Select-Object @{'Name' ='UserName'; Expression={$_.Properties[0]}}, @{'Name' ='ComputerName';Expression={$_.Properties[1]}} | Unlock-ADAccount -Identity '' #will need to specfically state which accounts are locked even in the compiled script. It is better to just go through the step by step process. 