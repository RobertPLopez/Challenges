#Example 1 start a process:
Start-Process Notepad.exe
    # Simply typing notepad.exe in PowerShell will have the same result:
    #Notepad.exe 

#Example 2 use the wait peraminter:
# Start the process example.bat and wait for it to finish
Start-Process -FilePath "c:\temp\example.bat" -Wait 
    #Whatever process you implement will be put in the filepath cmdlet, Keep in mind that any output of the process isn’t captured by default. So you won’t know if the bat file failed or successfully completed.

#Example 3 utilize an entire window:
# Default behavior:
Start-Process -FilePath "c:\temp\example.bat" -Wait -WindowStyle Normal
# Maximized
Start-Process -FilePath "c:\temp\example.bat" -Wait -WindowStyle Maximized
# Minimized
Start-Process -FilePath "c:\temp\example.bat" -Wait -WindowStyle Minimized

#Example 4: The -NoNewWindow:
#This will run the process in the same window as the PowerShell script. This option only works with command-line-based processes. You can’t for example, open Notepad in the same window as PowerShell.
Start-Process -FilePath "c:\temp\example.bat" -Wait -NoNewWindow

#Example 5 Using arguments: 
Start-Process -FilePath "C:\temp\example.msi" -Wait -ArgumentList "/quiet /norestart"
# Or arguments as string array:
Start-Process -FilePath "C:\temp\example.msi" -Wait -ArgumentList "/quiet","/norestart"

#Example 6 using elevated permissions:
#some processes may need elevated permissions to run. To do this we can use the -Verb parameter.
Start-Process -FilePath "c:\temp\example.bat" -Wait -Verb RunAs

#Example 7 Starting processes using a different user: 
#By default you will be using the assigned used, but this can be changed. 

#First, you will need t to create a PSCredential object and store it as a secure string. Then you can pass the credentials to the cmdlet with the parameter -Credential.
$username = Read-Host "Enter your username"
$secureStringPwd = Read-Host -assecurestring "Please enter your password"

$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
Start-Process -FilePath "c:\temp\example.bat" -Wait -Credentials $credObjec
#Keep in mind that secure strings are not super secure to use, so make sure that you keep the secure string as safe as possible.

#Example 8 variable redirection:
#The output of the Start-Process cmdlet can’t be passed through to PowerShell. The only option that we have is to redirect the output to a text file. Variables won’t work.
# Redirect the output to example-output.txt
Start-Process -FilePath "c:\temp\example.bat" -Wait -RedirectStandardOutput c:\temp\example-output.txt
# Read the contents of example-output.txt
$output = Get-Content c:\temp\example-output.txt

#Example 9 Getting a process ID: 
#the -Passtru parameter will return the process object of the process that we have started. This can be useful when you want to automatically stop a process when it’s running for too long

$process = Start-Process "C:\temp\example.bat" -PassThru
# Get the process id
$process.ID
# Wait 1 second
Start-Sleep 1
# Kill the process
Stop-Process -id $process.Id

#----------------------------------------------------Notes-------------------------------------------------------------#
#One of the top recommended best practices from the point of view of security is to use an account with the least privileges possible so that even if a session were compromised, the loss would be limited to the bare minimum. This is particularly true when an administrator is running Active Directory. 

#This script allows you to run PowerShell scripts as a separate identity. In order to start a script as a different identity, this script would have the console program wait till the called script is completed, and then returns to the prompt.

#The Start-Process cmdlet allows you to run one or multiple processes on your computer from within PowerShell. It’s designed to run a process asynchronously or to run an application/script elevated (with administrative privileges).

#The following parameters apply to the cmdlet

#Parameter                                  Description
    #-FilePath                  	Specify the file, application, or process to run
    #-ArgumentList	                Specifies parameters to use with the process to start
    #-Credential	                User account to run the process with
    #-WorkingDirectory	            The location where the process should start in
    #-NoNewWindow	                Don’t open a new window for the process
    #-RedirectStandardError	        Specify text file to redirect error output to
    #-RedirectStandardInput	        Text file with input for the process
    #-RedirectStandardOutput	    Specify text file to redirect output to
    #-WindowStyle	                Normal, Hidden, Minimized, or Maximized
    #-Wait	                        Wait for the process to finish before continuing with the script
    #-UseNewEnvironment	            The process will use its own environment variables instead of those of the PowerShell session