﻿Get-ADGroupMember -identity “BR-CognosAccess” | select name | Export-csv -path C:\Nayak_testlab\Get-ADGroupMembers\Groupmembers-BR-CognosAccess.csv -NoTypeInformation