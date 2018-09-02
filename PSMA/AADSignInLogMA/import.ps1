param ($username,$password,$operationtype = "full",[bool] $usepagedimport,$pagesize)

begin
{
    # Load configuration data file
    $config = [XML](Get-Content C:\PSMA\B2BHouseKeepSolution.xml)

    # Variables for Authentication
    $ClientID      = $config.B2BHouseKeepSolution.PowerShell.ClientID  
    $ClientSecret  = $config.B2BHouseKeepSolution.PowerShell.ClientSecret
    $loginURL      = "https://login.microsoftonline.com"
    $tenantdomain  = $config.B2BHouseKeepSolution.PowerShell.TenantName
    $resource      = "https://graph.microsoft.com/"

    # Get an OAuth2 access token based on client id, secret and tenant domain
    $body          = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret}
    $oauth         = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantdomain/oauth2/token?api-version=1.0 -Body $body

    $headers  = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}
}

process
{
    # Get list of SignInEntrys sign-ins
    # Possible optimization of future versions: Get only B2B account and read only those sign-ins here instead of all sign-ins
    $GraphURI = "https://graph.microsoft.com/beta/auditLogs/signIns"
    $getNextPage = $true
    $FullList = @()

    # Get all result pages of signin logs
    While ($getNextPage)
    {
        $ResultList = Invoke-RestMethod -Method GET -Uri $GraphURI -Headers $headers
        $FullList += $ResultList.value

        If ($ResultList.'@odata.nextLink' -eq $null)
        {
            $getNextPage = $false
        }
        else
        {
            $GraphURI = $ResultList.'@odata.nextLink'
        }
    }

    # Group signins by userId
    $SignInLogList = $FullList | Group-Object userId

    # Create the input object and output it to MIM MA pipeline
    foreach ($SignInEntry in $SignInLogList)
    {
        # Sort by last login time (create date of signin object) and get only the newest object
        $Object = $SignInEntry.Group | Sort-Object -Descending createdDateTime | Select-Object -First 1

        if ($Object.status.errorCode -eq 0)
        {
            $obj = @{}
	        $obj.ObjectId = $Object.UserId 
	        $obj.objectclass = "SignInLogEntry"
	        $obj.DisplayName = $Object.UserDisplayName
            $obj.LastLogin = ([DateTime]$Object.createdDateTime).ToString()
            $obj.UserPrincipalName = $Object.UserPrincipalName
            $obj
        }
    }
}

end
{
}
