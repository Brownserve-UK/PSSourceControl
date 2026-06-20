---
external help file: Brownserve.PSSourceControl-help.xml
Module Name: Brownserve.PSSourceControl
online version:
schema: 2.0.0
---

# Update-GitHubRelease

## SYNOPSIS

Updates properties of an existing GitHub release.

## SYNTAX

```text
Update-GitHubRelease [-ReleaseId] <Int64> [-RepositoryName] <String> [-RepositoryOwner] <String>
 -Token <String> [-Draft <Boolean>] [-Name <String>] [-Description <String>]
 [<CommonParameters>]
```

## DESCRIPTION

Updates properties of an existing GitHub release via the GitHub API.
Commonly used to publish a draft release after all assets have been uploaded.

## EXAMPLES

### Example 1: Publish a draft release

```powershell
$Release = New-GitHubRelease `
    -Name            'v1.2.0' `
    -Tag             'v1.2.0' `
    -Description     'Release notes here' `
    -RepositoryName  'MyRepo' `
    -RepositoryOwner 'MyOrg' `
    -Token           $token `
    -Draft

Add-GitHubReleaseAsset `
    -UploadUrl $Release.upload_url `
    -FilePath  'C:\artifacts\myapp-v1.2.0-x86_64-unknown-linux-gnu.tar.gz' `
    -Token     $token

Update-GitHubRelease `
    -ReleaseId       $Release.id `
    -RepositoryName  'MyRepo' `
    -RepositoryOwner 'MyOrg' `
    -Token           $token `
    -Draft           $false
```

Creates a draft release, uploads an asset, then publishes the release.

## PARAMETERS

### -Description

Updated release description/body

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Draft

Set to $false to publish a draft release, $true to convert back to draft

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Updated release name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseId

The numeric ID of the release to update (returned by New-GitHubRelease as .id)

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepositoryName

The GitHub repo the release belongs to

```yaml
Type: String
Parameter Sets: (All)
Aliases: RepoName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepositoryOwner

The owner/organisation of the repo

```yaml
Type: String
Parameter Sets: (All)
Aliases: GitHubOrganisation, GitHubOrganization, GitHubOrg

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token

The PAT to access the repo

```yaml
Type: String
Parameter Sets: (All)
Aliases: GitHubToken, GitHubPAT

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
