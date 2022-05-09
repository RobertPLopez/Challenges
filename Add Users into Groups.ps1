#This is the simple version of the add AD Groups
C:>Add-ADGroupMember -Identity GroupNAME -Members USERNAME


#Bulk user add
$Users = Import-Csv -Path "C:\adusers.csv" #need to put the path for the .csv file. 
#Iterate AdUsers to add user account in Group
foreach($User in $Users){
        try
        {
            Add-ADGroupMember -Identity Finance -Members $User.User -ErrorAction Stop -Verbose
        }
        catch
        {
            Write-Host "Error while adding user to adgroup"
        }
    }