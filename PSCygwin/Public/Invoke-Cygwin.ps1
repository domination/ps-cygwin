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
function Invoke-Cygwin
{
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [scriptblock] $Script,

        [Parameter()]
        [Cygwin.InstallInfo]$CygwinEnvironment
    )

    begin
    {
        $selectedEnvironment = $CygwinEnvironment;
        if ($null -eq $CygwinEnvironment)
        {
            # get latest of already installed
            $selectedEnvironment = Get-Cygwin | Sort-Object Timestamp -Descending | Select-Object -First 1;
            Write-Verbose ('Selecting [{0}] as current environment.' -f $selectedEnvironment.Path);
        }
    }

    process
    {
        $executable = Join-Path -Path $selectedEnvironment.Path -ChildPath 'bin/bash.exe';
        # . "$RootDir\bin\bash.exe" --login -c $Script;
        . $executable @('-c', $Script);
    }

    end
    {
    }
}