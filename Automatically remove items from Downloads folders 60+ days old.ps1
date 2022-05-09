$Folder = "G:\Downloads" #put the directoy folder where you want to delete

#Delete files older than 6 months
Get-ChildItem $Folder -Recurse -Force -ea 0 |
 
Where-Object {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-60)} <#Test#> |
ForEach-Object {
   $_ | Remove-Item -Force
   $_.FullName | Out-File C:\log\deletedlog.txt -Append
}

#Delete empty folders and subfolders
Get-ChildItem $Folder -Recurse -Force -ea 0 |
Where-Object {$_.PsIsContainer -eq $True} |
Where-Object {$_.getfiles().count -eq 0} |
ForEach-Object {
    $_ | Remove-Item -Force
    $_.FullName | Out-File C:\log\deletedlog.txt -Append
    }