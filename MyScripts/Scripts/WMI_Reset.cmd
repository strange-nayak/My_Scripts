@SET COMP=%1

ping %comp% -n 3 >%comp%.txt
@findstr /I /C:"Destination" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,Destination unknown >%ResultsFolder%\%1.txt & Del %1.txt & exit
@findstr /I /M /C:"TTL expired in transit" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,TTL expired in transit>%ResultsFolder%\%1.txt & Del %1.txt & exit
::Want to do Reply before request timed out in case we get a request timed out also.
@findstr /I /M "Reply" %1.txt
@IF %ERRORLEVEL%==0 Del %1.txt & GOTO :Continue
@findstr /I /M /C:"Request timed out" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,Request Timed Out >%ResultsFolder%\%1.txt & Del %1.txt & exit
@ECHO %1 ,Unknown result >%ResultsFolder%\%1.txt & Del %1.txt & exit


:Continue
IF NOT EXIST %ResultsFolder%_WMIRESULTS MD %ResultsFolder%_WMIRESULTS
@Echo Checking access...
@if exist \\%comp%\c$ @GOTO :StartIt

IF "%UserO%" NEQ "" IF "%PasswordO%" NEQ "" ( 
	@ECHO Mapping with %UserO%
	net use \\%comp%\c$ /u:%UserO% %PasswordO%
	@if exist \\%comp%\c$ @GOTO :StartIt
)

@Goto :NoAccess


:StartIt
robocopy WMI_Reset "\\%comp%\c$\temp\WMI_Reset" /e
pskill \\%comp% PSEXESVC
psexec \\%comp% -w c:\temp\WMI_Reset c:\temp\WMI_Reset\WMI_Reset.cmd
copy "\\%comp%\c$\temp\WMI_Reset\WMI_Reset_%COMP%.log" "%ResultsFolder%_WMIRESULTS" /y
@ECHO %1,%Errorlevel%,>%ResultsFolder%\%1.txt

Goto :LogIt

:LogIt
If /I "%Pause%"=="True" @Pause
@GOTO :END

:NoAccess
SET NAME=CANT RESOLVE NAME
for /F "tokens=1,2,3" %%a in ('ping -a %COMP%') do @if /I "%%a"=="Pinging" SET NAME=%%b & SET IP=%%c
SET NAME=%NAME: =%
SET IP=%IP:[=%
SET IP=%IP:]=%
for /F "tokens=1,2,3" %%a in ('ping -a %IP%') do @if /I "%%a"=="Pinging" SET NAMEOFIP=%%b
ECHO %COMP%,NoAccess,Ping-A=%NAME%,IP=%IP%,ReverseIPPing=%NAMEOFIP%>%ResultsBadFolder%\%COMP%.txt
@GOTO :END


:END
net use \\%comp%\c$ /d<y.txt
DEL %comp%.txt
EXIT
