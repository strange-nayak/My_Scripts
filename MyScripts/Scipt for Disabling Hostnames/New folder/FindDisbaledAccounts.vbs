Const ADS_UF_ACCOUNTDISABLE = 2 
  
Set objConnection = CreateObject(ADODB.Connection) 
objConnection.Open Provider=ADsDSOObject; 
Set objCommand = CreateObject(ADODB.Command) 
objCommand.ActiveConnection = objConnection 
objCommand.CommandText = _ 
    GCOU=HBAD Servers,OU=HBAD,DC=bsg,DC=ad,dc=adp,dc=com;(objectCategory=Computers) & _ 
        ;userAccountControl,distinguishedName;subtree   
Set objRecordSet = objCommand.Execute 
  
intCounter = 0 
Do Until objRecordset.EOF 
    intUAC=objRecordset.Fields(userAccountControl) 
    If intUAC AND ADS_UF_ACCOUNTDISABLE Then 
        WScript.echo objRecordset.Fields(distinguishedName) &  is disabled 
        intCounter = intCounter + 1 
    End If 
    objRecordset.MoveNext 
Loop 
  
WScript.Echo VbCrLf & A total of  & intCounter &  accounts are disabled. 
  
objConnection.Close 

