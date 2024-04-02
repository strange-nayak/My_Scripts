Get-Content "C:\Users\nayaks\Desktop\WarrantyData\Emails.txt" | ForEach-Object {
  $mail = $_
  $user = Get-ADUser -LDAPFilter "(mail=$mail)"
  if ( $user ) {
    $sAMAccountName = $user.sAMAccountName
  }
  else {
    $sAMAccountName = $null
  }
  [PSCustomObject] @{
    "mail" = $mail
    "sAMAccountName" = $sAMAccountName
  }
} | Export-Csv "C:\Users\nayaks\Desktop\WarrantyData\Usernames.csv" -NoTypeInformation