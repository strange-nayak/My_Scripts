Import-Module Activedirectory
$Users= Import-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Ids.csv"
$data= foreach($User in $Users.email){
Get-ADUser -Filter { mail -eq $User } -Properties * -Server bsg.ad.adp.com:3268 | Select Samaccountname, mail
}
$data