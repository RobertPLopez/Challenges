#----------------------------------------------------Notes-------------------------------------------------------------#
#Hackers are constantly on the lookout for high privilege accounts to try and login to systems on the network. This module searches for all the specified event logs (with the security log being the default) on the specified machines (all the domain controllers being the default) for logon events from particular users (the default setting is for all accounts which belong to tier 0 groups).

#This module can help you assess which computers have been exposed in any suspected attack using specific privileged accounts. It works with all the Windows versions 7 and upwards.

#This subject is currently beyond my skill level for more information I suggest checking out: 
https://art-ek.github.io/pshell-virusTotal/
#He has three useful scripts for bug hunting that should be useful for any secops developer. 