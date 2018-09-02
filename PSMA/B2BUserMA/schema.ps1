$obj = new-object -type pscustomobject
$obj | add-member -type noteproperty -name "Anchor-ObjectId|String" -Value "ObjectId"
$obj | add-member -type noteproperty -name "objectClass|String" -Value "B2BUser"
$obj | add-member -type noteproperty -name 'LastLogin|String' -value "LastLoginDateTime"
$obj | add-member -type noteproperty -name 'UserPrincipalName|String' -value "UPN"
$obj | add-member -type noteproperty -name 'DisplayName|String' -value "DisplayName"
$obj | add-member -type noteproperty -name 'InviteStatus|String' -value "Status"
$obj | add-member -type noteproperty -name 'CreatedDateTime|String' -value "DateTimeString"
$obj
