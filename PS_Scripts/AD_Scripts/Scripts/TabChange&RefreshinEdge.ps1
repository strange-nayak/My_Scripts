while(1 -eq 1){
$wshell=New-Object -ComObject wscript.shell;
$wshell.AppActivate('Microsoft Edge'); # Activate on Edge browser
Sleep 20; # Interval (in seconds) between switch 
$wshell.SendKeys('^{Tab}'); # Ctrl + Page Up keyboard shortcut to switch tab
Sleep 1; # Interval (in seconds) between switch 
$wshell.SendKeys('{F5}'); # F5 to refresh active page
}