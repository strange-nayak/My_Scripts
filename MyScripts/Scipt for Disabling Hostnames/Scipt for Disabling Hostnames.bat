@echo off 
CLS
ECHO Now Disabling Machines...
TIMEOUT 2 > nul
Pause
FOR /f %%i in (computernames.txt) do ( dsquery computer -name %%i | dsmod computer -disabled Yes )

pause