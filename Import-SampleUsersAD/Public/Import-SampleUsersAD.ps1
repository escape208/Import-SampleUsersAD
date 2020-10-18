Function Import-SampleUsersAD {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Server,

        [Parameter(Mandatory = $false)]
        [String]
        $BaseOUName = "Personal Accounts",

        [Parameter(Mandatory = $false)]
        [int]
        $NumberOfUsers = 1,

        [Parameter(Mandatory = $false)]
        [string]
        $NewUserOutput = "NewUsers.csv",

        [Parameter(Mandatory = $false)]
        [bool]
        $Enabled = $false,

        [switch]
        $GenerateSecurePassword,

        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )

    try {
        Import-Module ActiveDirectory
    }
    catch {
        Write-Error "Unable to Import Module 'ActiveDirectory': $($_.Exception.Message)"
        exit
    }

    try {
        $GlobalParams = @{}

        $now = (Get-Date -Format "MMddyyyy-HHmmss")

        if (-not (Test-Path ".\Output\")) {
            New-Item -Name "Output" -ItemType Directory
        }

        $NewUserOutput = ".\Output\CreatedUsers-$now.csv"

        if ($Credential) {
            $GlobalParams.Add("Credential", $Credential)
        }

        if ($Server) {
            $GlobalParams.Add("Server", $Server)
        }

        $suffix = (Get-ADForest @GlobalParams).Name
    
        $myUsers = Get-SampleUserData -NumberOfUsers $NumberOfUsers | ConvertFrom-Json

        $parentDn = Assert-OUExists -Name $BaseOUName @GlobalParams
            
        foreach ($user in $myUsers) {

            $job = Get-RandomJob
            $department = $job.Department
            $departmentOU = Assert-OUExists -Name $department -BaseOU $parentDn @GlobalParams

            $userParams = @{
                Name              = $user.login.username
                Path              = $departmentOU.DistinguishedName
                GivenName         = $user.name.first
                Surname           = $user.name.last
                Title             = $job.Title
                OfficePhone       = $user.phone
                MobilePhone       = $user.cell
                UserPrincipalName = ($user.login.username + "@" + $suffix)
                Enabled           = $Enabled
            }

            $plainTextPwd = $null
            if ($Enabled -or $GenerateSecurePassword) {
                $plainTextPwd = New-SWRandomPassword -MinPasswordLength 8 -MaxPasswordLength 15 -Count 1
                
                $userParams.Add("AccountPassword", ($plainTextPwd | ConvertTo-SecureString -AsPlainText -Force))
            }

            $createdUser = New-ADUser @GlobalParams @userParams -PassThru

            $createdUserPSO = [pscustomobject]@{ }

            #Populate the PSCustomObject with our attribute data
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "Name" -Value $createdUser.Name
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "GivenName" -Value $createdUser.GivenName
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "Surname" -Value $createdUser.Surname
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "DistinguishedName" -Value $createdUser.DistinguishedName
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "Title" -Value $userParams.Title
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "OfficePhone" -Value $userParams.OfficePhone
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "MobilePhone" -Value $userParams.MobilePhone
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "UserPrincipalName" -Value $userParams.UserPrincipalName
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "AccountPassword" $plainTextPwd
            $createdUserPSO | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $Enabled

            Write-Host "Created user '$($userParams.Name)', Title = '$($userParams.Title)'" -ForegroundColor Green

            $createdUserPSO | Export-Csv -Path $NewUserOutput -Append
            
        }

        if (Test-Path $NewUserOutput) {
            Write-Host "A copy of created users can be found here $NewUserOutput" -ForegroundColor Green
        }
        else {
            Write-Host "No users created" -ForegroundColor Yellow
        }

    }
    catch {
        Write-Error "Error occurred: $($_.Exception.Message)"
    }

}