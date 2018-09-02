$obj = new-object -type pscustomobject
$obj | add-member -type noteproperty -name "Anchor-ObjectId|String" -Value "ObjectId"
$obj | add-member -type noteproperty -name "objectClass|String" -Value "SignInLogEntry"
$obj | add-member -type noteproperty -name 'LastLogin|String' -value "LastLoginDateTime"
$obj | add-member -type noteproperty -name 'UserPrincipalName|String' -value "UPN"
$obj | add-member -type noteproperty -name 'DisplayName|String' -value "DisplayName"
$obj
