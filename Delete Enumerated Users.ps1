#Local get user
Get-CimInstance -ClassName win32_userprofile | Select-Object -First 1

#Remote get user
Get-CimInstance -ClassName Win32_UserProfile -ComputerName localhost,WINSRV

#Delete local user
Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'UserA' } | Remove-CimInstance

#Remove users ober multiple systems 
Get-CimInstance -ComputerName SRV1,SRV2,SRV3 -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq 'UserA' } | Remove-CimInstance
