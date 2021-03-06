Function Get-SampleUserData {
    param(
        [Parameter(Mandatory = $true)]
        [int]
        $NumberOfUsers
    )

    $myResults = Invoke-RestMethod -Uri "https://randomuser.me/api/?nat=us&inc=name,login,phone,cell&results=$NumberOfUsers" -Method Get

    $QtyResults = $myResults.results | Measure-Object

    if ($QtyResults.Count -gt 0) {
        return $myResults.results | ConvertTo-Json
    }
    else {
        return $null
    }
    
}