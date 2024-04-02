import-module activedirectory
$Users = Import-Csv -Path "C:\Users\puligaddas\Files\Scripts\List.csv" -Header "AccountName"
foreach($User in $Users){ 
$ADUser = Get-ADUser -Identity $User.AccountName -Properties Description 
$ADUser.Description = "Global Helpdesk Team" 
Set-ADUser -Instance $ADUser
}