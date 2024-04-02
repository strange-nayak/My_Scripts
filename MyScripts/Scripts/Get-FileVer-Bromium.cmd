SET COMP=%1
SET LoggedIn=No
SET LOGGEDINUSER=

@ECHO Machine,Accessible?,File Version/Issue,>%ResultsFolder%\Header.txt

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
SET FILE1=\\%comp%\C$\Program Files\Bromium\vSentry\servers\BrConsole.exe
SET FILE2=%FILE1: (x86)=%
if exist "%FILE1%" (
	for /F "tokens=5" %%a in ('filever "%FILE1%"') do set File_Version=%%a
) Else (
	if exist "%FILE2%" (
		for /F "tokens=5" %%a in ('filever "%FILE2%"') do set File_Version=%%a
	)
)

IF "%File_Version%" NEQ "Not Found" Goto :SetIt
if not exist \\%comp%\C$\Windows\Temp\vsentry.log Goto :SetIt
robocopy \\%comp%\C$\Windows\Temp %COMP% vsentry.log
for /F "tokens=2 delims=:" %%a in ('type %comp%\vsentry.log^|findstr /I /C:"Requirements not met"') DO Set File_Version=%%a
IF "%File_Version%" NEQ "Not Found" Goto :SetIt
for /F %%a in ('type %comp%\vsentry.log^|findstr /I /C:"CustomAction CheckPendingReboot returned actual error code 1602"') DO Set File_Version=%%a
IF "%File_Version%" NEQ "Not Found" SET File_Version=Reboot Needed Before Installing!
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