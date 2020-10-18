Function Import-SampleUsersAD {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Server,

        [Parameter(Mandatory = $false)]
        [String]
        $BaseOU = "Personal Accounts",

        [Parameter(Mandatory = $false)]
        [int]
        $NumberOfUsers = 1,

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

        if ($Credential) {
            $GlobalParams.Add("Credential", $Credential)
        }

        if ($Server) {
            $GlobalParams.Add("Server", $Server)
        }

        if (-not (Test-Path ".\Output\")) {
            New-Item -Name "Output" -ItemType Directory
        }        
    
        $myUsers = Get-SampleUserData | ConvertFrom-Json

        $ou = Get-ADOrganizationalUnit -LDAPFilter "(name=$BaseOU)" @GlobalParams

        if (-not $ou) {
            $ou = New-ADOrganizationalUnit -Name $BaseOU -Description "OU Created by Import-SampleUsersAD" @GlobalParams -PassThru
        }
            
        foreach ($user in $myUsers) {
            $job = Get-RandomJob
            $department = $job.Department
            $username = $user.login.username
            $parentDn = $ou.DistinguishedName

            $departmentOU = Get-ADOrganizationalUnit -LDAPFilter "(name=$department)" -SearchBase $($ou.DistinguishedName) @GlobalParams

            if (-not $departmentOU) {
                $departmentOU = New-ADOrganizationalUnit -Name $department -Description "OU Created by Import-SampleUsersAD" -Path $parentDn @GlobalParams -PassThru
            }

            $createdUser = New-ADUser -Name $username -Path $departmentOU -Title $job.Title @GlobalParams -PassThru
            Write-Host "Created user $($createdUser.Name), Title = '$($createdUser.Title)'" -ForegroundColor Green
            
        }

    }
    catch {
        Write-Error "Error occurred: $($_.Exception.Message)"
    }

}