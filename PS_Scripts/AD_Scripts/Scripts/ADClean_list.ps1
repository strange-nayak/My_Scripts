Import-Module ActiveDirectory
$Date= date
$DateStr = $Date.ToString("MM-dd-yyyy")
$data= Get-ADUser -filter * -Properties Description, CanonicalName, employeeNumber, department, manager | Where-Object {$_.description -like 'Termed*'} | select Name, SamaccountName, Description, CanonicalName, employeeNumber, department, manager
#$Drive=Foreach($User in $data.SamaccountName){
#$Detail=Get-ADUser -Identity $User -Properties Homedirectory 
#$Detail.Homedirectory
#}
$data | Export-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\ADclean_$DateStr.csv"