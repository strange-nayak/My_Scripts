Add-Type -Assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$namespace = $Outlook.GetNameSpace("MAPI")

$inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
#$inbox.Items | Format-Table BodyFormat, Body, HTMLBody, RTFBody | where-object {$_.message -match "RE: SharePoint 2013 Distribution Lists"}
$items= $inbox.Items 
foreach ($item in $items)
{

$item.Sender

}