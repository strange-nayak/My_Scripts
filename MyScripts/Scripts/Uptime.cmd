SET COMP=%1
SET OUTPUT=%COMP%

ping %comp% -n 3 >%comp%.txt
findstr /I /C:"Destination" /C:"Ping request could not find host" /C:"Bad IP address" /C:"Unknown host" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,Destination unknown >%ResultsBadFolder%\%1.txt & Del %1.txt & exit
findstr /I /M /C:"TTL expired in transit" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,TTL expired in transit>%ResultsBadFolder%\%1.txt & Del %1.txt & exit
::Want to do Reply before request timed out in case we get a request timed out also.
findstr /I /M "Reply" %1.txt
IF %ERRORLEVEL%==0 Del %1.txt & GOTO :Continue
findstr /I /M /C:"Request timed out" %1.txt
IF %ERRORLEVEL%==0 @ECHO %1,Request Timed Out >%ResultsBadFolder%\%1.txt & Del %1.txt & exit
@ECHO %1 ,Unknown result >%ResultsBadFolder%\%1.txt & Del %1.txt & exit

:Continue
@if not exist \\%comp%\c$ @Goto :NoAccess

:StartIt
path
for /F "tokens=*" %%a in ('uptime.exe \\%COMP%') do set UT=%%a
SET OUTPUT=%OUTPUT%,%UT%
@GOTO :END

:NoAccess
ECHO %COMP% NoAccess>NoAccess%File%\%COMP%.txt
@GOTO :END


:END
ECHO %OUTPUT% 1>>%ResultsFolder%\%COMP%.txt
::@EXIT
