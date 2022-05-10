for ($i=0; $i -le $max_iterations; $i++)
{
    $proc = Start-Process -filePath $programtorun -ArgumentList $argumentlist -workingdirectory $programtorunpath -PassThru

    # keep track of timeout event
    $timeouted = $null # reset any previously set timeout

    # wait up to x seconds for normal termination
    $proc | Wait-Process -Timeout 4 -ErrorAction SilentlyContinue -ErrorVariable timeouted

    if ($timeouted)
    {
        # terminate the process
        $proc | Stop-Process

        # update internal error counter
    }
    elseif ($proc.ExitCode -ne 0)
    {
        # update internal error counter
    }
}

#--------------------Notes--------------------#
#the purpose of this is to:
    #1. Start a process
    #2. Wait for it to orderly execute and finish
    #3. Kill it if it is crashed (e. g. hits timeout)
    #4. get exit code of process