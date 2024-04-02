import-module activedirectory
#Importing Users from CSV file
$Users = Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\User.csv" -Header "AccountName"

#Adding Date
$Date= date
$DateStr = $Date.ToString("MM/dd/yyyy")
foreach($User in $Users)
{
 $AccountName= $User.AccountName
 $AccountName

#Checking User domain
 $UPN = (Get-ADUser -Identity $AccountName -Property UserPrincipalName -Server bsg.ad.adp.com:3268 ).UserPrincipalName
 $UPNSuffix = ($UPN -Split '@')[1] 
 $server= $UPNSuffix

#Updating Description
 $ADUser = Get-ADUser -Identity $AccountName  -server $server -Properties Description
 $ADUser.Description = "Termed - $DateStr"

#Removing Groups from User
 $Groups = Get-ADPrincipalGroupMembership $AccountName -Server $Server
foreach($Group in $Groups)
{
   if($Group.name -ne "Domain Users")
   {
   $Group.name
     Remove-ADPrincipalGroupMembership -Identity $AccountName -MemberOf $Group -Confirm:$false
   }
}

#Disabling Account
 Disable-ADAccount -Identity $AccountName -server $server
 Set-ADUser -Instance $ADUser
}