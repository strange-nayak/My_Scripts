# Disable Inactive users
Import-Module ActiveDirectory

# Domain Names as the DropDown Values

[array]$DropDownArray = "bsg.ad.adp.com:3268", "ADP-ICD.net"

# This Function Returns the Selected Value and Closes the Form

function Return-DropDown {
 $script:Choice = $DropDown.SelectedItem.ToString()
 $Form.Close()
}

function DomainName {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


    $Form = New-Object System.Windows.Forms.Form

    $Form.width = 300
    $Form.height = 130
    $Form.Text = ”Domain”
    $Form.StartPosition = "CenterScreen"

    $DropDown = new-object System.Windows.Forms.ComboBox
    $DropDown.Location = new-object System.Drawing.Size(100,20)
    $DropDown.Size = new-object System.Drawing.Size(130,40)

    ForEach ($Item in $DropDownArray) {
     [void] $DropDown.Items.Add($Item)
    }

    $Form.Controls.Add($DropDown)

    $DropDownLabel = new-object System.Windows.Forms.Label
    $DropDownLabel.Location = new-object System.Drawing.Size(10,10) 
    $DropDownLabel.size = new-object System.Drawing.Size(100,40) 
    $DropDownLabel.Text = "Select Domain"
    $Form.Controls.Add($DropDownLabel)

    $Button = new-object System.Windows.Forms.Button
    $Button.Location = new-object System.Drawing.Size(100,50)
    $Button.Size = new-object System.Drawing.Size(80,20)
    $Button.Text = "OK"
    $Button.Add_Click({Return-DropDown})
    $form.Controls.Add($Button)

    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()


    return $script:choice
}

Write-Host "Enter Report date:"
$Report= Read-Host
$Domain = DomainName

#Fetching Admin Details
$Who= whoami
$whoAmI= ($Who -Split '\\')[1]
$Email=get-Aduser -identity $whoAmI -Properties * |select mail
$EmailId= $Email.mail

Write-host " Processing..."

#Importing Users from CSV file
$Users = Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\User.csv" -Header "AccountName"

#Adding Date
$Date= date
$DateStr = $Date.ToString("MM/dd/yyyy")
$Data = foreach($User in $Users)
{
   $AccountName= $User.AccountName
   
   #Checking User domain
   $CN = (Get-ADUser -Identity $AccountName -Property CanonicalName -Server bsg.ad.adp.com:3268 ).CanonicalName
   $CNSuffix = ($CN -Split '/')[0] 
   $server= $CNSuffix

    #Updating Description
    $ADUser = Get-ADUser -Identity $AccountName  -server $server -Properties Description
    $ADUser.Description = "Disabled Inactivity - $DateStr"
    
    #Disabling Account
    Disable-ADAccount -Identity $AccountName -server $server
    Set-ADUser -Instance $ADUser
       
    New-Object -TypeName psobject -Property @{
    ADUser = $ADUser.Name
    Domain = $UPNSuffix
    Object = $ADUser
    Description = $ADUser.Description
     
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
  <h3> Below Users are Disabled by {0} </h3>

</body>
"@ -f $whoAmI

$body1 = $Data | Select-Object -Property  ADUser,Domain,Object,Description | ConvertTo-Html -Head $Header -body $body

$fromaddress = $EmailId 
$toaddress = "GlobalHelpdeskIndiaTeam@broadridge.com" 
$CCaddress = "Emma.Chadderton@broadridge.com" 
$Subject = "Action Taken | Inactive User Report $Report" 
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
