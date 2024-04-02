$File = "C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\OldComputers.txt"

ForEach ($Computer in (Get-Content $File))
{   Try {
        Remove-ADComputer $Computer -ErrorAction Stop -confirm:$false
        Add-Content C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\remove-mycomputers.log -Value "$Computer removed"
    }
    Catch {
        Add-Content C:\Nayak_testlab\PS_Scripts\AD_Scripts\Input\remove-mycomputers.log -Value "$Computer not found because $($Error[0])"
    }
}