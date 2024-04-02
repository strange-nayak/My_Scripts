import-module activedirectory 
$logdate = Get-Date -format yyyyMMdd
$logfile = "C:\Nayak_testlab\AD_Scripts\logs\OldComputers - "+$logdate+".csv"
$mail = "britteamblr@broadridge.com"
$smtpserver = "hydas02.bsg.ad.adp.com"
$emailFrom = "Servicedesk@broadridge.com"
$domain = "bsg.ad.adp.com" 
$emailTo = "$mail"
$subject = "Old computers in Active Directory"
$DaysInactive = 360 
$time = (Get-Date).Adddays(-($DaysInactive))
$body = 
    "
    Hi Team,

    Please find the attached inactive computers file.  Please review and take necessary action.

 

    Seleted OU = BGLR Desktops, with Older Days set to 360 days.

 

    Thanks
    BR-IT Team

 

    "

# Change this line to the specific OU that you want to search
$searchOU = "OU=BGLR Desktops,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com"

 

# Get all AD computers with lastLogonTimestamp less than our time
Get-ADComputer -SearchBase $searchOU -Filter {LastLogonTimeStamp -lt $time } -Properties LastLogonTimeStamp, description, whenCreated |

# Output hostname and lastLogonTimestamp into CSV
select-object Name, DistinguishedName, enabled, description, whenCreated,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv $logfile -notypeinformation

 

Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -Body $body -Attachments $logfile -SmtpServer $smtpserver