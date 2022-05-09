#Creating a new group
New-LocalGroup
   -Description <#String#>
   -Name <#String#>
   -WhatIf
   -Confirm
   <CommonParameters>

#Creating a new local user account
New-LocalUser
   -AccountExpires <#DateTime#>
   -AccountNeverExpires
   -Description <#String#>
   -Disabled
   -FullName <#String#>
   -Name <#String#>
   -NoPassword
   -UserMayNotChangePassword
   -WhatIf
   -Confirm
   -Password
   <CommonParameters> 

#Craeting a group with a description
New-ADGroup -Name Account_Printers -GroupScope DomainLocal -Description "Group for permissions to XYZ"

#Create a group and set manged by admin
New-ADGroup -Name GIS_Images -GroupScope DomainLocal -ManagedBy FirstName.LastName

#Craete a single group and add to an OU
New-ADGroup -Name Marketing_local -GroupCategory Security -Path "OU=ADPRO Groups,DC=ad,DC=activedirectorypro,DC=com"

#Craete bulk AD groups 
Import-Module ActiveDirectory

#Import CSV
$groups = Import-Csv <#‘c:\it\scripts\groups.csv‘ put the location of your csv file here#>


# Loop through the CSV
    foreach ($group in $groups) {

    $groupProps = @{

      Name          = $group.name
      Path          = $group.path
      GroupScope    = $group.scope
      GroupCategory = $group.category
      Description   = $group.description

      #Make sure you pup all the properites from the csv file here

      }#end groupProps

    New-ADGroup @groupProps
    
} #end foreach loop