Import-Module ActiveDirectory

$Groups = Import-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\DisLists.csv"

foreach($Group in $Groups.email){

$Group
Get-ADGroup -Identity $Group | Move-ADObject -TargetPath "OU=DBLN Groups,OU=DBLN,DC=bsg,DC=ad,DC=adp,DC=com"

} 
