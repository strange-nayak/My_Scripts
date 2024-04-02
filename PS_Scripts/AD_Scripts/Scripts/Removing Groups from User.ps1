#Extracting groups from one user and modelling it to other
Import-module Activedirectory
$Server = "bsg.ad.adp.com"
$Groups = Get-ADPrincipalGroupMembership SuhanthTest -Server $Server
foreach($Group in $Groups)
{
   $Group.name
   if($Group.name -ne "Domain Users")
   {
     Remove-ADPrincipalGroupMembership -Identity SuhanthTest -MemberOf $Group
   }
}