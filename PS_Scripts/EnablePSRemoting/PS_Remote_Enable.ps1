ForEach ($computer in (Get-Content Computer.txt))
{if(!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
 
{Write-output "Can't Reach $computer" | Out-File PSRemoting_Can_not_Reach.txt -append}
 
 
else {
 

	
		Write-Host "Enabling WinRM on" $computer "..." -ForegroundColor cyan
         C:\Windows\System32\psexec.exe \\$computer -s powershell enable-PSRemoting -Force
		if ($LastExitCode -eq 0) {
         C:\Windows\System32\psexec.exe \\$computer restart WinRM
			
            $result = winrm id -r:$computer 2>$null			
			if ($LastExitCode -eq 0) {Write-Host 'WinRM successfully enabled!' -ForegroundColor green}
			else {Write-output "WinRM failed to be enabled on $computer" | Out-File PsRemoting_Fails.txt -append}
}
}
}