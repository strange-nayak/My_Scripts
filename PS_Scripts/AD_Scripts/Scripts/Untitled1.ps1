﻿Get-ADGroupMember -Identity "BNR-Associates" | Get-ADUser -Property DisplayName | Select-Object DisplayName | Sort-Object DisplayName | Export-Csv C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\BNR-Associates.csv