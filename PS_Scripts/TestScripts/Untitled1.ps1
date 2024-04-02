#Set the path for your local user.txt file.
$out_file="C:\Nayak_testlab\PS_Scripts\user.txt"

####Get all the users in our OU. Uncomment and save to text file.

#Get-ADUser -filter * -SearchBase "OU=BGLR Users,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" | Select samaccountname | out-file $out_file

####Comment out the line above once you have a list of users as this step does not need to be done every time.



#make an endless look (on purpose)
while($true){
    ForEach ($file in (Get-Content -Path $out_file)) {
        #gets rid of trailing spaces and unlocks account
        unlock-adaccount $file.trim()
        #tells you how far along you are
        Write-Output $file.trim() "Has been Unlocked"
    }
} 
