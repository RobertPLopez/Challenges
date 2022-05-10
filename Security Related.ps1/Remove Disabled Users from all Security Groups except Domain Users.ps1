#----------------------Generate a csv file for accounts that need to be disabled---------------------------#

Get-ADGroupMember 'GroupName' <#put the specfic Group here, but take out the ''#> | ForEach-Object {
    if ((Get-ADUser $_).Enabled -eq $false) {
      $_
    }
  } | 
Export-Csv -path #put the exact location where you want the csv to be located here

#BONUS---------------------------If you dont know a specfic group name--------------------------------BONUS#

get-adgroup -filter * | Sort-Object name | Select-Object Name

#If looking for a specfic name but you only know a partial. For example you want IT Admin$, but only know the IT Admin piece (uses a wildcard)

Get-ADGroup -Filter {Name -like 'ABC_*'}  -Properties * | Select-Object -property SamAccountName,Name,Description,DistinguishedName,CanonicalName,GroupCategory,GroupScope,whenCreated
#or
Get-ADGroup -Filter {Name -like 'ABC_*'} -SearchBase "DC=YourDC" | Get-ADGroupMember -Partition "DC=YourDC"
#or
Get-ADGroup 'Group Name' -Properties Member | Select-Object -ExpandProperty Member
#or (.notation)
(Get-ADGroup 'Group Name' -Properties Member).Member


#---------------------------------------Automated email script---------------------------------------------#

$From = <#Put your email here#>
$To = <#Put to email here#>, <#Put to email here#>
$Cc = <##>
$Attachment = "" <#Put any attachments here (possibly a .csv file containing all the people to be disabled)#>
$Subject = "" <#Put subject here#>
$Body = "<h2>Attached is the weekly list of users who are going to be disabled. Please letme know if there are any problems with this list.!</h2><br><br>"
$Body += “” <#Extra space if need be feel free to delete this#>
$SMTPServer = "smtp.mailtrap.io" <#Dont forget that this needs to to specficed to your unique organization. Specfically for the smtp mail server. This script uses a placeholder#>
$SMTPPort = "587" <# Need the specfic port number. A breakdown is listed below#>
Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment

#--------------------------------Removal from security groups script--------------------------------------#

#Listed below is the script to delete personnel based on there security group
#Need to know the specfic security group
$groupName = 'NAME_HERE'
$Members   = (Get-ADGroup $groupName -Properties members).members
foreach($member in $members){
    write-verbose "Checking on '$member'..." -verbose
    $userstatus = Get-aduser $member
    if(-not($userstatus.enabled)){
        Remove-ADGroupMember $groupName -Members $member -Confirm:$false -Verbose
    }
}

#-------------------------------------------------Notes--------------------------------------------------#
#Parameter	                                           Description
    #-To	                                               Email address of a recipient or recipients
    #-Bcc	                                               Email address of a BCC recipient or recipients
    #-Cc	                                               Email address of a CC recipient or recipients
    #-From	                                               Sender’s email address
    #-Subject	                                           Email subject
    #-Body	                                               Email body text
    #-BodyAsHtml	                                       Defines that email body text contains HTML
    #-Attachments	                                       Filenames to be attached and the path to them
    #-Credential	                                       Authentication to send the email from the account
    #-SmtpServer	                                       Name of the SMTP server
    #-Port	                                               Port of the SMTP server
    #-DeliveryNotificationOption	                       The sender(s) specified in the Form parameter will be notified on the email delivery. Here are the options:
                                                                #None – notifications are off (default parameter) 
                                                                #OnSuccess – notification of a successful delivery 
                                                                #OnFailure – notification of an unsuccessful delivery 
                                                                #Delay – notification of a delayed delivery
                                                                #Never – never receive notifications
    #-Encoding	                                           The encoding for the body and subject
    #-Priority	                                           Defines the level of priority of the message. Valid options are:
                                                                #Normal (default parameter)
                                                                #Low
                                                                #High
    #-UseSsl	                                           Connection to the SMTP server will be established using the Secure Sockets Layer (SSL) protocol