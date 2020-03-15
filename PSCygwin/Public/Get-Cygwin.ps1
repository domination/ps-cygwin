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
    [CmdletBinding()]
    param (
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
    }

    process
    {
        return [Cygwin.InstallInfo[]]($registry | Group-Object { $_.Value.TrimEnd('\\') -replace '^\\\?\?\\', '' } | Select-Object -Property @{l = 'Path'; e = { $_.Name } }, @{l = 'Registry'; e = { $_.Group } });
        #return $locations;
        # Get-Content V:\cyg\etc\setup\setup.rc
    }

    end
    {
    }
}