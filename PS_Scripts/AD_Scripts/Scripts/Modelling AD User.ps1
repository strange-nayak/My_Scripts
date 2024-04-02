#Extracting groups from one user and modelling it to other
Import-module Activedirectory
$Server = "bsg.ad.adp.com"
Write-Host "Enter Reference User ID:" 
$User1=Read-Host

Write-Host "Enter User ID:"
$User2= Read-Host

$Groups = Get-ADPrincipalGroupMembership $User1 -Server $Server
foreach($Group in $Groups){
Try
{

 Add-ADGroupMember -Identity $Group  -Members $User2 -Server "bsg.ad.adp.com"

}
Catch
{
Write-host $_.Exception.Message
}

}
