param (
    [Parameter(Mandatory = $false)]
    [Int32]
    $NumberOfUsers = 1,

    [Parameter(Mandatory = $false)]
    [String]
    $Server = "ad.mybudgetworld.com"
)

Import-Module -Name ".\Import-SampleUsersAD" -Force

if (-not ($myCred)) {
    $myCred = (Get-Credential)
}

$params = @{
    "Credential"    = $myCred
    "NumberOfUsers" = $NumberOfUsers
}

if ($Server) {
    $params.Add("Server", $Server)
}

Import-SampleUsersAD @params
