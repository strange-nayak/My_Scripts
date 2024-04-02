Write-Host "Enter Username:"
$User= Read-Host
Import-Module activeDirectory
Get-ADUser -Identity $User -Properties LockedOut | Select-Object Name,Lockedout 
if ( "$User -Properties LockedOut" -eq "True" ) 
{
    Unlock-ADAccount -Identity $User
    Write-Output "$($User) Has been Unlocked"
}