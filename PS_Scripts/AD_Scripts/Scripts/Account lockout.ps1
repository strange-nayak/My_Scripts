$AccountName= Read-host
Write-host $AccountName
Import-Module ActiveDirectory
$Lock= Get-WinEvent -ComputerName jsipswwdca04.bsg.ad.adp.com -FilterHashtable @{Logname='Security';Id=4740} | Where-Object {$_.message -match "$AccountName"} | Fl
$Email= Get-ADUser -Identity $AccountName -Properties mail -Server bsg.ad.adp.com:3268

#Mailing Part#
$header= @"
<head>
<style>
p.a {font-family: Calibri, Times, serif;}
p.b {font-family: Arial, Helvetica, sans-serif;}
</style>
</head>
"@

$body =@"

<body>

    <p>Hi, </p>
    <p> Please find below details:</p>
    <P>{0}</p>
        
    <p>Thanks,<br>Global Helpdesk Team</p>

</body>
"@ -f $Lock

$body1 = ConvertTo-Html -head $header -body $body 

$fromaddress = "BroadridgeInternalHelpdesk@broadridge.com" 
$toaddress = $Email.mail 
$CCaddress = "BroadridgeInternalHelpdesk@broadridge.com" 
$Subject = "Account Lockout Status" 
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