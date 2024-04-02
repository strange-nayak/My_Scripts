#Exporting Groups of an User
Write-Host "Enter Username:"
$User= Read-Host
Import-Module activeDirectory 
$Groups = Get-ADPrincipalGroupMembership $User -Server edipvwwdca01.bsg.ad.adp.com
$Groups| Export-csv "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\$User.csv"