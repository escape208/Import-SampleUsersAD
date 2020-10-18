Function Assert-OUExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [String]
        $BaseOU,

        [Parameter(Mandatory = $false)]
        [string]
        $Server,

        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )

    $ErrorActionPreference = "Stop"

    $params = @{ }

    $getParams = @{ }

    $newParams = @{ }

    if ($Server) {
        $params.Add("Server", $Server)
    }

    if ($Credential) {
        $params.Add("Credential", $Credential)
    }

    if ($BaseOU) {
        $getParams.Add("SearchBase", $BaseOU)
        $newParams.Add("Path", $BaseOU)
    }

    $ou = Get-ADOrganizationalUnit -LDAPFilter "(name=$Name)" @params @getParams

    if (-not $ou) {
        $ou = New-ADOrganizationalUnit -Name $Name -Description "OU Created by Import-SampleUsersAD" @params @newParams -PassThru
    }

    return $ou

}