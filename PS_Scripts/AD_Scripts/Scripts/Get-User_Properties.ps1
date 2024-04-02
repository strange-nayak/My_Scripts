import-module ActiveDirectory

$Users=Import-Csv  -Path "C:\temp\User_List.csv"



$data=foreach($user in $users)
{

$ResultUser= Get-ADUser -Identity $user.SamAccount -Properties  * 

New-Object psobject -Property @{

Email=$ResultUser.EmailAddress
GivenName=$ResultUser.Name
SamAccountName=$ResultUser.SamAccountName
LastPWDChange=$ResultUser.passwordlastset
LastLogon=$ResultUser.Lastlogontimestamp
Active_Status=$ResultUser.enabled
PWDExpiry=$ResultUser.passwordneverexpires
WhenCreated=$ResultUser.whenCreated
}
}

$data | Select-Object -Property GivenName,Email,SamAccountName,LastPWDChange,WhenCreated, @{N='LastLogon' ; E={[DateTime]::FromFileTime($_.LastLogon)}},Active_Status,PWDExpiry | Export-csv "C:\temp\UserDetails.csv"
