#Enable account based on Employee Number

Import-Module Activedirectory
$Users= Import-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\EmpID.csv"
foreach($User in $Users.EmpID)
{
$ADUSer= Get-ADUser -Filter{Employeenumber -eq $User} -Properties * 
$AccountName= $ADUSer.Samaccountname
$AccountName
Enable-ADAccount -Identity $AccountName

}