Import-Module ActiveDirectory
$servers = "bsg.ad.adp.com:3268"
Import-Csv "C:\Users\puligaddas\Files\Scripts\Users.csv" | ForEach-Object {
 $samAccountName = $_."samAccountName"
$ADUser = Get-ADUser -Identity $samAccountName -Properties Description
$ADUser.Description = "Disabled Inactivity"
Set-ADUser -Instance $ADUser
Get-ADUser -Identity $samAccountName | Disable-ADAccount
}