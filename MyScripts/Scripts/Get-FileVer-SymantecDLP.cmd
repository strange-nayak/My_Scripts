SET COMP=%1
SET LoggedIn=No
SET LOGGEDINUSER=
SET FILE1=\\%comp%\C$\Program Files\Manufacturer\Endpoint Agent\edpa.exe
SET TargetVersion=12.5.3000.1016
SET TargetLog=Symantec-DLP-12.5.3-1.0-Install.log
@ECHO Machine,Accessible?,File Version,Issue,To Try>%ResultsFolder%\Header.txt

ping %comp% -n 3 >%comp%.txt
findstr /I /C:"Destination" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,Destination unknown >%ResultsFolder%\%1.txt & Del %1.txt & exit
findstr /I /M /C:"TTL expired in transit" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,TTL expired in transit>%ResultsFolder%\%1.txt & Del %1.txt & exit
::Want to do Reply before request timed out in case we get a request timed out also.
findstr /I /M "Reply" %1.txt
@IF %ERRORLEVEL%==0 Del %1.txt & GOTO :Continue
findstr /I /M /C:"Request timed out" %1.txt
@IF %ERRORLEVEL%==0 @ECHO %1,Request Timed Out >%ResultsFolder%\%1.txt & Del %1.txt & exit
@ECHO %1 ,Unknown result >%ResultsFolder%\%1.txt & Del %1.txt & exit

:Continue
@Echo Checking access...
@if exist \\%comp%\c$ (
	SET Accessible=Accessibile
	@GOTO :StartIt
)
IF "%UserO%" NEQ "" IF "%PasswordO%" NEQ "" ( 
	@ECHO Mapping with %UserO%
	net use \\%comp%\c$ /u:%UserO% %PasswordO%
	@if exist \\%comp%\c$ (
		SET Accessible=AlternateCreds
		@GOTO :StartIt
	)
)
@Goto :NoAccess

:StartIt
SET OUTPUT=%COMP%,Accessible


@SET File_Version=Not Found

SET FILE2=%FILE1: (x86)=%
if exist "%FILE1%" (
	for /F "tokens=5" %%a in ('filever "%FILE1%"') do set File_Version=%%a
) Else (
	if exist "%FILE2%" (
		for /F "tokens=5" %%a in ('filever "%FILE2%"') do set File_Version=%%a
	)
)
IF "%File_Version%"=="%TargetVersion%" Goto :SetIt
@SET RealVersion=%File_Version%
@SET File_Version=Not Found
if not exist \\%comp%\C$\Windows\BFS\Logs\%TargetLog% @SET File_Version=%RealVersion%,No install log & Goto :SetIt
robocopy \\%comp%\C$\Windows\BFS\Logs %COMP% %TargetLog%
for /F "tokens=2 delims=:" %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"The machine needs to be rebooted before install can proceed"') DO Set File_Version=%RealVersion%,The machine needs to be rebooted before install can proceed,Reboot and retry
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F "tokens=2 delims=:" %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"The older version of AgentInstall cannot be removed"') DO Set File_Version=%RealVersion%,Older version cannot be removed.,Symantec DLP Agent\DLP Wipe. Then Manual Clean Wipe
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F "tokens=2 delims=:" %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"The older version of AgentInstall64 cannot be removed"') DO Set File_Version=%RealVersion%,Older version cannot be removed.,Symantec DLP Agent\DLP Wipe, then Manual Clean Wipe
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F "tokens=2 delims=:" %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"UninstallDriverPackages failed with error 0x2"') DO Set File_Version=%RealVersion%,UninstallDriverPackages failed with error 0x2.,Symantec DLP Agent\DLP Wipe, then Manual Clean Wipe
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"upgradeDatabasesToCurrent() failed. -- result: Access is denied"') DO Set File_Version=%RealVersion%,upgradeDatabasesToCurrent(),Try rd \\%comp%\c$\Program Files\Manufacturer
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F "tokens=2 delims=:" %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"Error 1402.Could not open key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"') DO Set File_Version=%RealVersion%,Verify that you have sufficient access to that key,Symantec DLP Agent\DLP Wip.e Then Manual Clean Wipe
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F %%a in ('type %comp%\%TargetLog%^|findstr /I /C:"There is not enough space on the disk."') DO Set File_Version=%RealVersion%,There is not enough space on the disk.,Clear sufficient disk space
IF "%File_Version%" NEQ "Not Found" Goto :SetIt


@SET File_Version=%RealVersion%
IF /I "%Pause%"=="TRUE" Pause
rd %comp% /s /q

:SetIt
SET OUTPUT=%Output%,%File_Version%

:LogIt
ECHO %OUTPUT%,>%ResultsFolder%\%COMP%.txt
IF /I "%Pause%"=="TRUE" Pause
@GOTO :END

:CHECKUSER
SET LOGGEDINUSER=%1_%2
IF "%LOGGEDINUSER%"=="Connecting_to" GOTO :EOF
SET LOGGEDINUSER=%LOGGEDINUSER: =%
@GOTO :EOF


:NoAccess
ECHO %COMP%,NoAccess>%ResultsFolder%\%COMP%.txt
@GOTO :END

:ExtractInfo
If /I "%1"=="Uptime:" SET Uptime=%2 %3 %4 %5 %6 %7 %8 %9
If /I "%1 %2"=="Kernel version:" SET REMOTE_OS=%3 %4 %5 %6 %7 %8 %9
If /I "%1 %2"=="Service pack:" SET SP=%3 %4 %5 %6 %7 %8 %9
@goto :EOF


:END
net use \\%comp%\c$ /d<y.txt
DEL %comp%.txt
::EXIT
