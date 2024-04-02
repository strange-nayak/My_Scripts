$fromaddress = "saisuhanth.puligadda@broadridge.com" 
$toaddress = "saisuhanth.puligadda@broadridge.com" 
$bccaddress = "saisuhanth.puligadda@broadridge.com"  
$CCaddress = "Laxman.biyyala@broadridge.com" 
$Subject = "NeedReview" 
$body = "TestToDelete"
$attachment = "C:\Users\PuligaddaS\Documents\address proof.pdf" 
$smtpserver = "edgsmtp.broadridge.net" 
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
$message.CC.Add($CCaddress) 
$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 