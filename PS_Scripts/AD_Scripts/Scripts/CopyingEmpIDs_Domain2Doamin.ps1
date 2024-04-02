Import-Module ActiveDirectory
$Users= Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\ADP_Emp.csv"

$Details= foreach ($User in $Users.SamaccountName){

Try
{

$Data= Get-ADUser -Identity $User -Properties * -Server bsg.ad.adp.com:3268 | select SamaccountName, Name, Employeenumber, DisplayName

Set-ADUser -Identity $Data.SamaccountName -EmployeeNumber $Data.Employeenumber -Server ADP-ICD.net

 }

catch 
{

  $User
}
}
$Details | Export-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\ADP_Emp_Upd.csv" -NoTypeInformation