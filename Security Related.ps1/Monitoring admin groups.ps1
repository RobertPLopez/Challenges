#This script is for security administrators to help monitor when new users are added to certain groups. It is a multi-step process (jump to Step 4a)

#Step 1: Retrive Domain Admin Group members (creates a baseline)
(Get-ADGroupMember -Identity "Domain Admins").Name

#Step 2: Make the baseline a .txt file 
(Get-ADGroupMember -Identity "Domain Admins").Name | Out-File C:\Temp\Admins.txt #this location should be personalized based on your local environment and needs. Best practice to maintain it in a secure part of your network. 

#Step 3: Make a changed .txt file 
(Get-ADGroupMember -Identity "Domain Admins").Name | Out-File C:\Temp\Admins2.txt #this location should be personalized based on your local environment and needs. Best practice to maintain it in a secure part of your network.
#Need to figure out how to trigger / automate this task so that it automatically created 

#Step 4: Compare the contents of each .txt that was created 
$a=Get-Content C:\Temp\Admins.txt
$b=Get-Content C:\Temp\Admins2.txt
$differ=Compare-Object -ReferenceObject $a -DifferenceObject $b | Select-Object -ExpandProperty InputObject

#---------------------------------Do Step 4a---------------------------------#

#Step 4a: An alternate method is to save the group members as a variable (This is probably a better method)
$ref=(Get-ADGroupMember -Identity "Domain Admins").Name
$diff=(Get-ADGroupMember -Identity "Domain Admins").Name

#Step 5: Create a Script to compare membership on a regular basis once per day
$ref=(Get-ADGroupMember -Identity "Domain Admins").Name
Start-Sleep -Seconds 86398
$diff=(Get-ADGroupMember -Identity "Domain Admins").Name
$result=(Compare-Object -ReferenceObject $ref -DifferenceObject $diff | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "
If ($result)
{msg * "The following user was added to the Domain Admins Group: $result"}

#This section of the script sends an alert email 
$ref=(Get-ADGroupMember -Identity "Domain Admins").Name
Start-Sleep -Seconds 86398
$diff=(Get-ADGroupMember -Identity "Domain Admins").Name
$date=Get-Date -Format F
$From = <#Put your email here#>
$To = <#Put to email here#>, <#Put to email here#>
$Cc = <##>
$Subject = "Domain Admin Membership Changes | $result was added to the Group" <#Put subject here#>
$Body = "<h2>This alert was generated at $date</h2><br><br>"
$Body += “” <#Extra space if need be feel free to delete this#>
$SMTPServer = "smtp.mailtrap.io" <#Dont forget that this needs to to specficed to your unique organization. Specfically for the smtp mail server. This script uses a placeholder#>
$SMTPPort = "587" <# Need the specfic port number. A breakdown is listed below#>

$result=(Compare-Object -ReferenceObject $ref -DifferenceObject $diff | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "

If ($result)
{Send-MailMessage -From $From -to $To -Cc $Cc -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Subject $Subject -Body $Body -BodyAsHtml -Priority High}

#The mail server need to accepts emails from your computer. 

#---------------------------------------------Extras---------------------------------------------#
#A basic security practice is to put your scirpt into a task scheduler the following script will do just that 
$Action=New-ScheduledTaskAction -Execute "powershell" -Argument "C:\Alerts\domain_admins.ps1" #This should be where your script resides and will be based off of your local environment
$Trigger=New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds 86400) -RepetitionDuration ([timespan]::MaxValue) #You can adjust to verify that you will repeat this task based off of your security requirements 
$Set=New-ScheduledTaskSettingsSet
$Principal=New-ScheduledTaskPrincipal -UserId "sid-500\administrator" -LogonType S4U #YOU NEED TO MODIFY THE USER ID TO MAKE SURE IT HAS THE CORRECT ID FOR YOUR ENVIRONMENT
$Task=New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Set -Principal $Principal
Register-ScheduledTask -TaskName "Domain Admins Check" -InputObject $Task -Force

#If the administrator group membership changes very rarely, create a baseline. 

#Step 1: First save your baseline to a file (.txt or .csv).
(Get-ADGroupMember -Identity "Domain Admins").Name | Out-File C:\Temp\Admins.txt #This will change based on your requirments 

#Step 2: compare the group membership against the baseline
$base=Get-Content C:\Temp\Admins.txt #Will change match the out-file command from step 1
$diff=(Get-ADGroupMember -Identity "Domain Admins").Name
$result=(Compare-Object -ReferenceObject $base -DifferenceObject $diff | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "
If ($result)
{msg * "The following user was added to the Domain Admins Group: $result"}

#----------------------------------------------------Notes-------------------------------------------------------------#
#Local admin groups are one of the biggest points of vulnerability for a system where hackers can create local admin accounts on specific systems without being noticed. This script routinely questions multiple machines for changes in local admin groups and sends email reports whenever new members are added.

