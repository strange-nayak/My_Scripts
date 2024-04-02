while(1) { # Loop forever
    sleep -Seconds 180 # Wait 5 minutes
    $wshell = New-Object -ComObject wscript.shell 
    if($wshell.AppActivate('Chrome')) { # Switch to Chrome
    Sleep 1 # Wait for Chrome to "activate"
    $wshell.SendKeys('{F5}')  # Send F5 (Refresh)
    } else { break; } # Chrome not open, exit the loop
}