#Requires -RunAsAdministrator

$computerList = Get-Content PCs.txt
$logFile = Export-Csv C:\Nayak_testlab\Lenoo_BIOS_Scripts\Withlog\logs.csv

foreach($computer in $computerList){
(gwmi -class Lenovo_SetBiosSetting -namespace root\wmi).SetBiosSetting("IntegratedCameraAccess,Enable,Tq81bN50,ascii,us")
(gwmi -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings(“Tq81bN50,ascii,us”)
gwmi -class Lenovo_BiosSetting -namespace root\wmi | ForEach-Object {if ($_.CurrentSetting -ne "") {Write-Host $_.CurrentSetting.replace(","," = ")}}
}