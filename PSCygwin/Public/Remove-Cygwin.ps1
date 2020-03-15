<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Remove-Cygwin
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNull()]
        [Cygwin.InstallInfo] $CygwinEnvironment
    )

    process
    {
        Write-Verbose ($CygwinEnvironment | Format-List * | Out-String);

        if (-not($CygwinEnvironment.Exists))
        {
            Write-Warning ('Seems that directory [{0}] is already deleted.' -f $CygwinEnvironment.Path);
        }

        if (Test-Path -Path $CygwinEnvironment.Path -PathType Container)
        {
            if ($PSCmdlet.ShouldProcess(('{0}' -f $CygwinEnvironment.Path), 'Remove'))
            {
                Remove-Item -Path $CygwinEnvironment.Path -Recurse;
            }
            else
            {
                Write-Host ('Remove: [{0}]' -f $CygwinEnvironment.Path);
            }
        }

        $registryItemPath = $CygwinEnvironment.Registry.Path -replace '^HKEY_CURRENT_USER', 'HKCU:' -replace '^HKEY_LOCAL_MACHINE', 'HKLM:';
        $registryItem = Get-ItemProperty -Path $registryItemPath -Name $CygwinEnvironment.Registry.Name -ErrorAction SilentlyContinue;
        if ($null -ne $registryItem)
        {
            if ($PSCmdlet.ShouldProcess(('{0}\{1}' -f $CygwinEnvironment.Registry.Path, $CygwinEnvironment.Registry.Name), 'Delete'))
            {
                Remove-ItemProperty -Path $registryItemPath -Name $CygwinEnvironment.Registry.Name;
            }
            else
            {
                Write-Host ('Remove: [{0}]' -f $CygwinEnvironment.Path);
            }
        }
    }
}