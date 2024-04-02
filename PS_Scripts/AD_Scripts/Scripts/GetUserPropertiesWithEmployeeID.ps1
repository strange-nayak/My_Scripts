# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the path to your CSV file containing associate IDs
$csvFilePath = "C:\Users\nayaks\Downloads\NovDecJanNewJoiners.csv"

# Load the CSV data
$users = Import-Csv -Path $csvFilePath

# Initialize an array to store results
$results = @()

# Iterate through each row in the CSV data
foreach ($user in $users) {
    $associateID = $user.EmployeeID  # Assuming the column name in the CSV is "AssociateID"

    # Query AD to find the object based on the associate ID
    $adObject = Get-ADUser -Filter { employeenumber -eq $associateID } -Server bsg.ad.adp.com:3268 -Properties whenCreated, employeenumber, Displayname, SamAccountName

    # Create a custom object with relevant information
    $resultObject = [PSCustomObject]@{
        AssociateID = $adObject.employeenumber
        Name = $adObject.Displayname
        SamAccountName = $adObject.SamAccountName
        WhenCreated = $adObject.whenCreated
    }

    # Add the result to the array
    $results += $resultObject
}

# Export the results to a new CSV file
$results | Export-Csv -Path "C:\Users\nayaks\Downloads\NovDecJanNewJoiners-data1.csv" -NoTypeInformation

# Optionally, display the results on the console
$results | Format-Table -AutoSize
