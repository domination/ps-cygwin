Set-StrictMode -Version Latest

$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

$Script:PSModuleLocalTemp = Join-Path -Path $PSModuleRoot -ChildPath 'LocalTemp';

if (-not(Test-Path -Path $Script:PSModuleLocalTemp -PathType Container))
{
    try
    {
        New-Item -Path $Script:PSModuleLocalTemp -ItemType Directory -ErrorAction Stop
    }
    catch
    {
        throw $_;
    }
}

$public = Get-ChildItem -Path (Join-Path -Path $PSModuleRoot -ChildPath 'Public') -Filter '*.ps1';

$public | ForEach-Object {
    Import-Module $_ -ErrorAction Stop
}

# $PSCmdlet.ThrowTerminatingError("[$($_.FullName)]")
# Export-ModuleMember -Function $public.Basename
# Update-FormatData -Prepend (Join-Path $PSScriptRoot '*.ps1xml')
