#####################################################################
# AUTHOR  : Victor Ashiedu 
# DATE    : 01-10-2014
# WEB     : iTechguides.com
# BLOG    : iTechguides.com/blog
# COMMENT : This PowerShell script creates a home folder for all users in Active Directory   
#           (Accessed only by the user) If this script was helpful to you, 
#           please take time to rate it at: http://gallery.technet.microsoft.com/PowerShell-script-to-832e08ed
#####################################################################
############################VERY IMPORTANT:##########################

#before you run this script enure that you read the ReadMe text file
######################################################################

#This script has the following functionalities:#######################

#1 Creates a persoanl (home folder) for all AD users 
#2 Provides option to create users folders as DisplayName or sAMAccountname (Log on name) 
#3 Grants each users "Full Control" to his or her folder
#4 Maps the users folder as drive 'H' (Configured via AD Users property, 
#5 Ensures that users canot access another user's folder

#######################################################################
#######################################################################

#BEGIN SCRIPT

#Define variable for a server to use with query.
#This might be necessary if you operate in a Windows Server 2003 Domain
# and have AD web services installed in a particular DC

$ADServer = 'BGIPVWWDCA01.bsg.ad.adp.com' #change name to your DC


#Get Admin accountb credential

$GetAdminact = Get-Credential 

#Import Active Directory Module

Import-Module ActiveDirectory

#define search base - the OU where you want to 
# search for users to modify. you can define the 
#domain as your searchbase
#add OU in the format OU=OU 1,Users OU,DC=domain,DC=com

$searchbase = "OU=BGLR Contractors,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" #Amend this to the actual OU. 
#If you wish to amend all users in your dommain, use the root of your domain here

#Search for AD users to modify

$ADUsers = Import-Csv -Path "C:\Nayak_testlab\CreatehomefolderforADUsers\User Details.csv"

#$ADUsers = Get-ADUser -server $ADServer -Filter * -Credential $GetAdminact -searchbase $searchbase -Properties *

$ADUser= $User.SamAccountName

#modify display name of all users in AD (based on search criteria) to the format "LastName, FirstName Initials"

#ForEach ($ADUser in $ADUsers)

ForEach ($ADUser in $ADUsers)
{
#The line below creates a folder for each user in the \\serrver\users$ share
#Ensure that you have configured the 'Users' base folder as outlined in the post

#New-Item -ItemType Directory -Path "\\70411SRV1\Users$\$($ADUser.sAMAccountname)"
#New-Item -ItemType Directory -Path "\\70411SRV1\Users$\$($ADUser.DisplayName)"

New-Item -ItemType Directory -Path "\\10.159.11.16\Home$\$ADUser"

#Grant each user Full Control to the users home folder only

#define domain name to use in the $UsersAm variable

$Domain = 'bsg.ad.adp.com'

#Define variables for the access rights

#1Define variable for user to grant access (IdentityReference: the user name in Active Directory)
#Usually in the format domainname\username or groupname

$UsersAm = "$Domain\$($ADUser.sAMAccountname)" #presenting the sAMAccountname in this format 
#stops it displaying in Distinguished Name format 

#Define FileSystemAccessRights:identifies what type of access we are defining, whether it is Full Access, Read, Write, Modify

$FileSystemAccessRights = [System.Security.AccessControl.FileSystemRights]"FullControl"

#define InheritanceFlags:defines how the security propagates to child objects by default
#Very important - so that users have ability to create or delete files or folders 
#in their folders

$InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::"ContainerInherit", "ObjectInherit"

#Define PropagationFlags: specifies which access rights are inherited from the parent folder (users folder).

$PropagationFlags = [System.Security.AccessControl.PropagationFlags]::None

#Define AccessControlType:defines if the rule created below will be an 'allow' or 'Deny' rule

$AccessControl =[System.Security.AccessControl.AccessControlType]::Allow 
#define a new access rule to apply to users folfers

$NewAccessrule = New-Object System.Security.AccessControl.FileSystemAccessRule `
    ($UsersAm, $FileSystemAccessRights, $InheritanceFlags, $PropagationFlags, $AccessControl) 


#set acl for each user folder#First, define the folder for each user

#$userfolder = "\\70411SRV1\Users$\$($ADUser.sAMAccountname)"
#$userfolder = "\\70411SRV1\Users$\$($ADUser.DisplayName)"
$userfolder = "\\10.159.11.16\Home$\$ADUser"
$currentACL = Get-ACL -path $userfolder
#Add this access rule to the ACL
$currentACL.SetAccessRule($NewAccessrule)
#Write the changes to the user folder
Set-ACL -path $userfolder -AclObject $currentACL

#set variable for homeDirectory (personal folder) and homeDrive (drive letter)

#$homeDirectory = "\\70411SRV1\Users$\$($ADUser.sAMAccountname)" #This maps the folder for each user 
#$homeDirectory = "\\70411SRV1\Users$\$($ADUser.DisplayName)" #This maps the folder for each user 
$homeDirectory = "\\10.159.11.16\Home$\$ADUser"

#Set homeDrive for each user

$homeDrive = "H:"
#This maps the homedirectory to drive letter H
#Ensure that drive letter H is not in use for any of the users

#Update the HomeDirectory and HomeDrive info for each user


Set-ADUser -server $ADServer -Credential $GetAdminact -Identity $ADUser.sAMAccountname -Replace @{HomeDirectory=$homeDirectory}
Set-ADUser -server $ADServer -Credential $GetAdminact -Identity $ADUser.sAMAccountname -Replace @{HomeDrive=$homeDrive}
}
#END SCRIPT
  
  