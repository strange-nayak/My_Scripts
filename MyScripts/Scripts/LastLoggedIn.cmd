SET COMP=%1
SET LoggedIn=No
SET LOGGEDINUSER=

@ECHO Machine,LastLoggedInUser,Date>%ResultsFolder%\Header.txt
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
SET Last5=
SET Last4=
SET Last3=
SET Last2=
SET Last1=
for /F "skip=4 tokens=1,2,5" %%a in ('dir \\%comp%\c$\users\* /od') do CAll :CheckIt %%c %%a
IF "%Last5%" NEQ "" @ECHO %COMP%,%Last5%>>%ResultsFolder%\%COMP%.txt
IF "%Last4%" NEQ "" @ECHO %COMP%,%Last4%>>%ResultsFolder%\%COMP%.txt
IF "%Last3%" NEQ "" @ECHO %COMP%,%Last3%>>%ResultsFolder%\%COMP%.txt
IF "%Last2%" NEQ "" @ECHO %COMP%,%Last2%>>%ResultsFolder%\%COMP%.txt
IF "%Last1%" NEQ "" @ECHO %COMP%,%Last1%>>%ResultsFolder%\%COMP%.txt

::for /D %%a in (\\%comp%\c$\users\*) do CAll :CheckIt %%~na %%~ta

@GOTO :EOF

:CHeckIt
IF "%1"=="" GOTO :EOF
IF "%2"=="" GOTO :EOF
@IF "%1"=="ADMINI~1" GOTO :EOF
@IF "%1"=="Public" GOTO :EOF
@IF "%1"=="." GOTO :EOF
@IF "%1"==".." GOTO :EOF
IF "%1"=="free" GOTO :EOF
@IF "%1"=="Administrator" GOTO :EOF
@IF "%1"=="bluestaruser_ide" GOTO :EOF
SET Last5=%Last4%
SET Last4=%Last3%
SET Last3=%Last2%
SET Last2=%Last1%
SET Last1=%1,%2

@Goto :EOF


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
