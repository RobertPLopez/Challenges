#Get a list of printers 
Get-Printer

#Get information on a specfic printer 
Get-Printer -Name "Microsoft XPS Document Writer"
    #Format it on a list
    Get-Printer -Name "Microsoft XPS Document Writer" | Format-List

#Get a list of printers on a remote computer 
Get-Printer -ComputerName PrintServer

#Get a list of printer objects and then remane them (used for organization)
$Printer = Get-Printer -Name "Microsoft XPS Document Writer" #you have to create a specfic user object to get a list of printers 
Rename-Printer -InputObject $printer "MXDW"

#See the printer properties for all the installed printers
$printers = get-printer * 
foreach ($printer in $printers)
{ 
    get-printerproperty -printerName $printer.name 
}

#Get a list of print jobs on a specfic printer 
$Printer = Get-Printer -Name "PrinterName:" #make sure to replace this with the name of the printer needed
Get-PrintJob -PrinterObject $Printer

#-------------------------------------------------Notes--------------------------------------------------#
#You can use the Get-PrinterDriver to see all of the printer drivers
#You can use the Get-PrinterPort to see all the printer ports 
#You can use the Get-PrinterProperty to see the printer properties 