---
external help file: Brownserve.PSSourceControl-help.xml
Module Name: Brownserve.PSSourceControl
online version:
schema: 2.0.0
---

# Set-GitLabCIVariable

## SYNOPSIS

Creates or updates a GitLab CI/CD variable.

## SYNTAX

```text
Set-GitLabCIVariable [-Name] <String> [[-Value] <SecureString>] [-Project] <String> [-Description <String>]
 [-Masked <Boolean>] [-Hidden <Boolean>] [-Protected <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION

Always deletes then recreates the variable.
This handles the masked+hidden case
(hidden variables cannot be updated in place via the API) and keeps the logic
simple for all other cases.

Defaults: Masked=true, Hidden=true, Protected=false.

Requires the [glab CLI](https://gitlab.com/gitlab-org/cli) to be installed and
authenticated.

## EXAMPLES

### EXAMPLE 1

```text
Set-GitLabCIVariable -Name 'github_token' -Project 'group/repo'
Prompts securely for the value, then creates the variable with default settings.
```

### EXAMPLE 2

```text
Set-GitLabCIVariable -Name 'github_token' -Project 'group/repo' -Protected $true
Creates the variable as protected (only available on protected branches and tags).
```

### EXAMPLE 3

```text
Set-GitLabCIVariable -Name 'DEBUG_FLAG' -Project 'group/repo' -Masked $false -Hidden $false
Creates a non-sensitive variable visible in job logs and the UI.
```

## PARAMETERS

### -Description

Optional description for the variable

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

### -Hidden

Whether the variable should be hidden in the UI

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Masked

Whether the variable value should be masked in job logs

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of the CI/CD variable

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project

The GitLab project path (e.g. 'group/repo')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protected

Whether the variable should only be available on protected branches and tags

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

### -Value

The value of the variable (prompted securely if not provided)

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
