#$PSCredential = Get-Credential "ComputerName\UserName"
$PSCredential = Get-Credential "BSG\Nayakadmin"
 
Get-WmiObject Win32_OperatingSystem -ComputerName "bglrmediasrv01" -Credential $PSCredential |
Select PSComputerName, Caption, OSArchitecture, Version, BuildNumber | FL

#To get remote server patch update details
Get-HotFix -ComputerName bglrmediasrv01 | Sort-Object InstalledOn -Descending | Select-Object -First 1