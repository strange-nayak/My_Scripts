Import-Module ActiveDirectory
$Users= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List2.csv"
foreach($User in $Users)
{
if($Gender -eq "Female"){

Add-ADGroupMember -Identity "Group Advika (BLR)"  -Members $SamAccountName

Write-Host "Added to Group Advika (BLR)"

}

Add-ADGroupMember -Identity "BR-ISE-DUO-EMP"  -Members $SamAccountName

Write-Host "VPN access provided"

Add-ADGroupMember -Identity "BR-Office365FullUserLicenseGroup"  -Members $SamAccountName

Write-Host "O365 License Assigned"

Add-ADGroupMember -Identity "Domain users BLR"  -Members $SamAccountName

Write-Host "Added Domain users BLR"

}