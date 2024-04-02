Write-host "Enter Group Name:"
$Group= Read-Host
Get-ADGroupMember -Identity "$Group" -Server BGIPVWWDCA01.bsg.ad.adp.com -Recursive | 
    Select-Object -Unique |
    Get-ADUser -Properties Mail, employeeNumber, title |
    Select-Object Name, Mail, employeeNumber, title |
    Export-Csv "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\$Group.csv" -NoTypeInformation