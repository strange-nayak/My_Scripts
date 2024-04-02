Import-Module ActiveDirectory

$Users = Import-Csv -Path "C:\Users\PuligaddaS\Desktop\PowerGUI\Term2.csv"

$Date= date
$DateStr = $Date.ToString("MM/dd/yyyy")

$Data= foreach($User in $Users){

Write-host "$User"

 $LastName= $User.LastName
 $FirstName= $User.FirstName
 $RQSTNO= $user.RequestNo
 
 Try
 {
 #Get the User Details from AD based on EmployeeNumber
 $Names= Get-aduser -filter { Surname -eq $LastName } -Server adp-icd.net | select GivenName, SurName, samaccountname
 
 foreach($Name in $Names){
 $GN= $Name.GivenName     #AD DisplayName
 
 #Cross checking AD Display Name with CSV Display Name
 if($GN -eq $FirstName)
 {
     Write-host "Condition Satisfied"
     Write-Host "$RQSTNO"

     $AccountName = $Name.samaccountname #AD SamAccountName

    #Checking User domain
     $UPN = (Get-ADUser -Identity $AccountName -Property UserPrincipalName -Server adp-icd.net ).UserPrincipalName
     $UPNSuffix = ($UPN -Split '@')[1] 
     $server= $UPNSuffix

    #Updating Description
     $ADUser = Get-ADUser -Identity $AccountName  -server $server -Properties *
     $ADUser.Description = "Termed - $DateStr - $RQSTNO" 

    #Removing Group membership of User
     $Groups = Get-ADPrincipalGroupMembership $AccountName -Server $Server
    foreach($Group in $Groups)
    {
        if($Group.name -ne "Domain Users")
       {
        Remove-ADPrincipalGroupMembership -Identity $AccountName -MemberOf $Group -Confirm:$false
       }
    } #End of forloop

    #Disabling Account
     Disable-ADAccount -Identity $AccountName -server $server
     Set-ADUser -Instance $ADUser
}
}


}
Catch{

Write-host "$Lastname - Not found"
}
}