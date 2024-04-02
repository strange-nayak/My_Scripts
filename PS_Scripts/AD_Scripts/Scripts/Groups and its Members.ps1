Import-Module ActiveDirectory
$Groups= Get-ADGroup -filter * -Server "adp-icd.net" | Where-Object {$_.name -like 'Transtar*'}  | select Name
foreach ($Group in $Groups){
$GroupName= $Group.Name
$Report= Get-ADGroupMember -Identity $GroupName -Server "adp-icd.net"
$Report | Export-csv "C:\Users\PuligaddaS\Desktop\PowerGUI\ADP\$Groupname.csv"
}