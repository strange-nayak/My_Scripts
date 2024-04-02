#Creation of Security groups

Import-Module ActiveDirectory

$OUdata= Get-ADOrganizationalUnit -filter * -Server "bsg.ad.adp.com" | Where-Object {$_.name -like '* Groups'}  | select Name
[array]$DropDownArray = $OUdata.name

# This Function Returns the Selected Value and Closes the Form

function Return-DropDown {
 $script:Choice = $DropDown.SelectedItem.ToString()
 $Form.Close()
}

function NameofOU {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


    $Form = New-Object System.Windows.Forms.Form

    $Form.width = 300
    $Form.height = 130
    $Form.Text = ”Organizational Unit”
    $Form.StartPosition = "CenterScreen"

    $DropDown = new-object System.Windows.Forms.ComboBox
    $DropDown.Location = new-object System.Drawing.Size(100,20)
    $DropDown.Size = new-object System.Drawing.Size(130,40)

    ForEach ($Item in $DropDownArray) {
     [void] $DropDown.Items.Add($Item)
    }

    $Form.Controls.Add($DropDown)

    $DropDownLabel = new-object System.Windows.Forms.Label
    $DropDownLabel.Location = new-object System.Drawing.Size(10,10) 
    $DropDownLabel.size = new-object System.Drawing.Size(100,40) 
    $DropDownLabel.Text = "Select OU"
    $Form.Controls.Add($DropDownLabel)

    $Button = new-object System.Windows.Forms.Button
    $Button.Location = new-object System.Drawing.Size(100,50)
    $Button.Size = new-object System.Drawing.Size(80,20)
    $Button.Text = "OK"
    $Button.Add_Click({Return-DropDown})
    $form.Controls.Add($Button)

    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()


    return $script:choice
}

$SOUName= NameofOU

$OUName= Get-ADOrganizationalUnit -filter 'Name -like $SOUName' |select distinguishedname

$Groups= import-csv -path "C:\Users\PuligaddaS\Desktop\PowerGUI\Groups.csv"

foreach ($Group in $Groups.name)
{

    Try{
    $Name= Get-ADgroup $Group
    $Name.name
    Write-host "$group already exists"
    }
    catch
    {
    New-ADgroup -Name $group -path $OUName -GroupCategory Security -GroupScope Universal -ManagedBy NgC 
    Write-host "$group is created"
    }
}