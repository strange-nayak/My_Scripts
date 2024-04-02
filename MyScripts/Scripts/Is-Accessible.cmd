SET COMP=%1
SET LoggedIn=No
SET LOGGEDINUSER=

@ECHO Machine,Accessible?>%ResultsFolder%\Header.txt

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
@ECHO %1 ,Unknown result >%ResultsFolder%\%1.txt & Del %1.txt & exit

:Continue
@SET Accessible=NoAccess
@Echo Checking access...
@if exist \\%comp%\c$ (
	SET Accessible=Accessible
	@GOTO :LogIt
)
IF "%UserO%" NEQ "" IF "%PasswordO%" NEQ "" ( 
	@ECHO Mapping with %UserO%
	net use \\%comp%\c$ /u:%UserO% %PasswordO%
	@if exist \\%comp%\c$ (
		SET Accessible=AlternateCreds
		@GOTO :LogIt
	)
)


:LogIt
ECHO %COMP%,%Accessible%>%ResultsFolder%\%COMP%.txt
If /I "%Pause%"=="True" @Pause
@GOTO :END


:END
DEL %comp%.txt
net use \\%comp%\c$ /d
EXIT
