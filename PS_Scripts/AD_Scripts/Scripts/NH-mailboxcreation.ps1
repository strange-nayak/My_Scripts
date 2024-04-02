Set-ExecutionPolicy RemoteSigned
$Who= whoami
$UserCredential = Get-Credential -Credential "$who"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://edipswexmaa5.bsg.ad.adp.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session

$Users= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List.csv"
foreach($User in $Users)
{
$SamAccountName= $User.SamAccountName
$Database= $User.Database

Enable-Mailbox -Identity $SamAccountName -Database $Database

}
$Output=foreach ($User in $Users.samaccountname){
Get-ADuser -Identity $User -Properties *  -Server JSIPVWDDCA01.bsg.ad.adp.com | select Name, SamaccountName, mail 
}
$Output | Export-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\Email Ids.csv"