#SAMRi10 is a PowerShell script that Itai Grady released initially to help secure Remote SAM before it was introduced properly by Microsoft. This is the base for this script. All rights go to Itai Grady and Microsoft. 

[CmdletBinding()]
param([switch]$Revert)

function IsAdministrator
{
    param()
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal($currentUser)).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)   
}

function BackupRegistryValue
{
    param([string]$key, [string]$name)
    $backup = $name+'backup'
    
    #Backup original Key value if needed
    $regKey = Get-Item -Path $key 
    $backupValue = $regKey.GetValue($backup, $null)
    $originalValue = $regKey.GetValue($name, $null)
    
    if ($null -eq $backupValue)
    {
        if ($null -eq $originalValue)
        {
            $originalValue = ""
        }
    
        Set-ItemProperty -Path $key -Name $backup -Value $originalValue
    }

    return $originalValue
}

function RevertChanges
{
    param([string]$key,[string]$name)
    $groupName = "Remote SAM Users"
    $backup = $name+'backup'
    $regKey = Get-Item -Path $key

    #Backup original Key value if needed
    $backupValue = $regKey.GetValue($backup, $null)
    
    Write-Host "Reverting changes..."
    if ($backupValue -eq "")
    {
        #Delete the value when no backed up value is found
        Write-Host "Setting up default values"
        Remove-ItemProperty -Path $key -Name $name
        Remove-ItemProperty -Path $key -Name $backup
        Write-Host "Default was set successfully"
    }
    elseif ($backupValue -ne $null)
    {
        Write-Verbose "Backup value: $backupValue"
        Set-ItemProperty -Path $key -Name $name -Value $backupValue
        Remove-ItemProperty -Path $key -Name $backup
    } 
      
    try
    {
        $adsi = [ADSI]("WinNT://$env:COMPUTERNAME")
        $SAMRUsersGroup = $adsi.Children.Find($groupName, 'Group')
    }
    catch [System.Management.Automation.MethodInvocationException]
    {
        #Group might not exists.
    }

    if ($null -ne $SAMRUsersGroup)
    {
        Write-Host "Deleting 'Remote SAM Users' group."
        $adsi.Delete('Group', $groupName)
    }

    Write-Host "Revert completed"
}

function AddPermissionsForGroup
{
    param([string]$sddl,[System.DirectoryServices.DirectoryEntry]$SAMRUsersGroup)
    
    $remoteAccess = 0x00020000 # AKA READ_CONTROL https://msdn.microsoft.com/en-us/library/windows/desktop/aa374892(v=vs.85).aspx
    Write-Verbose "SDDL: $sddl"
    #Load the SecurityDescriptor
    $rsd = New-Object -TypeName System.Security.AccessControl.RawSecurityDescriptor -ArgumentList $sddl
    $wkt = $SAMRUsersGroup.objectSid.Value
    $SAMRUsers = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $wkt, $null
    foreach ($ace in $rsd.DiscretionaryAcl)
    {
        if (($ace.SecurityIdentifier.CompareTo($SAMRUsers) -eq 0) -and $ace.AceType -eq [System.Security.AccessControl.AceType]::AccessAllowed)
        {
            Write-Host "'SAMR Users' group already has permissions, please add members which require SAMR access to this group"
            return
        }
    }

    #Add Access Control Entry permission for SAMR Users Sid
    $commonAce = New-Object -TypeName System.Security.AccessControl.CommonAce -ArgumentList 0, 0, $remoteAccess, $SAMRUsers,$false, $null
    $rsd.DiscretionaryAcl.InsertAce(0, $commonAce)
    $sddl = $rsd.GetSddlForm([System.Security.AccessControl.AccessControlSections]::All)
    return $sddl
}

if (-not (IsAdministrator))
{
    Write-Host "This script requires administrative rights, please run as administrator."
    exit
}

$key = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$name = "RestrictRemoteSAM"

Write-Host "SAMRi10 1.00 by Itai Grady (@ItaiGrady), Microsoft Advance Threat Analytics (ATA) Research Team, 2016"

if ($Revert)
{
    RevertChanges -key $key -name $name
    exit
}

$samrSDDL = BackupRegistryValue -key $key -name $name
if ($samrSDDL -eq "")
{
    #set default value ((O:)owner sid:built-in administrators 
                       #(G:)primary group sid:built-in administrators 
                       #(D:)dacl:(allow access;no ace-flags;read control access rights;no objecttype;no inheritedobjecttype;built-in adminitrators)
    $samrSDDL = "O:BAG:BAD:(A;;RC;;;BA)"
}

$groupName = "Remote SAM Users"
$description = "Members in this group are granted the right to query SAM remotely"
$adsi = [ADSI]("WinNT://$env:COMPUTERNAME")

#Make sure the group doesn't exist
try
{
    $SAMRUsersGroup = $adsi.Children.Find($groupName, 'Group')
}
catch [System.Management.Automation.MethodInvocationException]
{
    #Group shouldn't exists on first run.
}

if ($SAMRUsersGroup -eq $null)
{
    $SAMRUsersGroup = $adsi.Create('Group', $groupName)
    $SAMRUsersGroup.SetInfo()
    $SAMRUsersGroup.Description = $description
    $SAMRUsersGroup.SetInfo()
    Write-Host "SAMR Users group created"
}

$samrSDDL = AddPermissionsForGroup -sddl $samrSDDL -SAMRUsersGroup $SAMRUsersGroup

#set new SDDL value with Administrators & SAMR Users permissions
if ($null -ne $samrSDDL)
{
    Set-ItemProperty -Path $key -Name $name -Value $samrSDDL
}

#-----------------------------------------------------Notes-----------------------------------------------------#

#Once hackers are able to breach a system through a particular point of vulnerability, they use compromised local and domain credentials to move around their victim network. One way to get all local and domain users along with group memberships to map possible routes in Windows 10 is to question the Security Account Manager remotely using the SAMR protocol.

#While it used to be that SAM could be accessed remotely by any network-connected user, Windows 10 later introduced an option to control access to SAM and also modified the default permissions to permit remote access only to administrators. The SAMRi10 script allows you to harden the remote access by giving SAM access to only members of a specific group. No, this is not discrimination, this is security protocols!

