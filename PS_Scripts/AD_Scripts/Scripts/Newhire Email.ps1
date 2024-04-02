Import-Module ActiveDirectory
$Who= whoami
$whoAmI= ($Who -Split '\\')[1]
$SendID= (get-aduser -Identity $whoAmI -Properties mail).mail
$Users= Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Hire_List.csv"
foreach($User in $Users)
{
$Requestor= $User.Requestor
$SamAccountName= $User.SamAccountName
$Passwd= $User.Password
$RQSTNo= $User.RequestNo

$ADUser= Get-ADUSer -Identity $SamAccountName -Properties *
$EmpID= $ADUser.EmployeeNumber
$Displayname= $ADUser.Name
$MailID= $ADUser.EmailAddress

$body =@"

<head>
<style>
p.a {font-family: "Calibri", Times, serif;}
p.b {font-family: Arial, Helvetica, sans-serif;}
</style>
</head>
<body>

<p class="a" >Hi,  <br>
Windows account and Email ID are created for {0} - {1} <br> <br>
Username: BSG\{2} <br>
Email ID: {4} <br>
Password: {3} <br><br>
Thanks, <br>
SaiSuhanth <br>

<body>
        
    <p>Thanks,<br>SaiSuhanth</p>

</body>
"@ -f $Displayname, $EmpID, $SamAccountName, $Passwd, $MailID

$body1 = ConvertTo-Html -Head $Header -body $body

$fromaddress = $SendID 
$toaddress = $Requestor 
$CCaddress = $SendID 
$Subject = "New Account Creation | $RQSTNo" 
$body = $body1
$smtpserver = "edgsmtp.broadridge.net" 

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

}