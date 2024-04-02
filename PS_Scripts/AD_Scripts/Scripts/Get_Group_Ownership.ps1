Import-Module ActiveDirectory
$Groups= Import-Csv -Path "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\Group_Names.csv"
foreach ($Group in $Groups.Group_Names){
Get-ADGroup -Identity "$Group" -Properties managedBy |
#Get-ADGroup -filter {Name -like "*IT*" } -Properties managedBy |
ForEach-Object 
$managedBy = $_.managedBy;

if ($managedBy -ne $null)
{
 $manager = (get-aduser -Identity $managedBy -Properties emailAddress);
 $managerName = $manager.Name;
 $managerEmail = $manager.emailAddress;
}
else
{
 $managerName = 'N/A';
 $managerEmail = 'N/A';
}
}
Write-Output | 
Select-Object @{n='Group Name';e={$_.Name}}, @{n='Managed By Name';e={$managerName}}, @{n='Managed By Email';e={$managerEmail}}