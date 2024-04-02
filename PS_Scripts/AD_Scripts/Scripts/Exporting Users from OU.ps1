Import-Module ActiveDirectory
$OUdata= Get-ADOrganizationalUnit -filter * -Server "bsg.ad.adp.com:3268" | Where-Object {$_.name -like '* Contractors'}  | select Name
foreach($OU in $OUdata.name){
$Path= Get-ADOrganizationalUnit -Filter {Name -like $OU} -server "bsg.ad.adp.com:3268"| select DistinguishedName
$DN= $Path.DistinguishedName
Write-Host "The OU is" $DN
$Users= Get-ADUser -Filter * -SearchBase $DN -Properties * -Server "bsg.ad.adp.com:3268" | select EmployeeNumber, DisplayName, SamAccountName, DistinguishedName, Enabled, mail, UserprincipalName
$Users | Export-csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Contractors\$OU.csv"
Write-Host "Exported"
}

