#Net Cease is a PowerShell script that Itai Grady released initially to help secure Remote SAM before it was introduced properly by Microsoft. This is the base for this script. All rights go to Itai Grady and Microsoft. 

#Registry Key Information
$key = "HKLM:SYSTEMCurrentControlSetServicesLanmanServerDefaultSecurity"
$name = "SrvsvcSessionInfo"

#Get the Registry Key and Value
$Reg_Key = Get-Item -Path $key
$BtyeValue = $reg_Key.GetValue($name, $null)

#Create a CommonSecurityDescriptor Object using the Byte Value
$Security_Descriptor = New-Object -TypeName System.Security.AccessControl.CommonSecurityDescriptor -ArgumentList $true, $false, $ByteValue, 0

#Output of the ACL to make it simple to see for document. Use only $Security_Descriptor.DiscretionaryAcl if you want to see the full ACL!
$Security_Descriptor.DiscretionaryAcl | Select-Object SecurityIdentifier, ACEType | Format-Table -AutoSize

#----------------------------------------------------Notes-------------------------------------------------------------#
#Net Sessions Enumeration can be used by attackers to get information about the sessions established on a server including computer names, usernames, session active times, and IP addresses. NetSessionEnum can be executed by any authenticated user by default. The Net Cease script alters this by giving you the ability to remove the execute permissions for all authenticated users and instead add permissions to particular sessions.

#information on well known SID can be found at: 
https://docs.microsoft.com/en-GB/windows/security/identity-protection/access-control/security-identifiers

