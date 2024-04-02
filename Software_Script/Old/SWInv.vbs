'=====================================================================================
'
' NAME: SWInv.vbs
'
' COMMENT: This script will generate net inventory And get the report with
'	   the Machine Name, Software Installed, Owner of the Machine, Project Group
'	   and the Reporting Manager
'
'=====================================================================================
'On Error Resume Next
Const HKEY_LOCAL_MACHINE = &H80000002	'Handle for the HKLM Registry Hive
Const ForWriting = 2
Const ForAppending = 8
Const ForReading = 1
Const adOpenDynamic = 2
Const adLockOptimistic = 3
Const adUseClient = 3

Set FSO = Wscript.CreateObject("Scripting.FileSystemObject")	'Create an instance of FileSystemObject
Set WshShell = WScript.CreateObject("WScript.Shell")

if wscript.arguments.count = 0 then
   
   set McList = FSO.opentextfile("C:\BGLR software script\BGLRmach.txt",FORREADING, True)     'Open the File to check all the machines
else
   if FSO.FileExists(wscript.arguments(0)) then
      set McList = FSO.opentextfile(wscript.arguments(0),FORREADING, True)     'Open the File to check all the machines
   else
      wscript.echo "Cannot open file : " & wscript.arguments(0)
      wscript.quit
   end if
end if

'On Error Resume Next	 'Ensure the script wont break in between

Set objLocator = CreateObject("WbemScripting.SWbemLocator")	'Create an instance of Locator
set SWInvLog = fso.createtextfile("C:\BGLR software script\1st report\BGLRmach.xls")   'Create a file for writing the Log
set errLog = fso.createtextfile("C:\BGLR software script\1st report\BGLRmach.csv")	 'Create an Error Log file
set oNet = wscript.createobject ("WScript.network")
'set oConnPCInv = createobject("ADODB.Connection")
'set oRSPCInv = createobject("ADODB.recordset")

'sConnStr = "DRIVER={SQL Server};SERVER=HYDDC01;database=pcinv;"

'oConnPCInv.Open sConnStr
'oConnPCInv.CursorLocation = adUseClient

'oConnPCInv.DefaultDatabase = "PCINV"

generateList

'set oRSPCInv = nothing
'set oConnPCInv = nothing

SWInvLog.close
MCList.close

Set oNet = Nothing
Set FSO = Nothing

sub generateList

swList = ""

WScript.Echo "Beginning Software Inventory...."

SWInvLog.WriteLine "Machine Name" & vbtab & "Software List" & vbtab & "Operating System" & vbtab & "Service Pack" & vbtab & "Owner of Machine" & vbtab & "Project Name" & vbtab & "Reporting Manager"

