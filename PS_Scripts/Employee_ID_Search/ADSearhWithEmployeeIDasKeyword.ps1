Import-Csv EmployeeID.csv |
	ForEach-Object{
		if($user = Get-ADUser -Filter "employeeNumber -eq '$($_.EmployeeID)'"){
			[pscustomobject]@{EmployeeID=$_.EmployeeID;SamAccountName=$user.SamAccountName;Name=$user.Name}
	    }else{
			Write-Host "Not Found;$($_.EmployeeID)"
	    }
	} |
	Export-Csv employeedata.csv