#Extracting members from one group and adding it to other
Import-module Activedirectory
$List = get-adgroupmember "Access Data All Users in Gdansk" -Server bsg.ad.adp.com

foreach($user in $List.SamAccountName)
{
Add-ADGroupMember -Identity "Data Support Portal Users"  -Members $user 
}

