Import-Module ActiveDirectory
$Date= date
$DateStr = $Date.ToString("MM-dd-yyyy")
$Users= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\Samacc.csv"
$data= foreach ($User in $Users.samaccountName)
{

    $ADUSer= Get-ADUser -Identity $User -Properties *

    New-Object -TypeName psobject -Property @{
        ADUser = $ADUser.Name
        SamaccountName = $ADUSer.samaccountName
        Object = $ADUser
        Description = $ADUser.Description
        Homedrive = $ADUSer.HomeDirectory
        Location = $ADUSer.Office
        EmployeeNumber = $ADUSer.EmployeeNumber
     
	}
  }

$data | Select-Object ADUser, EmployeeNumber, SamaccountName, Location, Object, Description, Homedrive | Export-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Output\Del_Rep_$DateStr.csv"

foreach($EID in $Data.EmployeeNumber){

$Details= Get-ADUser -Filter{EmployeeNumber -eq $EID } -Properties * | select SamaccountName, Description

if( $Details.Description -like 'Termed*')
{

$Details.SamaccountName
Remove-ADUser -Identity $Details.SamaccountName -Confirm: $false

}
 
}
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