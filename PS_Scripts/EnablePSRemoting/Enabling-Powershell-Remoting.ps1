# Enables Powershell Remoting
$computer = Get-Content Computer.txt
#Param ([Parameter(Mandatory=$true)]
#[System.String[]]$Computer)
ForEach ($comp in $computer ) {
    Start-Process -Filepath "C:\Windows\System32\psexec.exe" -Argumentlist "\\$comp -h -d winrm.cmd quickconfig -q"
	Write-Host "Enabling WINRM Quickconfig" -ForegroundColor Green
	Write-Host "Waiting for 05 Seconds......." -ForegroundColor Yellow
	Start-Sleep -Seconds 05 -Verbose	
    Start-Process -Filepath "C:\Windows\System32\psexec.exe" -Argumentlist "\\$comp -h -d powershell.exe enable-psremoting -force"
	Write-Host "Enabling PSRemoting" -ForegroundColor Green
    Start-Process -Filepath "C:\Windows\System32\psexec.exe" -Argumentlist "\\$comp -h -d powershell.exe set-executionpolicy RemoteSigned -force"
	Write-Host "Enabling Execution Policy" -ForegroundColor Green	
    Test-Wsman -ComputerName $comp
}