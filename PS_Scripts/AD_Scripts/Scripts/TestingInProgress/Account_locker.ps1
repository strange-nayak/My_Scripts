
Write-Host "Enter Username:"
$User= Read-Host
$Password= ConvertTo-SecureString 'IT@blr2023' -AsPlainText -Force

            Do {

                Invoke-Command -ComputerName BGLRT495000999 {Get-Process
                } -Credential (New-Object System.Management.Automation.PSCredential ($($User), $Password)) -ErrorAction SilentlyContinue

            }
            Until ((Get-ADUser -Identity $User -Properties LockedOut).LockedOut)

            Write-Output "$($User) has been locked out"
       