Do while MCList.AtEndofStream <> True	'Check for every machine in the file mcnames.txt
	On Error Resume Next
	MCName = MCList.ReadLine	'Read one machine name at a time
	WScript.Echo "Connecting to : " & MCName	'Again Let the guys know what you are trying to Do
	Set objService = objLocator.ConnectServer(MCName, "Root\DEFAULT")	'Connect to the provider on that machine
	If Err.Number <> 0 Then 'Ensure you are able to connect
		errLog.WriteLine MCName & "," & Err.Description 'If you are not, write it in the log
		wscript.echo MCName & vbTab & ":" & vbTab & err.description	'Also let the guys know of the error, if the guys are too lazy to check the error log file.
		Err.Clear	'Clear the Error object so that for the next machine, the error number would be zero by Default
	Else	'Viola! We are able to connect to the machine
		Set objRegistry = objService.Get("StdRegProv")	'Now connect to the registry service
		OSVersion = GetOSVersion(MCName)	'Get the OS of that machine by calling the function GetOSVersion
		PCInvDetails = getPCInvInfo(MCName)
		Err.Clear	'Again set the error number back to zero
		Subkeys = GetKeys(MCName, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")	'Enum the Subkeys under uninstall for finding McAfee VirusScan
		For Each Subkey In Subkeys	'Loop through all the subkeys
			Err.Clear	'Ensure the error object does not spoil the fun
			strPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & Subkey	'Set the path to every subkey
			objRegistry.EnumValues HKEY_LOCAL_MACHINE, strPath, arrValueNames, arrValueTypes	'Enum the values in this subkey
			For i=0 to UBound(arrValueNames)	'Loop through the values
				If arrValueNames(i) = "DisplayName" Then	'We want the display name
					objRegistry.GetStringValue HKEY_LOCAL_MACHINE, strPath, arrValueNames(i), strDisplayNameValue	'Get this value's data
					if instr(1,strDisplayNameValue,"Hotfix") = 0 and instr(1,strDisplayNameValue,"Security Update for Windows") = 0 and instr(1,strDisplayNameValue,"Update for Windows XP") = 0 and strDisplayNameValue <> "" Then     'Check if this value is for any patches/hotfixes
					      
					      
					      On error Resume Next
					      SWInvLog.WriteLine MCName & vbtab & strDisplayNameValue & vbtab & OSVersion & vbtab & PCInvDetails
					      if err.number <> 0 then
						   wscript.echo err.description
						   swinverrlog.writeline "Error Writing to Log file: " & err.description
						   wscript.quit
					      end if
					   
					End If
					strDisplayNameValue=""	'Set the variables back to defaults so that they dont mess up with the next machine
				End If
			Next
		Next
		Set objRegistry = Nothing

	End If
	set objService = nothing
Loop

end sub


'This function enums the keys using WMI and returns all the subkeys.
Function GetKeys(strComputer, StrKeyPath)
    Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
    objReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, GetKeys
End Function

'Returns the OS Version which it gets via WMI
Function GetOSVersion(strComputer)
	Set colOperatingSystems = GetObject("winmgmts:{impersonationlevel=impersonate}!\\" & strComputer & "\root\cimv2").ExecQuery("select * from Win32_OperatingSystem")
    For Each objOperatingSystem in colOperatingSystems
		GetOSVersion = objOperatingSystem.Caption & vbtab & objOperatingSystem.CSDVersion
	Next
End Function

Function GetPCInvInfo(strComputer)
       set oRSPCInv = createobject("ADODB.Recordset")
       oRSPCInv.open "Select * from pcinv where ""machine name""='" & strComputer & "'",oConnPCInv, adOpenDynamic, adLockOptimistic
       getPCInvInfo = oRSPCINV("login id") & vbtab & oRSPCInv("Employee") & vbtab & oRSPCInv("Subgroup 1") & vbtab & oRSPCInv("Subgroup 2") & vbtab & oRSPCInv("manager")
end Function

'Enumerates Net View and parses And stores all the machine names
Public Sub GetMachines


Set mcNameFile = FSO.CreateTextFile("d:\swinvmachines.txt")

WshShell.Run "Cmd.exe /c Net View > C:\Windows\Temp\NetViewList.txt", 2,True

Set TheNVFile = FSO.OpenTextFile("C:\Windows\Temp\NetViewList.txt", ForReading, True)

Wscript.Echo "Evaluating Net View......"
Do While TheNVFile.AtEndOfStream <> True
	TheLine = TheNVFile.ReadLine
	Whacks = "\\"
	WhacksFound = FindPattern(TheLine, Whacks)
	If WhacksFound Then
		WhacksPattern = "\\\\\S*"
		Flag = "1"
		HostName = GetPattern(TheLine, WhacksPattern, Flag)
		mcNameFile.WriteLine HostName
	End If
Loop

TheNVFile.Close
FSO.DeleteFile("C:\Windows\Temp\NetViewList.txt")
Wscript.Echo "Done!"

McNameFile.close

End Sub

set wshShell = nothing

'This function is used to parse the net view and check if the view output is a machine name.
Function FindPattern(TheText, ThePattern)
	Set RegularExpression = New RegExp
	RegularExpression.Pattern = ThePattern
	If RegularExpression.Test(TheText) Then
		FindPattern = "True"
	Else
		FindPattern = "False"
	End If
End Function

'Looks for a pattern and returns the value that matched it.
Function GetPattern(TheText, ThePattern, Flag)
    Set RegularExpression = New RegExp
    RegularExpression.Pattern = ThePattern
	Set Matches = RegularExpression.Execute(TheText)
	For Each Match in Matches
		TheMatch = Match.Value
		If Flag = "1" Then TheMatch = Mid(TheMatch, 3)
	Next
	GetPattern = TheMatch
End Function
