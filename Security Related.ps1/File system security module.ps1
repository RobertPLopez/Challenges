#There are a variety of uses Powershell can do when it comes to managing permissions. 

#Example 1 Exploring NTFS file and folder permissions:
[System.Enum]::GetNames([System.Security.AccessControl.FileSystemRights])
#easily view all of the available permissions, you can output in NFTS

#Example 2a Retrieving access permissions on a file and folder using Get-Acl:
​Get-ACL -Path "Folder1" #put the file here

#Example 2b
#expand the access property more to see what permissions are set on this folder.
(Get-ACL -Path "Folder1").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Example 2c
#a new file and see what its permissions are
​(Get-ACL -Path "Test1.txt").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Example 3 Modifying files and folder permissions with Get-Acl and Set-Acl:
#To do this in PowerShell it’s easiest to follow this four step process.
    #Retrieve the existing ACL rules
    #Craft a new FileSystemAccessRule to apply
    #Add the new ACL rule on the existing permission set
    #Apply the new ACL to the existing file or folder using Set-ACLTo craft the rule itself, we need to create the FileSystemAccessRule which has a constructor like so: Identity String, FileSystemRights, AccessControlType.

​$ACL = Get-ACL -Path "Test1.txt" #Put your existing ACL rules path here 
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("TestUser1","Read","Allow") #You need to make sure you change these variables to reflect your enviornment
$ACL.SetAccessRule($AccessRule)
$ACL | Set-Acl -Path "Test1.txt" (Get-ACL -Path "Test1.txt").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Example 4 Copying permissions to a new object with Get-Acl and Set-Acl: 
    #we can use the PowerShell pipeline ability to transfer the permissions from one object to another.

​Get-ACL -Path "Test1.txt" | Set-ACL -Path "Test2.txt" #in this example its two .txt files, but the same principal applies you can transfer permissions to any other ACL path 
(Get-ACL -Path "Test2.txt").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Example 5 Removing file or folder permissions with Get-Acl and Set-Acl:
    #You need to recreate the exact FileSystemAccessRule that we want to remove. This is an explicit means of removing permissions that removes ambiguity about what permission to remove.
$ACL = Get-ACL -Path "Test1.txt" #Put your existing ACL rules path here 
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("TestUser1","Read","Allow")
$ACL.RemoveAccessRule($AccessRule)
$ACL | Set-Acl -Path "Test1.txt" (Get-ACL -Path "Test1.txt").Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#----------------------------------------------------Extras------------------------------------------------------------#
#Modifying inheritance and ownership with Get-Acl and Set-Acl
    #two additional file system tasks that are very useful to know are enabling and disabling inheritance on a folder and the changing of a files owner.

#Disable/enable permissions inheritance
    #To modify the inheritance properties of an object, we have to use the SetAccessRuleProtection method with the constructor: isProtected, preserveInheritance. The first isProtected property defines whether or not the folder inherits its access permissions or not. Setting this value to $true will disable inheritance as seen in the example below.

    #The secondary property, preserveInheritance allows us to copy the existing inherited permissions onto the object if we are removing inheritance. This can be very important #so that we do not lose our access to an object but may not be desired.

    #You should run the following script in an admin account to avoid errors

$ACL = Get-Acl -Path "Folder1" #Put your induvisual folder here
$ACL.SetAccessRuleProtection($true,$false)
$ACL | Set-Acl -Path "Folder1"

#Change ownership with Get-Acl and Set-Acl
    # to change the owner of a file, you can do this simply by using the SetOwner method. After running a Get-ACL command, we can see that the owner has changed to our new user.

$ACL = Get-Acl -Path "Folder1" #Put your induvisual folder here
$User = New-Object System.Security.Principal.Ntaccount("TestUser1")
$ACL.SetOwner($User)
$ACL | Set-Acl -Path "Folder1"
Get-ACL -Path "Folder1"

#----------------------------------------------------Notes-------------------------------------------------------------#
#This module makes managing file and folder permissions in Powershell very easy. NTFSSecurity gives you cmdlets for a variety of tasks including day to day ones like pulling up permission reports, adding permissions to an item and removing ACEs (Access Control Entries). You can even use a cmdlet to get the specific permissions in place for a particular user.

#The types of permissions are listed below

#Basic Permissions
    #Full Control: Users can modify, add, move and delete files and directories, as well as their associated properties. In addition, users can change permissions settings for all files and subdirectories.
    #Modify: Users can view and modify files and file properties, including deleting and adding files to a directory or file properties to a file.
    #Read & Execute: Users can run executable files, including script
    #Read: Users can view files, file properties and directories.
    #Write: Users can write to a file and add files to directories.

#Advanced Permissions
    #Traverse Folder/Execute File: Allow navigation through folders, even if the user has no explicit permissions to those files or folders. Additionally, users can run executable files.
    #List Folder/Read Data: The ability to view a list of files and subfolders within a folder as well as viewing the content of the files contained within.
    #Read Attributes: View the attributes of a file or folder.
    #Write Attributes: Change the attributes of a file or folder.
    #Read Extended Attributes: View the extended attributes of a file or folder.
    #Write Extended Attributes: Change the extended attributes of a file or folder.
    #Create Files/Write Data: Allow creation of files within a folder, whereas write data allows changes to files within the folder.
    #Create Folders/Append Data: Create folders within an existing folder and allow adding data to a file, but not change, delete, or overwrite existing data within a file.
    #Delete: Ability to delete a file or folder.
    #Read Permissions: Users can read the permissions of a file or folder.
    #Change Permissions: Users can change the permissions of a file or folder.
    #Take Ownership: Users can take ownership of a file or folder.
    #Synchronize:  Use a file or folder for synchronization. This enables a thread to wait until the object is in the signaled state.

#References 
https://petri.com/how-to-use-powershell-to-manage-folder-permissions/