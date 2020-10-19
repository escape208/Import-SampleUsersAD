# Import-SampleUsersAD
Generates a list of sample users and imports them into AD.  This module uses the public API from `https://randomuser.me` to generate a majority of its sample data.  Some custom data for making it more AD-appropriate is outlined below.

## Departments

Users are categorized into one of 4 departments at random:

* Marketing
* IT 
* Engineering
* Sales

Each department has multiple job titles available that are randomly assigned to the user. 

## User Placement

The user object is placed into a parent OU of the same name as the department.  For example a `Marketing` user will be added to the `Marketing` department OU.  If this OU doesn't already exist, a new one is created.

All new Department OUs are created under the `Personal Accounts` OU, or the OU specified by the user in parameter `-BaseOUName`. If this OU doesn't exist, a new one is created at the root of the domain.

Default OU structure if no `-BaseOUName` is specified:
```text
OU=Personal Accounts
  |
  OU=Marketing
  |  |
  |  CN=FirstUser
  |  CN=SecondUser
  |  
  OU=IT
     |
     CN=ThirdUser
     CN=FourthUser
...
```

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