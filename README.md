# Import-SampleUsersAD
Generates a list of sample users and imports them into AD.

## Import-SampleUsersAD

```powershell
Import-SampleUsersAD
    [-Server <string>]
    [-BaseOUName <string>]
    [-NumberOfUsers <int>]
    [-Enabled <bool>]
    [-GenerateSecurePassword]
    [-Credential <PSCredential>]
```

## Examples

### Example 1: Create 10 users into the 'MyUsers' OU

```powershell
Import-SampleUsersAD -BaseOUName "MyUsers" -NumberOfUsers 10
```

### Example 2: Create a new enabled user in domain 'myad.domain.com' with specified credentials
```powershell
$myCred = (Get-Credential)
Import-SampleUsersAD -Enabled $True -Server "myad.domain.com" -Credential $myCred
```

## Parameters

**-Server** 

The fully-qualified domain name of the domain to create the users.  If not specified, the domain of the current computer is used.

**-BaseOUName**

The name of the OrganizationalUnit to create the sub-OUs of new users. If not specified, 'OU=Personal Accounts' at the root of the domain is created.

**-NumberOfUsers**

The number of users to create.  If not specified, 1 user is created.

**-Enabled**

Create the User(s) in an enabled state.  If specified, a randomly-generated password that meets default AD password complexity is set on the user.  If not specified, the user is `Disabled` by default and no password is generated.  

**-GenerateSecurePassword**

Generates a random password on the user that meets default AD Password Compleixty requirements.

**-Credential**

Specifies the credentials to use to perform this task.  The default are the credentials of the currently logged on user.  