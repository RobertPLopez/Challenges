Get-ADComputer -Filter * -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap –Auto

foreach($computer in $computers)
{
    Invoke-Command -ComputerName $computer -ScriptBlock {
        Get-WmiObject Win32_bios
        Get-WmiObject Win32_processor
        Get-WmiObject Win32_PhysicalMemory
    }
}

#requirs ps remoting to be emabled on the remote systems which is enabled in group polcy