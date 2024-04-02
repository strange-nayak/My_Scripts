$computerName = "10.104.248.67"
$yourAccount = Get-Credential
Invoke-Command -ComputerName $computerName -Credential $yourAccount -ScriptBlock {
    Get-WmiObject Win32_Product | Select Name, AppVendor, AppVersion
}