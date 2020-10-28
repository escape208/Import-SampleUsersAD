Import-Module ".\Import-SampleUsersAD" -Force

Function Get-ADOrganizationalUnit { }

InModuleScope Import-SampleUsersAD {
    
    Describe "Assert-OUExists Tests" {

        Context "OU doesn't exist" {

            Mock Get-ADOrganizationalUnit { $false }

            Mock New-ADOrganizationalUnit {
                return [PSCustomObject]@{
                    Name = "myOU"
                    Description = "OU Created by Import-SampleUsersAD"
                } 
            }

            It "Create a new one" {

                Assert-OUExists -Name "MyName"

                Assert-MockCalled New-ADOrganizationalUnit
            }
        }
        

    }
}