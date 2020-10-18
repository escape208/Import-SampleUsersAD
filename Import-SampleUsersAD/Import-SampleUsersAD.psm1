try {
    $public = @(Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Recurse -ErrorAction SilentlyContinue)
    $private = @(Get-ChildItem -Path "$PSScriptRoot\private\*.ps1" -Recurse -ErrorAction SilentlyContinue)
    
    foreach ($import in @($public + $private)) {
        . $import.fullname
    }
    
}
catch {
    Write-Error -Message "Failed to import function $($import.fullname): $($_.Exception)"
}