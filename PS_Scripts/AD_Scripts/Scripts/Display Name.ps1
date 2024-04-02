import-module activedirectory

$Servers = "bsg.ad.adp.com","jsq.bsg.ad.adp.com"

$Users = Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Display.csv" -Header "AccountName"

$data=foreach($server in $Servers)
{

foreach($User in $Users){ 

$ADUser = Get-ADUser  -Identity $User.Accountname -Server $server -Properties *| select  Name, SAMAccountName, Emailaddress

    New-Object -TypeName PSObject -Property @{

        Name= $ADUser.Name
        SAMAccountName = $ADUser.SamAccountName
        Emailaddress = $ADUser.Emailaddress

          }

 }

}

$data | select-object Name,SAMAccountName,Emailaddress | Export-Csv "C:\Users\PuligaddaS\Desktop\PowerGUI\text.CSV"
