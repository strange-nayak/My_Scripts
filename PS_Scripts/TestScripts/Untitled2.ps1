Import-Module ActiveDirectory
$data=Search-ADAccount -LockedOut -SearchBase "OU=HBAD Users,OU=HBAD,DC=bsg,DC=ad,DC=adp,DC=com"

$data.Name | Out-File C:\Nayak_testlab\PS_Scripts\lockeduser.txt

foreach($x in $data){

$x.Name

Unlock-ADAccount -Identity $x.Name
}