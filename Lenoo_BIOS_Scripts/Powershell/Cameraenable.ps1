$Settings = "IntegratedCameraAccess, Enabled", "Tq81bN50,ascii,us"

$pcnames = Import-Csv pcnames.csv
foreach ($name in $pcnames) {Set-LenovoBIOSSettings -ComputerName $name.ColumnName -SetcdtingsToBeApplied $Settings}