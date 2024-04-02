Import-Module ActiveDirectory
$Users= Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Hire_List.csv"
foreach($User in $Users)
{
$User
$Surname= $User.Surname
$GivenName= $User.GivenName
$SamAccountName= $User.SamAccountName
$EmpID= $User.EmpID
$Passwd= $User.Password
$ExpDate= $User.ExpDate
$Office= $User.Office
$Description= $User.Description
$OU= $User.OU
$VPN= $User.VPN

if( $Description -eq "Temp"){
$Suffix= "Contractors"
}
elseif($Description -eq "Associate"){
$Suffix= "Users"
}

$OU1= "$OU $Suffix"

New-ADuser -Name($Surname+", "+$GivenName) -DisplayName($Surname+", "+$GivenName) -Surname $Surname -GivenName $GivenName `
-Path "OU=$OU1,OU=$OU,DC=bsg,DC=ad,DC=adp,DC=com" -AccountPassword(ConvertTo-SecureString $Passwd -AsPlainText -force) -ChangePasswordAtLogon $true `
-Enabled $true -EmployeeNumber $EmpID -SamAccountName $SamAccountName -UserPrincipalName($SamAccountName+"@bsg.ad.adp.com")`
-Office $Office -Description $Description

Write-host "$Surname, $Givenname account created."

if( $Description -eq "Temp"){

Set-ADAccountExpiration -Identity $SamAccountName -DateTime $ExpDate

}

if($VPN -eq "Yes"){

Add-ADGroupMember -Identity "BR-ISE-VPN-GLOBAL"  -Members $SamAccountName

Write-Host "VPN access provided"
}

}