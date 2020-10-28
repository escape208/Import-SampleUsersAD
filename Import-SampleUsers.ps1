param (
    [Parameter(Mandatory = $false)]
    [Int32]
    $NumberOfUsers = 1,

    [Parameter(Mandatory = $false)]
    [String]
    $Server = "ad.mybudgetworld.com",

    [Parameter(Mandatory = $false)]
    [string]
    $BaseOUName,

    [bool]
    $Enabled = $false
)

Import-Module -Name ".\Import-SampleUsersAD" -Force

if (-not ($myCred)) {
    $myCred = (Get-Credential)
}

$params = @{
    "Credential"    = $myCred
    "NumberOfUsers" = $NumberOfUsers
    "Enabled"       = $Enabled
}

if ($Server) {
    $params.Add("Server", $Server)
}

if ($BaseOUName) {
    $params.Add("BaseOUName", $BaseOUName)
}

Import-SampleUsersAD @params
