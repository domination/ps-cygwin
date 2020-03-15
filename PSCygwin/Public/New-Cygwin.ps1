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
function New-Cygwin
{
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [uri] $SetupBaseUrl = 'https://cygwin.com/',

        # Parameter help description
        [Parameter()]
        [ValidateSet('x86_64', 'x86')]
        [string] $SetupArchitecture = 'x86_64',

        # Parameter help description
        [Parameter()]
        [string] $SetupBaseFileName = 'setup-{0}.exe',

        # Parameter help description
        [Parameter()]
        [switch] $ForceDownload
    )

    begin
    {
        $SetupFileName = $SetupBaseFileName -f $SetupArchitecture;
        $LocalSetupPath = Join-Path -Path $Script:PSModuleLocalTemp -ChildPath $SetupFileName;
        if (Test-Path -Path $LocalSetupPath -PathType Leaf)
        {
            Write-Verbose -Message ('Local setup file exists [{0}]' -f $LocalSetupPath);
        }

        if ($ForceDownload -or -not(Test-Path -Path $LocalSetupPath -PathType Leaf))
        {
            $DownloadUri = [uri]::new($SetupBaseUrl, $SetupFileName);
            Write-Verbose -Message ('Setup file will be downloaded from [{0}] and save as [{1}]' -f $DownloadUri, $LocalSetupPath);
            Invoke-WebRequest -Uri $DownloadUri -DisableKeepAlive -OutFile $LocalSetupPath
        }
    }

    process
    {
        . $LocalSetupPath '--help' | Out-String
    }

    end
    {
    }
}