<#
.SYNOPSIS
    Updates properties of an existing GitHub release.
.DESCRIPTION
    Updates properties of an existing GitHub release via the GitHub API.
    Commonly used to publish a draft release after all assets have been uploaded.
#>
function Update-GitHubRelease
{
    [CmdletBinding()]
    param
    (
        # The numeric ID of the release to update (returned by New-GitHubRelease as .id)
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [long]
        $ReleaseId,

        # The GitHub repo the release belongs to
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [Alias('RepoName')]
        [string]
        $RepositoryName,

        # The owner/organisation of the repo
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [Alias('GitHubOrganisation', 'GitHubOrganization', 'GitHubOrg')]
        [string]
        $RepositoryOwner,

        # The PAT to access the repo
        [Parameter(
            Mandatory = $true
        )]
        [Alias('GitHubToken', 'GitHubPAT')]
        [string]
        $Token,

        # Set to $false to publish a draft release, $true to convert back to draft
        [Parameter(
            Mandatory = $false
        )]
        [bool]
        $Draft,

        # Updated release name
        [Parameter(
            Mandatory = $false
        )]
        [string]
        $Name,

        # Updated release description/body
        [Parameter(
            Mandatory = $false
        )]
        [string]
        $Description
    )
    begin {}
    process
    {
        $Header = @{
            Authorization          = "Bearer $Token"
            Accept                 = 'application/vnd.github+json'
            'X-GitHub-Api-Version' = '2022-11-28'
        }
        $URI  = "https://api.github.com/repos/$RepositoryOwner/$RepositoryName/releases/$ReleaseId"
        $Body = @{}

        if ($PSBoundParameters.ContainsKey('Draft'))
        {
            $Body['draft'] = $Draft
        }
        if ($PSBoundParameters.ContainsKey('Name'))
        {
            $Body['name'] = $Name
        }
        if ($PSBoundParameters.ContainsKey('Description'))
        {
            $Body['body'] = $Description
        }

        if ($Body.Count -eq 0)
        {
            Write-Warning 'Update-GitHubRelease: no properties to update were specified.'
            return $null
        }

        try
        {
            $BodyJSON = $Body | ConvertTo-Json
            $Result = Invoke-RestMethod -Headers $Header -Uri $URI -Body $BodyJSON -Method Patch -ErrorAction Stop
        }
        catch
        {
            throw "Failed to update GitHub release $ReleaseId.`n$($_.Exception.Message)"
        }
    }
    end
    {
        if ($Result)
        {
            return $Result
        }
    }
}
