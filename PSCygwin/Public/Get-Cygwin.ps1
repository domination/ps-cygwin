using module ..\Private\Cygwin.psm1

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
function Get-Cygwin
{
    [CmdletBinding(DefaultParameterSetName = 'Env')]

    [OutputType('Cygwin.InstallInfo[]', ParameterSetName = 'Env')]
    [OutputType('Cygwin.Package[]', ParameterSetName = 'Packages')]
    param (
        # Specifies a path to one or more locations. Wildcards are permitted.
        [Parameter(Mandatory = $false, Position = 0, ParameterSetName = "Env",
            ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]] $Path,

        # List all installation - even if directory not exists.
        [Parameter()]
        [switch] $All,

        # List installed packages.
        [Parameter(ParameterSetName = 'Packages')]
        [switch] $ListInstalled
    )

    begin
    {
        # HKEY_LOCAL_MACHINE\SOFTWARE\Cygwin
        $hklm = Get-ChildItem -Path HKLM:\SOFTWARE\Cygwin -Recurse -ErrorAction SilentlyContinue;
        # HKEY_CURRENT_USER\Software\Cygwin
        $hkcu = Get-ChildItem -Path HKCU:\SOFTWARE\Cygwin -Recurse -ErrorAction SilentlyContinue;

        # \Cygwin
        # - \Installations
        # - \setup
        $registry = @();
        foreach ($key in @($hklm + $hkcu))
        {
            $key.Property | ForEach-Object {
                $registry += [pscustomobject]@{
                    Path  = $key.Name;
                    Name  = $_;
                    Value = $key.GetValue($_);
                }
            }
        }

        [Cygwin.InstallInfo[]] $installInfos = $registry | Group-Object { $_.Value.TrimEnd('\\') -replace '^\\\?\?\\', '' } | ForEach-Object {
            [Cygwin.InstallInfo]::new($_.Name, $_.Group);
        }
    }

    process
    {
        [Cygwin.InstallInfo[]] $outputInstallInfos = $installInfos;
        if (-not($All))
        {
            $outputInstallInfos = $installInfos | Where-Object Exists;
        }

        if ($Path.Count -gt 0)
        {
            $_outputInstallInfos = @();
            $Path | ForEach-Object {
                $_path = $_.TrimEnd('\', '/');
                $_outputInstallInfos += $outputInstallInfos | Where-Object Path -like $_path;
            }
            $outputInstallInfos = $_outputInstallInfos;
        }
    }

    end
    {
        if ($ListInstalled)
        {
            return $outputInstallInfos | ForEach-Object { $_.GetInstalledPackages() };
        }
        return $outputInstallInfos;
    }
}