SET COMP=%1

Set Output=%COMP%

ping %COMP% -n 2 >%COMP%.txt
for /F "tokens=2 delims=[]" %%c in (%COMP%.txt) DO SET IP=%%c
SET ReportIP=%IP%
IF "%ReportIP%"=="" SET ReportIP=UnKnown & SET IP=%COMP%

SET REPORT
SET IP

Set Output=%COMP%,%ReportIP%
@set header=Machine,IP Address,Ping Response,Ping Time,ping -a resolution

findstr /I /C:"Destination" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue1
@SET OUTPUT=%OUTPUT%,Destination unknown
@Goto :End

:Continue1
findstr /I /M /C:"TTL expired in transit" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue2
@SET OUTPUT=%OUTPUT%,TTL expired in transit
@Goto :End

:Continue2
::Want to do Reply before request timed out in case we get a request timed out also.
findstr /I /M "Reply" %COMP%.txt
IF %ERRORLEVEL%==0 Goto :GetInfo


findstr /I /M /C:"Request timed out" %COMP%.txt
IF %ERRORLEVEL% NEQ 0 GOTO :Continue3
@SET OUTPUT=%OUTPUT%,Request Timed Out
@Goto :End

:Continue3
@SET OUTPUT=%OUTPUT%,Unknown Ping Response
@Goto :End



:GetInfo


for /F "tokens=9" %%a in ('findstr /I "average" %COMP%.txt') do SET Average=%%a
::now reverse ping the IP and get the machine name
for /F "tokens=1,2" %%c in ('ping -a %IP% -n 1') do @IF /I "%%c"=="Pinging" SET MACHINENAME=%%d
@SET OUTPUT=%OUTPUT%,Reply,%Average%,%MACHINENAME%

:End
@ECHO %header%>%ResultsFolder%\Header.txt
ECHO %OUTPUT%>>%ResultsFolder%\%COMP%.txt
IF /I "%Pause%"=="TRUE" Pause
IF Exist %COMP%.txt del %COMP%.txt
