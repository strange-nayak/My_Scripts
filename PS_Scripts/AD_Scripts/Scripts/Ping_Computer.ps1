$Computers= Import-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\comp.csv"
$data= foreach($Computer in $Computers.name){
$Ping= ping $Computer
$Remark= $Ping | select -Index 1

New-Object -TypeName psobject -Property @{
        ComputerName = $Computer
        Status = $Remark
        }
}
$data | select ComputerName, Status |export-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\ping.csv"