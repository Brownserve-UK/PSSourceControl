function Set-GitLabCIVariable
{
    <#
    .SYNOPSIS
        Creates or updates a GitLab CI/CD variable.
    .DESCRIPTION
        Always deletes then recreates the variable. This handles the masked+hidden case
        (hidden variables cannot be updated in place via the API) and keeps the logic
        simple for all other cases.

        Defaults: Masked=true, Hidden=true, Protected=false.

        Requires the glab CLI (https://gitlab.com/gitlab-org/cli) to be installed and
        authenticated.
    .EXAMPLE
        Set-GitLabCIVariable -Name 'github_token' -Project 'mygroup/myrepo'
        Prompts securely for the value, then creates the variable with default settings.
    .EXAMPLE
        Set-GitLabCIVariable -Name 'github_token' -Project 'mygroup/myrepo' -Protected $true
        Creates the variable as protected (only available on protected branches and tags).
    .EXAMPLE
        Set-GitLabCIVariable -Name 'DEBUG_FLAG' -Project 'mygroup/myrepo' -Masked $false -Hidden $false
        Creates a non-sensitive variable visible in job logs and the UI.
    #>
    [CmdletBinding()]
    param
    (
        # The name of the CI/CD variable
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Name,

        # The value of the variable (prompted securely if not provided)
        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [SecureString]
        $Value,

        # The GitLab project path (e.g. 'group/repo')
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [string]
        $Project,

        # Optional description for the variable
        [Parameter(
            Mandatory = $false
        )]
        [string]
        $Description,

        # Whether the variable value should be masked in job logs
        [Parameter(
            Mandatory = $false
        )]
        [bool]
        $Masked = $true,

        # Whether the variable should be hidden in the UI
        [Parameter(
            Mandatory = $false
        )]
        [bool]
        $Hidden = $true,

        # Whether the variable should only be available on protected branches and tags
        [Parameter(
            Mandatory = $false
        )]
        [bool]
        $Protected = $false
    )

    begin
    {
        if (-not (Get-Command glab -ErrorAction SilentlyContinue))
        {
            throw 'glab CLI not found. Install from https://gitlab.com/gitlab-org/cli/-/releases'
        }
    }

    process
    {
        if (-not $Value)
        {
            $Value = Read-Host "Enter value for '$Name'" -AsSecureString
        }

        $BSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Value)
        try
        {
            $PlainText = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

            Write-Verbose "Removing existing '$Name' if present..."
            try
            {
                Invoke-NativeCommand `
                    -FilePath 'glab' `
                    -ArgumentList @('variable', 'delete', $Name, '--yes', '-R', $Project) `
                    -SuppressOutput `
                    -ErrorAction 'Stop'
            }
            catch
            {
                if ($_.Exception.Message -notmatch '404|not.found|does not exist')
                {
                    Write-Warning "Unexpected error deleting '$Name': $($_.Exception.Message)"
                }
            }

            Write-Verbose "Creating '$Name'..."
            $GlabArgs = [System.Collections.Generic.List[string]]@(
                'variable', 'set', $Name, '--value', $PlainText, '-R', $Project
            )
            if ($Description) { $GlabArgs.AddRange([string[]]@('--description', $Description)) }
            if ($Masked)      { $GlabArgs.Add('--masked') }
            if ($Hidden)      { $GlabArgs.Add('--hidden') }
            if ($Protected)   { $GlabArgs.Add('--protected') }

            try
            {
                Invoke-NativeCommand `
                    -FilePath 'glab' `
                    -ArgumentList $GlabArgs `
                    -SuppressOutput `
                    -ErrorAction 'Stop'
            }
            catch
            {
                throw "Failed to create variable '$Name'.`n$($_.Exception.Message)"
            }

            Write-Verbose "'$Name' set (Masked=$Masked, Hidden=$Hidden, Protected=$Protected)"
        }
        finally
        {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        }
    }

    end {}
}
