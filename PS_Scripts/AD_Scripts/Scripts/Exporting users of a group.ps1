Write-host "Enter Group Name:"
$Group= Read-Host
$Results= Get-ADGroupMember -Identity "$Group"
$Results | select Name, employeeNumber, mail,physicalDeliveryOfficeName | Export-Csv "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\$Group.csv"