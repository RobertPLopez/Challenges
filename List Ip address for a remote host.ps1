## Put where you want the csv to be located
$FileOut = ".\Computers.csv"
## Ping subnet
$Subnet = "192.168.xyz." #Put your internal subnet here
1..254|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select-Object Computername,IPv4,MAC

ForEach ($Computer in $Computers){
  nslookup $Computer.IPv4|Select-String -Pattern "^Name:\s+([^\.]+).*$"|
    ForEach-Object{
      $Computer.Computername = $_.Matches.Groups[1].Value
    }
}
$Computers
$Computers | Export-Csv $FileOut -NotypeInformation
#$Computers | Out-Gridview

#----------------------------------------------Another Way-------------------------------------------------------#

#replace the string with e.g. "192.168.1.$_", whatever your subnet is, optional but will improve # of devices found
$ips= 0..255 | ForEach-Object{"10.0.0.$_"};

#optional: add ports to scan. 22=ssh, 80=http, 443=https, 135=smb, 3389=rdp
$ports= 22, 80, 443, 135, 3389;

#optional: change batch size to speed up / slow down (warning: too high will throw errors)
$batchSize=64;

$ips += Get-NetNeighbor | ForEach-Object{$_.IPAddress}
$ips = $ips | Sort-Object | Get-unique;
$ips | ForEach-Object -Throttlelimit $batchSize -Parallel {
    $ip=$_;
    $activePorts = $using:ports | %{ if(Test-Connection $ip -quiet -TcpPort $_ -TimeoutSeconds 1){ $_ } }
    if(Test-Connection $ip -quiet -TimeoutSeconds 1 -count 1){
        [array]$activePorts+="(ping)";
    } 
    if($activePorts){
        $dns=(Resolve-DnsName $ip -ErrorAction SilentlyContinue).NameHost;
        $mac=((Get-NetNeighbor |?{$_.State -ne "Incomplete" -and $_.State -ne "Unreachable" -and $_.IPAddress -match $ip}|ForEach-Object{$_}).LinkLayerAddress )
        return [pscustomobject]@{dns=$dns; ip=$ip; ports=$activePorts; mac=$mac}
    }
} | Tee-Object -variable "dvcResults"
$dvcResults | Sort-Object -property mac