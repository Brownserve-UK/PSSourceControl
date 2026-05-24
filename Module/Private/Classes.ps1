<#
.DESCRIPTION
    Special private classes for the module.
    It's important that classes remain in one file as when they are in individual files they can be loaded in the wrong
    order which can cause 'type not found' errors.
    It also breaks IDEs as they can't find the type definition.
#>

<#
    This class converts shorthand git diffs into human readable status
#>
class GitDiff
{
    [string] $Value

    GitDiff([char] $Value)
    {
        $StatusMap = @{
            '?' = 'Untracked'
            '!' = 'Ignored'
            'A' = 'Added'
            'C' = 'Copied'
            'D' = 'Deleted'
            'M' = 'Modified'
            'R' = 'Renamed'
            'T' = 'Type Changed'
            'U' = 'Unmerged'
            ' ' = 'Unmodified'
        }
        if ($StatusMap.ContainsKey($Value))
        {
            $this.Value = $StatusMap[$Value]
        }
        else
        {
            throw "Invalid git status: '$Value'"
        }
    }

    GitDiff([string] $Value)
    {
        $StatusMap = @{
            '?' = 'Untracked'
            '!' = 'Ignored'
            'A' = 'Added'
            'C' = 'Copied'
            'D' = 'Deleted'
            'M' = 'Modified'
            'R' = 'Renamed'
            'T' = 'Type Changed'
            'U' = 'Unmerged'
            ' ' = 'Unmodified'
        }
        if ($StatusMap.ContainsKey($Value))
        {
            $this.Value = $StatusMap[$Value]
        }
        else
        {
            throw "Invalid git status: '$Value'"
        }
    }

    [string] ToString()
    {
        return "$($this.Value)"
    }
}

<#
    This class helps us format git status objects
#>
class GitStatus
{
    [GitDiff]$Staged
    [GitDiff]$Unstaged
    [string]$Source
    hidden [string]$Destination

    GitStatus([string]$Staged, [string]$Unstaged, [string]$Source, [string]$Destination)
    {
        $this.Staged = $Staged
        $this.Unstaged = $Unstaged
        $this.Source = $Source
        $this.Destination = $Destination
    }

    GitStatus([pscustomobject]$Status)
    {
        if (!$Status.Staged -and !$Status.Unstaged)
        {
            throw 'Cannot create GitStatus object without a Staged or Unstaged change'
        }
        if (!$Status.Source)
        {
            throw 'Cannot create GitStatus object without a Source'
        }
        $this.Staged = $Status.Staged
        $this.Unstaged = $Status.Unstaged
        $this.Source = $Status.Source
        $this.Destination = $Status.Destination
    }

    GitStatus([hashtable]$Status)
    {
        if (!$Status.Staged -and !$Status.Unstaged)
        {
            throw 'Cannot create GitStatus object without a Staged or Unstaged change'
        }
        if (!$Status.Source)
        {
            throw 'Cannot create GitStatus object without a Source'
        }
        $this.Staged = $Status.Staged
        $this.Unstaged = $Status.Unstaged
        $this.Source = $Status.Source
        $this.Destination = $Status.Destination
    }
}

<#
    Simple enum for GitHub issue/PR states
#>
enum GitHubIssueState
{
    Open
    Closed
    All
}
