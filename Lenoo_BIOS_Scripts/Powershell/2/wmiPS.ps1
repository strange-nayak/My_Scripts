param(
[Parameter(Mandatory=$true,Position=1)]
[string]$password,
    [Parameter(Mandatory=$true,Position=2)]
    [array]$config
)
$settings = Get-Content $config

foreach($setting in $settings)
{
    #$run = "$setting,$password,ascii,us"
    #$Response = (gwmi -class Lenovo_SetBiosSetting -namespace root\wmi).SetBiosSetting("$run").return
    #write-output ("$setting`n$Response")
    $Response = (gwmi -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings("$password,ascii,us").return
    write-output ("$setting`n$Response")
    $Response = (gwmi -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings("$password,ascii,us").return
    write-output ("$setting`n$Response")
}
#The thing you were missing (and should have been elaborated more on in the guide) was this line:

