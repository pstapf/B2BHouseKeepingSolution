param($username = "",$password = "")

begin
{
   # Load Active Directory Module für PowerShell
    Import-Module AzureAD

   	function log($message)
	{
		write-debug $message
		$datum = Get-Date -Format "dd.MM.yyyy - HH:mm:ss"
		$datum + ": " + $message | out-file C:\PSMA\B2BUserMA\logs\B2BUserMA-export.log -append
	}
	
    # Load configuration data file
    $config = [XML](Get-Content C:\PSMA\B2BHouseKeepSolution.xml)
    $ExtensionAttribute = $config.B2BHouseKeepSolution.PowerShell.LastLoginExtAttribute

    # Connect to AzureAD with credentials from MA config
    $SecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential $username, $SecurePassword
    Connect-AzureAD -Credential $creds | Out-Null
}

process
{
	$error.clear()
	
	$errorstatus = "success"
	$errordetails = ""

    # Get object data from pipeline		
	$identifier = $_."[Identifier]"
	$anchor = $_."[DN]"
	$objectmodificationtype = $_."[ObjectModificationType]"
	$changedattrs = $_.'[ChangedAttributeNames]'
    $LastLoginString = $_.LastLogin
    $DisplayName = $_.DisplayName

    #Enable to Debug
	#$_ | out-file C:\PSMA\B2BUserMA\logs\B2BUserMAExportObjects.txt -Force -Append
	
	try
	{
		$errorstatus = "success"
		
        # Set the LastLogin Date of B2BUser
		if ( $objectmodificationtype -eq 'Replace' )
		{
            if ($changedattrs -contains "LastLogin")
            {
                $LastLoginDate = [datetime]::ParseExact($LastLoginString,'dd.MM.yyyy HH:mm:ss',$null)
                $retun = Set-AzureADUserExtension -ObjectId $anchor -ExtensionName $ExtensionAttribute -ExtensionValue $LastLoginDate

                $message = "[B2BUser] Set LastLoginDate of user: " + "$DisplayName [$anchor]" + " to: " + $LastLoginDate.ToString()
                log $message
            }
		}

        # Delete B2BUser
		if ( $objectmodificationtype -eq 'Delete' )
		{
            $return = Remove-AzureADUser -ObjectId $anchor

            $message = "[B2BUser] Delete user: " + "$DisplayName [$anchor]" 
            log $message
		}

	}
	catch [exception]
	{
		$errorstatus = "export-exception"
		$errordetails = $error[0].exception
        log $errordetails
	}

	# we do not handle any errors in the current version but
	# instead just return success and let MIM handle any discovery
	# of missing adds or updates
	$status = @{}
	$status."[Identifier]" = $identifier
	$status."[ErrorName]" = $errorstatus
	$status."[ErrorDetail]" = $errordetails
	$status
}

end
{
}
