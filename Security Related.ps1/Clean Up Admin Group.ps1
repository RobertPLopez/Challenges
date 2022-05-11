#This is a multistep process that helps security admins keep the administrater group cleaned 

#Step 1: Check who the members of the local admin group are: 
Get-LocalGroupMember -Group 'Administrators'

#Step 2a: Remove all users from teh local administrator group:
Get-LocalGroupMember -Group 'Administrators' | Where-Object {$_.objectclass -like 'user'} | Remove-LocalGroupMember Administrators

#Step 2b: Removal of specfic groups such as domain users: 
Get-LocalGroupMember -Group 'Administrators' | Where-Object {$_.Name -like 'domain\domain users'} | Remove-LocalGroupMember Administrators

#Step 3: Performing this task remotely. In order to do this you need to have a remote user nugget and know the spefic names of the systems that you are going to remotly clean up. 
#all clients needs to be on the same network (either on prem or in Azure) for the remote command to be successful
Invoke-Command -ComputerName $comp -ScriptBlock 
    {
    Get-LocalGroupMember -Group 'Administrators' | Where-Object {$_.objectclass -like 'user'} | Remove-LocalGroupMember Administrators
    Get-LocalGroupMember -Group 'Administrators' | Where-Object {$_.name -like 'domain\domain users'} | Remove-LocalGroupMember Administrators}

#-----------------------------------------------------Notes-----------------------------------------------------#
#Removing local admin rights are a vital way to help maintain the security of your organization. Having multiple users on a local administration group creates one of the biggest and most common loopholes for a hacker to break in to. This script gives you the ability to remove the names of multiple users from the local administrator groups of multiple computers in one shot. It takes in a text file with the names of users to be removed and another text file with the names of the machines on which this is to be done.

#All you need to modify in the script before running it is to a) replace the name present in the variable $Computernames with the name of the text file containing the machine names, and b) replace the name present in the variable $Admins with the name of the text file containing the user names.

#Some additional scripts that can be added to this topic include:
        #create a timer (aka daily scrub of admin)
        #add an alert mechanism for when people are deleted 
        #create an authorized admin ACL (see monitoring admin groups script)
