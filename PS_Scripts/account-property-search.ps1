import-module ActiveDirectory

$Users=Import-Csv  -Path "C:\Users\nayaks\Desktop\SEP\Local Checks\Mails\Names.csv"



$data=foreach($user in $users)
{

$ResultUser= Get-ADUser -Identity $user.ID  -Properties  * 

New-Object psobject -Property @{

Email=$ResultUser.EmailAddress
GivenName=$ResultUser.GivenName
SamAccountName=$ResultUser.SamAccountName
}





}

$data | Select-Object -Property GivenName,Email,SamAccountName | Export-csv "C:\Users\nayaks\Desktop\SEP\Local Checks\Mails\Result1.csv"
