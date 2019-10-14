# B2BHouseKeepingSolution
Azure Active Directory (Azure AD) business-to-business (B2B) collaboration features enable companies to securely share applications, information and services with guest users from any other organization. Users can be quickly invited and provided with access to the tools and services they require. 

The ability to manage the lifecycle of these B2B identities does pose some challenges since at its core Azure B2B is a federation mechanism that implies account management is done remotely, within the business partners' infrastrucutre. The current project aims to however provide Microsoft Identity Manager customers with the abiltity to automate the revokation of access based on inactivity.

## The Challenge
At the time of publication, Azure AD does not provide any mechanism to get rid of unused guest accounts invites or inactive users. Additionally, there is no *LastLogin* attribute that can for example be used to detect activity, so the process of removing access is often quite manual.

This is where the Azure AD B2B guest user “Housekeeping” solution can maybe help you. It provides a way to import a *LastLogin* attribute in the MIM MetaVerse using the Microsoft Azure AD Sign-ins actitiy which can be used to automate lifecycle management activities within MIM.

## Requirements
The B2B guest user Housekeeping solution based on MIM2016 and requires the installation of the [Granfeldt PSMA](https://github.com/sorengranfeldt/psma)

# Solution Contents
Included in the solution is:

- AADSignInLogMA: Granfeldt PowerShell MA files (import, export, schema) that are used to import Azure Active Directory sign-ins activity from your AzureAD (to track user activity)
- B2BUserMA: Granfeldt PowerShell MA files (import, export, schema) to manage AzureAD B2B invites and users in your AzureAD tenant.
- Metaverse Code Extension: A sample MVExtension that allows for the deprovisioning of invites/users based on *DaysAfterDeletePendingInvites* and *DaysAfterDeleteInactiveGuests* configuration parameters in the *B2BHouseKeepSolution.xml* file
- Management Agent Exports: Configuration export files of working B2BUserMA and AADLogInMA has been provided for convenience
- XML configuration file: The entire solution is configuration via the *B2BHouseKeepSolution.xml* file which contains AzureAD tenant details as well as parameters for the MVExtension.

**NOTE** - This project is a proof of concept. Altough samples run smoothly in lab environments caution is advised before adding this into production. Please test and update on your own.

# More information
See https://justidm.wordpress.com/2018/09/02/azure-ad-b2b-guest-user-housekeeping-solution-with-mim2016 for a complete breakdown of the solution and its components.

# Contribution

We welcome any contribution to the project. This can be achieved by either creating a pull request with any useful additionals or submitting an issue if any are found.
