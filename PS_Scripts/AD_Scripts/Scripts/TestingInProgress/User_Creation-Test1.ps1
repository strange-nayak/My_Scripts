$CSVLocation = "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\User_List3.csv"
Import-CSV $CSVLocation | ForEach-Object {
New-RemoteMailbox -Name $_.Name -FirstName $_.FirstName  -Lastname $_.LastName -OnPremisesOrganizationalUnit $_.OU -UserPrincipalName $_.UPN -Password (ConvertTo-SecureString $_.password -AsPlainText -Force) -ResetPasswordOnNextLogon:$true }