import-module activedirectory

$Users = Get-Content "C:\Users\PuligaddaS\Desktop\PowerGUI\email.txt"

$data=foreach($server in $Servers)
{

foreach($User in $Users){ 

$ADUser = Get-ADUser  -Filter { mail -eq "$user.Email"} -Server bsg.ad.adp.com:3268  | Select-Object  Name,SAMAccountName,Mail

    New-Object -TypeName PSObject -Property @{

        Name = $ADUser.Name
        SAMAccountName = $ADUser.SamAccountName
        Mail = $ADUser.Mail
        
        }
    }
 }

$data | select-object Name,SAMAccountName, Mail | Export-Csv "C:\Users\PuligaddaS\Desktop\PowerGUI\Email_USer.CSV"
