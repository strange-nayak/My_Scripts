### Modified on 20-NOV-2018 ###
 
### Powershell Script to Update UPN like Emailaddress for list of Email ID’s -- V1 ####
 
## Syntax to check for User account , Exclude *admin* accounts ##
Import-module ac*
$CurrentDate = @()
$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$userUPNUPDATE = @()
$userinfo = @()
$userinfo = ""

$userinfo = Get-Content C:\**\Email.txt | ForEach {
 
Get-ADUser -server bsg.ad.adp.com:3268 -Filter "mail -eq '$_'" -Property SamAccountName,EmailAddress, UserPrincipalName,distinguishedname,CanonicalName | where {$_.SamAccountName -notmatch 'admin'}| Select @{N='UserDomain';E={$_.CanonicalName.Split('/')[0]}},SamAccountName,EmailAddress, UserPrincipalName,distinguishedname
}

 
## Syntax to update UPN , output to Variable ##
 
$userinfo | Export-csv "C:\temp\Useraccounts-$CurrentDate.csv" -NoTypeInformation

 $Sno=1
$userUPNUPDATE = foreach ($user in $userinfo)
{
 Write-host $SNo " the user is " $user.EmailAddress 
 Set-ADUser -Identity $($user.SamAccountName) -Server $($user.UserDomain) -UserPrincipalName $($user.EmailAddress)
 $Sno= $sno + 1
}

Start-Sleep -Seconds 5

$userUPNUPDATEList = foreach ($user in $userinfo)
{
$sam = $user.SamAccountName
Get-ADUser -server bsg.ad.adp.com:3268 -Filter {SamAccountName -eq $sam} -Property Givenname,Surname ,displayname,SamAccountName,EmailAddress,UserPrincipalName,distinguishedname,CanonicalName | select  @{N='UserDomain';E={$_.CanonicalName.Split('/')[0]}} ,Givenname,Surname ,displayname, SamAccountName ,EmailAddress, UserPrincipalName,distinguishedname
}
 
$userUPNUPDATEList| Export-csv "C:\temp\Useraccounts-UPNupdated-$CurrentDate.csv" -NoTypeInformation 
