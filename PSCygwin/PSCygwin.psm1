Set-StrictMode -Version Latest

$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

$public = Get-ChildItem -Path (Join-Path -Path $PSModuleRoot -ChildPath 'Public') -Filter '*.ps1';

$public | ForEach-Object {
    Import-Module $_ -ErrorAction Stop
}

# $PSCmdlet.ThrowTerminatingError("[$($_.FullName)]")
# Export-ModuleMember -Function $public.Basename
# Update-FormatData -Prepend (Join-Path $PSScriptRoot '*.ps1xml')
