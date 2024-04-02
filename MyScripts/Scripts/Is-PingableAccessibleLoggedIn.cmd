PROMPT $T^>
SET COMP=%1

Set Output=%COMP%

ping %COMP% -n 2 >%COMP%.txt
for /F "tokens=2 delims=[]" %%c in (%COMP%.txt) DO SET IP=%%c
SET ReportIP=%IP%
IF "%ReportIP%"=="" SET ReportIP=UnKnown & SET IP=%COMP%

SET REPORT
SET IP

Set Output=%COMP%,%ReportIP%
@set header=Machine,IP Address,Ping Response,Ping Time,ping -a resolution,Accessible?,Uptime(Days:H:M),LoggedIn,LoggedInUser,ScreenSaver,LogonUI

findstr /I /C:"Destination unknown" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue1
@SET OUTPUT=%OUTPUT%,Destination unknown
@Goto :End

:Continue1
findstr /I /M /C:"TTL expired in transit" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue2
@SET OUTPUT=%OUTPUT%,TTL expired in transit
@Goto :End

:Continue2
findstr /I /M /C:"Destination host unreachable" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue21
@SET OUTPUT=%OUTPUT%,Destination host unreachable
@Goto :End

:Continue21
findstr /I /M /C:"Destination net unreachable" %COMP%.txt
IF %ERRORLEVEL% NEQ 0  Goto :Continue3
@SET OUTPUT=%OUTPUT%,Net unreachable
@Goto :End


:Continue3
::Want to do Reply before request timed out in case we get a request timed out also.
::findstr /I /M "Reply" %COMP%.txt
findstr /I "Reply" %COMP%.txt|findstr /I "bytes="
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

::See if accessible
@SET Accessible=NoAccess
@Echo Checking access...
@if exist \\%comp%\c$ (
	SET Accessible=Accessibile
	@GOTO :LogAccessible
)
IF "%UserO%" NEQ "" IF "%PasswordO%" NEQ "" ( 
	@ECHO Mapping with %UserO%
	net use \\%comp%\c$ /u:%UserO% %PasswordO%
	@if exist \\%comp%\c$ (
		SET Accessible=AlternateCreds
		@GOTO :LogAccessible
	)
)
@SET OUTPUT=%OUTPUT%,%Accessible%
goto :end

:LogAccessible
SET OUTPUT=%OUTPUT%,%Accessible%
for /F "tokens=6,8,10 delims=:, " %%a in ('uptime \\%comp%') DO  set UT=%%a:%%b:%%c
set UT
IF /I "%UT:~0,2%"=="To" SET UT=
IF /I "%UT:~0,3%"=="See" SET UT=
IF /I "%UT:~0,6%"=="detail" SET UT=
SET OUTPUT=%OUTPUT%,%UT%

:See if loggedIn
SET LoggedIn=Yes

pslist \\%comp%>%comp%.txt

findstr /I "explorer" %comp%.txt
if "%ERRORLEVEL%"=="1" (
	SET LoggedIn=No
)

SET SCREENSAVER=
SET SSTIME=
findstr /I /C:".scr" %comp%.txt
if "%ERRORLEVEL%"=="0" (
	for /F "tokens=8" %%a in ('findstr /I /C:".scr" %comp%.txt') DO SET SSTIME=%%a
	SET SCREENSAVER=ScreenSaver Running
) ELSE (
	SET SCREENSAVER=No ScreenSaver
)
IF "%SSTIME%" NEQ "" SET SCREENSAVER=%SCREENSAVER% [%SSTIME%]
SET SCREENSAVER

SET LogonUI=
SET SSTIME=
findstr /I "LogonUI" %comp%.txt
if "%ERRORLEVEL%"=="0" (
	for /F "tokens=8" %%a in ('findstr /I "LogonUI" %comp%.txt') DO SET SSTIME=%%a
	SET LogonUI=LogonUI Running 
) ELSE (
	SET LogonUI=No LogonUI
)
IF "%SSTIME%" NEQ "" SET LogonUI=%LogonUI% [%SSTIME%] Could be rdp session!

SET LOGGEDINUSER=
for /F "tokens=1,2 delims=\ " %%a in ('psloggedon -l -x \\%comp%') DO IF "%%a" NEQ "NT" IF /I "%%b" NEQ "NBE1WWW" CALL :CHECKUSER %%a %%b 
@SET OUTPUT=%OUTPUT%,%LoggedIn%,%LOGGEDINUSER%,%ScreenSaver%,%LogonUI%>%ResultsFolder%\%COMP%.txt
goto :end

:CHECKUSER
SET LOGGEDINUSER=%1_%2
IF "%LOGGEDINUSER%"=="Connecting_to" SET LOGGEDINUSER= & GOTO :EOF
SET LOGGEDINUSER=%LOGGEDINUSER: =%
@GOTO :EOF



:End
net use \\%comp%\c$ /d<y.txt
@ECHO %header%>%ResultsFolder%\Header.txt
IF Exist %COMP%.txt del %COMP%.txt
ECHO %OUTPUT%>>%ResultsFolder%\%COMP%.txt
IF /I "%Pause%"=="TRUE" Pause
