Function Get-RandomJob {

    $Jobs = @()

    $Jobs += [pscustomobject]@{
        "Department" = "Marketing"
        "Titles"     = @("Marketing Manager", "Jr Marketer", "Sr Marketer", "Dir Marketing", "VP Marketing", "EVP Marketing")
    }

    $Jobs += [pscustomobject]@{
        "Department" = "Technology"
        "Titles"     = @("IT Manager", "Assoc Systems Administrator", "Sr Systems Administrator", "Dir IT", "VP IT")
    }

    $Jobs += [pscustomobject]@{
        "Department" = "Sales"
        "Titles"     = @("Sales Manager", "Account Manager", "Jr Sales Rep", "Sr Sales Rep", "Dir Sales", "VP Sales")
    }

    $Jobs += [pscustomobject]@{
        "Department" = "Engineering"
        "Titles"     = @("Engineering Manager", "Jr Engineer", "Sr Engineer", "Dir Engineering", "VP Engineering")
    }

    $jobIndex = Get-Random -Maximum (($Jobs | Measure-Object).Count - 1)

    $titleIndex = Get-Random -Maximum (($Jobs[$jobIndex].Titles | Measure-Object).Count - 1)

    return [pscustomobject]@{
        "Department" = $Jobs[$jobIndex].Department
        "Title"      = $Jobs[$jobIndex].Titles[$titleIndex]
    }

}