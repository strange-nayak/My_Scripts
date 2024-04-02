$Users= Import-Csv -path "C:\Nayak_testlab\Saisuhant's Scripts\Files\New folder\User_List.csv"
$Output=foreach ($User in $Users.samaccountname){
Get-ADuser -Identity $User -Properties * | select Name, SamaccountName, mail
}
$Output | Export-Csv -Path "C:\Nayak_testlab\Saisuhant's Scripts\Files\New folder\Userdetails.csv"