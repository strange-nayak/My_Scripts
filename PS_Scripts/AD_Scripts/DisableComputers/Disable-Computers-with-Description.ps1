$TimeStamp = ((get-date).toshortdatestring())
$pclist = Get-Content "C:\Nayak_testlab\PS_Scripts\AD_Scripts\DisableComputers\Hostnames.txt"
Foreach($pc in $Pclist)
{
$Comp = Get-ADComputer -Identity $pc -Properties description 
$Comp | Set-ADComputer -Enabled $false -Description "Disabled due to Inactivity for more than 365 days- $timestamp"
}