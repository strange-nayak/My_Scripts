Get-Content Emails.txt | ForEach-Object { 
  Get-ADUser -Filter {EmailAddress -eq $_} -Properties DistinguishedName,Name,SamAccountName,DisplayName,EmailAddress,LastLogonDate | Select-Object DistinguishedName,Name,SamAccountName,DisplayName,EmailAddress,LastLogonDate | Export-CSV HBADusers-data.csv -Append 
}