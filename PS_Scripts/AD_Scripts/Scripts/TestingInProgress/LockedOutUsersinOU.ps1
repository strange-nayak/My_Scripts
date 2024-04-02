#Search-AdAccount -Identity $User -Properties LockedOut | Select-Object Name,samaccountname,Lockedout
Get-ADUser -filter * -SearchBase "OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" -Properties LockedOut | Select-Object samaccountname,lockedout

if("$User -Properties LockedOut" -eq "True")
{
Write-Output $User 
}