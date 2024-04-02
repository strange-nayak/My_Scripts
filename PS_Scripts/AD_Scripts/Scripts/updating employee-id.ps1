Import-module ActiveDirectory
$Users= Import-csv "C:\Users\PuligaddaS\Desktop\PowerGUI\Emp_List.csv"
$Data= foreach($User in $Users){

    $Email= $User.Emailaddress
    #$EmpID=$User.EmpID
    $DN=$User.DisplayName

    Try{
    $ADUser= Get-ADUser -Filter{ mail -eq $Email } -Properties * -Server bsg.ad.adp.com:3268 | select Name, mail, samaccountname, Employeenumber
    #$UserName= $ADUser.samaccountname | Select-Object -First 1
    #Get-aduser -Identity $UserName
    #Set-ADUser -Identity $UserName -EmployeeNumber $EmpID -Server bsg.ad.adp.com:3268
    New-Object -TypeName psobject -Property @{
        EmpID = $ADUser.Employeenumber
        Email  = $Email
        }
    }

    Catch{
        Write-host "$Email - $EmpID - Not found"
         }
}
$data | select-object EmpID, Email | Export-Csv -path "C:\Users\PuligaddaS\Desktop\PowerGUI\Emp_Report_hyd.csv"