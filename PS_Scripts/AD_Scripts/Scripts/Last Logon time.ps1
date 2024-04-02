Import-module ActiveDirectory
$Lastlogontime= Get-ADuser -Identity nayaks -Server bsg.ad.adp.com -Properties * | Select-Object Lastlogontimestamp, enabled, passwordneverexpires
#$Lastlogon= $Lastlogontime.Lastlogontimestamp
[datetime]::FromFileTime("$Lastlogontime")
