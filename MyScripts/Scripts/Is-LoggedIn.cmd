SET COMP=%1
SET LoggedIn=No
SET LOGGEDINUSER=

@ECHO Machine,LoggedIn,LoggedInUser,ScreenSaver,LogonUI>%ResultsFolder%\Header.txt

ping %comp% -n 3 >%comp%.txt
findstr /I /C:"Destination" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,Destination unknown >%ResultsFolder%\%1.txt & Del %1.txt & exit
findstr /I /M /C:"TTL expired in transit" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,TTL expired in transit>%ResultsFolder%\%1.txt & Del %1.txt & exit
::Want to do Reply before request timed out in case we get a request timed out also.
findstr /I /M "Reply" %1.txt
IF %ERRORLEVEL%==0 Del %1.txt & GOTO :Continue
findstr /I /M /C:"Request timed out" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,Request Timed Out >%ResultsFolder%\%1.txt & Del %1.txt & exit
@ECHO %1,Unknown result, >%ResultsFolder%\%1.txt & Del %1.txt & exit

:Continue
@Echo Checking access...
@if exist \\%comp%\c$ @GOTO :StartIt
Goto :NoAccess

:StartIt
pslist \\%comp%>%comp%.txt

findstr /I "explorer" %comp%.txt
if "%ERRORLEVEL%"=="1" (
	ECHO %COMP%,No>%ResultsFolder%\%COMP%.txt
	GOTO :END
)

SET SCREENSAVER=
findstr /I /C:".scr" %comp%.txt
for /F "tokens=8" %%a in ('findstr /I /C:".scr" %comp%.txt') DO SET SSTIME=%%a
if "%ERRORLEVEL%"=="1" (
	SET SCREENSAVER=No ScreenSaver
) Else (
	SET SCREENSAVER=ScreenSaver Running %SSTIME%
)

SET LogonUI=
findstr /I "LogonUI" %comp%.txt
for /F "tokens=8" %%a in ('findstr /I "LogonUI" %comp%.txt') DO SET SSTIME=%%a
if "%ERRORLEVEL%"=="1" (
	SET LogonUI=No LogonUI
) Else (
	SET LogonUI=LogonUI Running %SSTIME% [Could be rdp session - careful]
)


for /F "tokens=1,2 delims=\ " %%a in ('psloggedon -l -x \\%comp%') DO IF "%%a" NEQ "NT" IF /I "%%b" NEQ "NBE1WWW" CALL :CHECKUSER %%a %%b 
ECHO %COMP%,LoggedIn,%LOGGEDINUSER%,%ScreenSaver%,%LogonUI%>%ResultsFolder%\%COMP%.txt
IF /I "%Pause%"=="TRUE" Pause
del %COMP%.txt 
@GOTO :EOF

:CHECKUSER
SET LOGGEDINUSER=%1_%2
IF "%LOGGEDINUSER%"=="Connecting_to" GOTO :EOF
SET LOGGEDINUSER=%LOGGEDINUSER: =%
@GOTO :EOF

:NoAccess
SET NAME=CANT RESOLVE NAME
for /F "tokens=1,2,3" %%a in ('ping -a %COMP%') do @if /I "%%a"=="Pinging" SET NAME=%%b & SET IP=%%c
SET NAME=%NAME: =%
SET IP=%IP:[=%
SET IP=%IP:]=%
for /F "tokens=1,2,3" %%a in ('ping -a %IP%') do @if /I "%%a"=="Pinging" SET NAMEOFIP=%%b
ECHO %COMP%,NoAccess,Ping-A=%NAME%,IP=%IP%,ReverseIPPing=%NAMEOFIP%>%ResultsFolder%\%COMP%.txt
@GOTO :END


:END
DEL %comp%.txt
EXIT
