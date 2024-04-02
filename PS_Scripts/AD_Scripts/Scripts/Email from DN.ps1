import-module activedirectory

$Users = Import-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\DisplayName.csv"

$Data= foreach($User in $Users.displayname){ 

Get-ADUser -Filter {Name -eq $User} -Properties * -Server bsg.ad.adp.com:3268 | Select Name, mail, DisplayName

    }
$Data | Export-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Output.csv"