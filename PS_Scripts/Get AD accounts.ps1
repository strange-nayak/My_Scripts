Get-ADUser -Filter * -SearchBase "OU=HBAD Users,OU=HBAD,DC=bsg,DC=ad,DC=adp,DC=com" -Properties CanonicalName, name, sAMAccountName, mail, bfsResourceType, employeeID, employeeNumber, Created, Enabled, LastLogonDate, PasswordLastSet, Description, AccountExpirationDate | Select-Object CanonicalName, name, sAMAccountName, mail, bfsResourceType, employeeID, employeeNumber, Created, Enabled, LastLogonDate, PasswordLastSet, Description, AccountExpirationDate  | export-csv -path c:\temp\HBAD-userexport.csv

#-Filter {Enabled -eq $true}
#OU=HBAD Users,OU=HBAD,DC=bsg,DC=ad,DC=adp,DC=com
#OU=NWRK Contractors,OU=NWRK,DC=bsg,DC=ad,DC=adp,DC=com
#OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com