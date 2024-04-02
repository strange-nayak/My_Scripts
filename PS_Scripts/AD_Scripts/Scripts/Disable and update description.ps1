import-module activedirectory
$server = "jsq.bsg.ad.adp.com"
$Users = Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\User.csv" -Header "AccountName"
foreach($User in $Users){
$AccountName= $User.AccountName
$ADUser = Get-ADUser -Identity $AccountName  -server $server -Properties Description
$ADUser.Description = "Disabled Inactivity"
Disable-ADAccount -Identity $AccountName -server $server
Set-ADUser -Instance $ADUser
}
