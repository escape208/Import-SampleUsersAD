param (
    [Parameter(Mandatory = $false)]
    [Int32]
    $NumberOfUsers = 1,

    [Parameter(Mandatory = $false)]
    [String]
    $Server = "ad.mybudgetworld.com",

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

Import-SampleUsersAD @params
