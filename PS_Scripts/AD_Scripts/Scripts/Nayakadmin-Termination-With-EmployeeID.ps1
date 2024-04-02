#Termination With Email

Set-ExecutionPolicy RemoteSigned
Import-Module ActiveDirectory

#Fetching Admin Details

$Email= whoami /upn
$ToEmailAddress = 'britteamblr@broadridge.com'

#Importing Users from CSV file

$Users = Import-Csv -Path "C:\Users\nayakadmin\Desktop\Term_List.csv"

#Adding Date

$Date= date
$DateStr = $Date.ToString("dd-MM-yyyy")
$Data = @()

$Data= foreach($User in $Users)

{
Write-host $User

 #Fetch the values from CSV

 $EmpID= $User.EmployeeID
 $RQSTNO= $user.RequestNo
  
 #Get the User Details from AD based on EmployeeNumber
 
 $Names= Get-aduser -filter { employeenumber -eq $EmpID } -Server bsg.ad.adp.com:3268 -Properties * | select name, DistinguishedName, samaccountname ,userprincipalname ,Displayname ,mail ,Description
 
  
 # Disable AD account
 
 Get-ADUser -Server bsg.ad.adp.com -Identity $Names.SamAccountName  | Where {($_.Enabled -like "True")}| Set-ADUser -Enabled $false
     
 #Updating Description

 $Description = "Termed - $DateStr - $RQSTNO" 

 Set-ADUser -Server bsg.ad.adp.com -Identity $Names.SamAccountName -Description $Description



   
   New-Object -TypeName psobject -Property @{

        EmpID = $User.EmployeeID
        ADUser = $Names.Displayname
        Samaccountname = $Names.Samaccountname
        Email  = $Names.mail
        Description = $Description
        OU =$Names.DistinguishedName
        Remarks= "Terminated"
        }
 

  
} #End 


#Mailing Part#
$Header = @"
<style>

TABLE {font-family: "Trebuchet MS", sans-serif;border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 6px;border-style: solid;border-color: black;background-color: #01CFCA;}
TD {border-width: 1px;padding: 4px;border-style: solid;border-color: black;}
TR:hover{background-color:#f5f5f5}

body {
   
} 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</style>


"@

$body =@"

<body>
  
  <h2> 
  Hi Team,
  
  <h3>
  Below Users are Terminated by {0} </h3>



</body>
"@ -f $Email

$body1 = $Data | Select-Object -Property EmpID,ADUser,Email,Samaccountname,Description,OU,Remarks | ConvertTo-Html -Head $Header -body $body

$fromaddress = $Email 
$toaddress = $ToEmailAddress
$CCaddress = "saikrishna.nayak@broadridge.com" 
$Subject = "Termination Processed | $Datestr" 
$body = $body1
$smtpserver = "Hydas02.bsg.ad.adp.com" 

 ################
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
$message.CC.Add($CCaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
#$attach = new-object Net.Mail.Attachment($attachment) 
#$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 