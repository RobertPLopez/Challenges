Import-Module ActiveDirectory

$date = Get-Date
#$date = $date.AddDays(6)
$begdate = Get-Date -date $date -Format "MMM d"
$dateadd = $date.adddays(31) -as [datetime]
$enddate = Get-Date -date $dateadd -Format "MMM d" 

$expireds = Search-ADAccount -AccountExpired | Where-Object {$_.Enabled -eq $true} | Select-Object Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | Format-List Name, AccountExpirationdate, Enabled, Manager
    if ($null -eq $expireds){
        $body = "Good morning, `n`nThere are no currently expired accounts."
        }
    else {
        $body ="Good morning, `n`nThe following accounts have been detected as expired yet still active"
        $out = $expireds | Out-String
        $body += $out
        }

$body += "`n`nAdditionally...`n`n" #can be used to write a message is need be when automated

$expiring = Search-ADAccount -AccountExpiring -TimeSpan "31" | Where-Object {$_.Enabled -eq $true}| Select-Object Name, AccountExpirationdate,DistinguishedName,Enabled,@{Name='Manager';Expression={(Get-ADUser(Get-ADUser $_ -properties Manager).manager).Name}} | Format-List Name, AccountExpirationdate, Enabled, Manager
    if ($null -eq $expiring){
        $body += "No accounts are expiring within the next 31 days."
        }
    Else {
        $body += "The following accounts were detected as expiring soon:"
        $out = $expiring | Out-String
        $body += $out
        }

#The below items are used to help specficy where the report is going to be sent. AKA put your email name a pass in below
$SMTPServer = <#SMPT Server Address#>
$SMTPPort = <#SMTP Port#>
$Username = <#SMTP Username#>
$Password = <#SMTP Password#>

$subject = "Weekly Account Report for $begdate `- $enddate"

$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add(<#Recipient 1#>)
$message.cc.add(<#Recipient 2#>)
#$message.cc.add($cc)
$message.from = $username
#$message.attachments.add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $False
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)