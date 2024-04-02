Import-Module ActiveDirectory
$Users= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List.csv"
foreach($User in $Users)
{
$User
$Surname= $User.Surname
$GivenName= $User.GivenName
$SamAccountName= $User.SamAccountName
$Passwd= "Welcome1"
$Description= $User.Description
$BU = $User.BU
$Office= "Bangalore"
$OU= "BGLR"
$OU1= "BGLR Users"
$Gender= $User.Gender

if( $Description -eq "Temp"){
$Suffix= "(CA)"
}
elseif($Description -eq "Associate"){
$Suffix= ""
}

New-ADuser -Name($Surname+", "+$GivenName) -DisplayName($Surname+", "+$GivenName +$Suffix) -Surname $Surname -GivenName $GivenName `
-Path "OU=$OU1,OU=$OU,DC=bsg,DC=ad,DC=adp,DC=com" -AccountPassword(ConvertTo-SecureString $Passwd -AsPlainText -force) -ChangePasswordAtLogon $true `
-Enabled $true -SamAccountName $SamAccountName -UserPrincipalName($GivenName+"."+$Surname+"@broadridge.com")`
-Office $Office -Description $Description

Write-host "$Surname, $Givenname account created."

if($BU -eq "BR BPO"){
Add-ADGroupMember -Identity "Ridge Clearing External Email (HYD)"  -Members $SamAccountName
}

Add-ADGroupMember -Identity "Domain users BLR" -Members $SamAccountName

if($Gender -eq "Female"){
if($Description -eq "Associate"){
Add-ADGroupMember -Identity "Group Advika (BLR)" -Members $SamAccountName
}
}

}