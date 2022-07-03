#Create an SMB share properites are layed horizontel. 

Get-Process C:\>New-SmbShare -Name "VMSFiles" -Path <#"C:\ClusterStorage\Volume1\VMFiles" put the file pather here#>  -FullAccess "Contoso\Administrator", "Contoso\Contoso-HV1$"

#Create an encrypted SMB share 

New-SmbShare -Name "Data" -Path <#"J:\Data" put the file pather here#> -EncryptData $True

#Create an SMB share with Multiple Permissions

Get-Process C:\>New-SmbShare -Name "VMSFiles" -Path <#"C:\ClusterStorage\Volume1\VMFiles" put the file path here#> -ChangeAccess "Users" -FullAccess "Administrators"

#Create an SMB share properties 
New-SmbShare -Name <#String#>
             -Path <#String#>
             -FullAccess <#String[]#>
             -ChangeAccess <#String[]#>
             -ReadAccess <#String[]#>
             -Description <#String#>

#Mapping a network using PowerShell
New-PSDrive -Name "drive-letter" -PSProvider "FileSystem" -Root "\\device\shared-directory"
New-PSDrive -Name "L" -PSProvider "FileSystem" -Root "\\ADNAN\Users\NEW"
Get-PSDrive -PSProvider "FileSystem"
Get-ChildItem -Path L:
