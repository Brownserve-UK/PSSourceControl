#requires -Modules Pester
#.SYNOPSIS
#   Performs functional tests for PSSourceControl cmdlets
Describe 'Source control cmdlets' {
    Context 'ConvertTo-HTTPSRepoURL' {
        It 'should convert an SSH GitHub URI to an HTTPS URL' {
            InModuleScope Brownserve.PSSourceControl {
                $GitURI = [GitURI]'git@github.com:Brownserve-UK/MyRepo.git'
                ConvertTo-HTTPSRepoURL -InputObject $GitURI |
                    Should -Be 'https://github.com/Brownserve-UK/MyRepo'
            }
        }
        It 'should convert an SSH GitLab URI to an HTTPS URL' {
            InModuleScope Brownserve.PSSourceControl {
                $GitURI = [GitURI]'git@gitlab.com:mygroup/myproject.git'
                ConvertTo-HTTPSRepoURL -InputObject $GitURI |
                    Should -Be 'https://gitlab.com/mygroup/myproject'
            }
        }
        It 'should throw when a non-SSH string is passed as the URI' {
            InModuleScope Brownserve.PSSourceControl {
                { [GitURI]'https://github.com/owner/repo.git' } | Should -Throw
            }
        }
    }

    Context 'Get-GitCurrentBranch' {
        BeforeAll {
            Mock Invoke-NativeCommand -ModuleName Brownserve.PSSourceControl {
                [pscustomobject]@{ OutputContent = @('main') }
            }
        }
        It 'should return the current branch name' {
            $Result = Get-GitCurrentBranch -RepositoryPath $TestDrive
            $Result | Should -Be 'main'
        }
        It 'should invoke git rev-parse to determine the branch' {
            Get-GitCurrentBranch -RepositoryPath $TestDrive
            Should -Invoke Invoke-NativeCommand -ModuleName Brownserve.PSSourceControl -Times 1 -ParameterFilter {
                $FilePath -eq 'git' -and $ArgumentList -contains '--abbrev-ref'
            }
        }
    }

    Context 'Get-GitBranches' {
        BeforeAll {
            Mock Invoke-NativeCommand -ModuleName Brownserve.PSSourceControl {
                [pscustomobject]@{ OutputContent = @('main', 'develop', 'feature/foo') }
            }
        }
        It 'should return all branch names' {
            $Result = Get-GitBranches -RepositoryPath $TestDrive
            $Result | Should -Contain 'main'
            $Result | Should -Contain 'develop'
            $Result | Should -Contain 'feature/foo'
        }
        It 'should return the correct number of branches' {
            $Result = Get-GitBranches -RepositoryPath $TestDrive
            $Result.Count | Should -Be 3
        }
    }
}
