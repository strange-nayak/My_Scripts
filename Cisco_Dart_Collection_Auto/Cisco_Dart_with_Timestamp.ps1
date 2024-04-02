 # Generates the DART bundle with the current datetime in the filename
    # and puts it on the user's desktop
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $DartLocation = '{0}\DARTBundle_{1}.zip' -f $DesktopPath, (Get-Date -Format FileDateTimeUniversal)
    $AnyconnectDartCliLocation = 'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\DART\dartcli.exe'
    $SecureClientDartCliLocation = 'C:\Program Files (x86)\Cisco\Cisco Secure Client\DART\dartcli.exe'
    if (Test-Path -Path $AnyconnectDartCliLocation -PathType Leaf) {
        $DartCliLocation = $AnyconnectDartCliLocation
    }
    if (Test-Path -Path $SecureClientDartCliLocation -PathType Leaf) {
        $DartCliLocation = $SecureClientDartCliLocation
    }
    if (-not($DartCliLocation)) {
        throw "Unable to find DART Program.  Is DART installed?"
    }
    Start-Process -FilePath $DartCliLocation -ArgumentList "-dst `"$DartLocation`"" -Wait -NoNewWindow
    return $DartLocation

    #FileDateTimeUniversal