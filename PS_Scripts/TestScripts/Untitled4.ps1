#Set the path for your local user.txt file.
$out_file="C:\Nayak_testlab\PS_Scripts\lockeduser.txt"

#Filter the accounts that are locked
Get-ADUser -Properties LockedOut -SearchBase "OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" | Select samaccountname | out-file $out_file

#make an endless look (on purpose)
#while($true){
    ForEach ($file in (Get-Content -Path $out_file)) {
        #gets rid of trailing spaces and unlocks account
        unlock-adaccount $file.trim()
        #tells you how far along you are
        Write-Output $file.trim() "Has been Unlocked"
    }
#}