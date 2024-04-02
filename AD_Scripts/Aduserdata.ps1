Import-Csv C:\Nayak_testlab\AD_Scripts\AD_Users.csv | ForEach {
Get-ADUser -Identity $_.SamAccountName -properties givenname,surname,employeenumber,samaccountname,displayname,userPrincipalName,distinguishedName,EmailAddress | `
select givenname,surname,employeenumber,samaccountname,displayname,userPrincipalName,distinguishedName,EmailAddress | `
Export-CSV C:\Nayak_testlab\AD_Scripts\output.csv -Force -notype -encoding UTF8 -Append
}