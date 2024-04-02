$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://EDIPVWEXMAA1.bsg.ad.adp.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
$Users= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List2.csv"
foreach($User in $Users)
{
$User
$FirstNm= $User.First
$LastNm= $User.Last
$SamAccountNm= $User.username
#$Domain= "broadridge.com"
$EmpID= $User.EmpID
$Passwd= ConvertTo-SecureString 'IT@blr2023' -AsPlainText -Force
$UPN= ("$FirstNm.$LastNm@broadridge.com")
#$Credentials = Get-Credential
#$ExpDate= $User.ExpDate
#$Office= $User.Office
$Description= $User.Description
$OU= $User.OU
#"OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com"
#$VPN= $User.VPN
#$Gender= $User.Gender

#if( $Description -eq "Temp"){
#$Suffix= "Contractors"
#}
#elseif($Description -eq "Associate"){
#$Suffix= "Users"
#}

#$OU1= "$OU $Suffix"

New-RemoteMailbox -Name($LastNm+", "+$FirstNm) -LastName $LastNm -FirstName $FirstNm
-OnPremisesOrganizationalUnit "bsg.ad.adp.com/BGLR/BGLR Users"
-UserPrincipalName "$UPN"
-SamAccountName $SamAccountNm
-Password $Passwd
#-UserPrincipalName ($FirstNm.$LastNm+'@broadridge.com') 
#-Path "OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" -Office $Office
#-Password $Credentials.Password 
-ResetPasswordOnNextLogon:$true -EmployeeNumber $EmpID -Description $Description

Write-host "$LastNm, $FirstNm account created."


#Set-ADAccountExpiration -Identity $SamAccountName -DateTime $ExpDate

}
