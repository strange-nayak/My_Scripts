# Specify path to the text file with the computer account names.
$computers = Get-Content C:\Nayak_testlab\PS_Scripts\AD_Scripts\MoveComptoNewOU\Computers.txt

# Specify the path to the OU where computers will be moved.
$TargetOU   =  "OU=BGLR BPO Desktops,OU=BGLR,DC=bsg,DC=ad,DC=adp,DC=com" 
ForEach( $computer in $computers){
    Get-ADComputer $computer |
    Move-ADObject -TargetPath $TargetOU

}
