param ($username,$password,$operationtype = "full",[bool] $usepagedimport,$pagesize)

begin
{
   # Load Active Directory Module für PowerShell
    Import-Module AzureAD

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
    # Get list of B2B (Guest) users
    $UserList = Get-AzureADUser -Filter "CreationType eq 'Invitation'" -All $true

    foreach ($User in $UserList)
    {
        $obj = @{}
        $obj.ObjectId = $User.ObjectId 
        $obj.objectclass = "B2BUser"
        $obj.DisplayName = $User.DisplayName
        $obj.LastLogin = $User.ExtensionProperty.$ExtensionAttribute
        $obj.UserPrincipalName = $User.UserPrincipalName
        $obj.CreatedDateTime = $User.ExtensionProperty.createdDateTime.ToString()
        $obj.InviteStatus = $User.ExtensionProperty.userState
        $obj
    }

}

end
{
}
