Import-Module ActiveDirectory
$Users= Import-Csv -path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List.csv"
$Details= foreach($User in $Users.AccountName){

Get-MailUser -Identity $User -Properties * -Server bsg.ad.adp.com:3268 | Select Name, distinguishedName, physicalDeliveryOfficeName, employeeNumber
}
$Details | Export-Csv -path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\UserDetails.csv"