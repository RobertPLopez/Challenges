Restart-Computer -ComputerName <#SRV1, SVR2, SVR3, SVR4#> -Force

#restart all computers within a domain for an update (except for servers)
(Get-ADComputer -Filter 'operatingsystem -notlike "*server*"').Name | Restart-Computer -Force -ErrorAction silentlycontinue

