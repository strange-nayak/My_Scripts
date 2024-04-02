#Adding Email address to DL

Import-module ActiveDirectory
$Users= Import-csv -path "C:\Nayak_testlab\Saisuhant's Scripts\HYD.csv"
foreach ($User in $Users.mail)
{

   $ADUser= Get-ADUser -Filter { mail -eq $User } -Properties * -Server bsg.ad.adp.com:3268 | Select Samaccountname
   $ADUser
   Add-ADGroupMember -Identity "BRCC eSol(HYD)" -Members $ADUser.Samaccountname
}