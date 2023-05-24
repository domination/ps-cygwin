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
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter()]
        [string] $Path,

        [Parameter()]
        [string[]] $Packages,

        [Parameter()]
        [string] $LocalPackageRepository,

        [Parameter()]
        [uri[]] $MirrorSite,

        # Parameter help description
        [Parameter()]
        [ValidateSet('x86_64', 'x86')]
        [string] $Architecture = 'x86_64',

        # Parameter help description
        [Parameter()]
        [uri] $SetupBaseUrl = 'https://cygwin.com/',

        # Parameter help description
        [Parameter()]
        [string] $SetupBaseFileName = 'setup-{0}.exe',

        # Parameter help description
        [Parameter()]
        [switch] $ForceDownload,

        # Parameter help description
        [Parameter()]
        [switch] $AsAdministrator
    )

    begin
    {
        $SetupFileName = $SetupBaseFileName -f $Architecture;
        $LocalSetupPath = Join-Path -Path $Script:PSModuleLocalTemp -ChildPath $SetupFileName;

        if (Test-Path -Path $LocalSetupPath -PathType Leaf)
        {
            Write-Verbose -Message ('Local setup file exists [{0}]' -f $LocalSetupPath);
        }

        if ($ForceDownload -or -not(Test-Path -Path $LocalSetupPath -PathType Leaf))
        {
            $DownloadUri = [uri]::new($SetupBaseUrl, $SetupFileName);
            Write-Verbose -Message ('Setup file will be downloaded from [{0}] and save as [{1}]' -f $DownloadUri, $LocalSetupPath);

            if ($PSCmdlet.ShouldProcess($LocalSetupPath, ('Download from {0}' -f $DownloadUri)))
            {
                Invoke-WebRequest -Uri $DownloadUri -DisableKeepAlive -OutFile $LocalSetupPath
            }
        }
    }

    process
    {
        # . $LocalSetupPath '--help' | Out-String

        $parameters = @(
            '--arch', $Architecture,
            '--no-shortcuts',
            '--quiet-mode'
        );

        if (-not($AsAdministrator))
        {
            $parameters += @('--no-admin');
        }

        if (-not([string]::IsNullOrEmpty($Path)))
        {
            $parameters += @('--root', $Path);
        }
        else
        {
            $lastPath = Get-Cygwin | Where-Object { $_.Registry.Name -eq 'rootdir' } | Select-Object -ExpandProperty Path;
            if ($null -ne $lastPath)
            {
                $parameters += @('--root', $lastPath);
            }
        }

        if (-not([string]::IsNullOrEmpty($LocalPackageRepository)))
        {
            $parameters += @('--local-package-dir', $LocalPackageRepository);
        }

        if (($null -ne $MirrorSite) -and ($MirrorSite.Count -gt 0))
        {
            $parameters += @('--only-site', '--site', ($MirrorSite -join ','));
        }

        if (($null -ne $Packages) -and ($Packages.Count -gt 0))
        {
            $parameters += @('--packages', ($Packages -join ','));
        }

        Write-Verbose ('command line options: {0}' -f ($parameters -join ' '));

        if ($PSCmdlet.ShouldProcess(('{0}' -f $LocalSetupPath), 'Run Cygwin installer'))
        {
            # & $LocalSetupPath @parameters 2>&1 | Out-String;
            Start-Process -FilePath $LocalSetupPath -Args $parameters -WindowStyle Hidden -Wait;
        }
        else
        {
            Write-Host ('To install run: {0} {1}' -f $LocalSetupPath, ($parameters -join ' '));
        }
    }

    end
    {
    }
}
# SIG # Begin signature block
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmCd2h5eL1sLsp2uwzIG7mR74
# qgagggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
# AQsFADAVMRMwEQYDVQQDDApkb21pbmF0aW9uMB4XDTIzMDUyNDAwNTAyM1oXDTI0
# MDUyNDAxMTAyM1owFTETMBEGA1UEAwwKZG9taW5hdGlvbjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAMDYLgWqa3w5pMNPQ3gRVbpo+eOis8Ivljaz7Fm4
# CIVTQNZX/2KKnqnkxFy2OpPrufDSHiK9mA7FQR1+6o/VJg2Jn55m/oMg/1RcFoT1
# PYa72h+dispj10XyxI84bhAOsLtBp413nfzcFlaYUb1ZBDNMVqJjJEQAfc/GmSKq
# RlmireDMReXc+c0hrvXfOyovoRcMsOoG7cPRVHxlQSMTynUWZsKiiEFoFwnfpc/k
# zZJr15hAod64gJUy+h0vfusIsFGnOf9FCmFSX+2Xa36y0oEJNxiysXCFsPu2ZIiP
# qKg7jfmFzJ8Mipsb33eS5Plmq9w9zkEWKpQwK8japeuml7kCAwEAAaNGMEQwDgYD
# VR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRqVyQh
# 7zFy3sHlPYPeG96rKKxmkzANBgkqhkiG9w0BAQsFAAOCAQEAeLCMdveF82CsGRlD
# xaygNW2ST4I1RJVZla5D3sw7sVMKhXiWM8AwS7+t+OIlaTkXA/zNP8t+M82WhtGP
# 939bwpzzQUrzTs+d+3QOiAbsELmka/CHqnzH4gOZAApV0wXyxl3/Y/aP653U2RI/
# mSHV6RLU+ShqRhB6p/sGXS+aN6dxwb+0Kpl7o511h49HniMOt+jSn1o51uIrV0u4
# mN13wApW47oCiay5SOaqffupf29f9Rj5DwCeTvDzKepf5h+OTEEFrVvcstsGh7hK
# FnCUSriQHjMSCzGfjG0EKJhx150q22YnuC7xD2mvWb/3Gf5TU0axf7AbDV5O46zT
# 4Qr7djGCAcowggHGAgEBMCkwFTETMBEGA1UEAwwKZG9taW5hdGlvbgIQPOk5qMHu
# jKJIWIAsO7Qk9zAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUyMiRPC5V3e0SUWtMRqhoAlejJFkw
# DQYJKoZIhvcNAQEBBQAEggEAFcakG2yLobTZv5xzsv9EDi1vh515ycv+YH7ZaQIh
# HD0izEopx0CSnmcJw68yYdn1fOYGpCXTjj/2RxU/wObj9I1kr18XgC29k8IH5KbN
# 7liuIyjv7mnz0HfZFmhYA70zyhoOmzDReHkR5p/JO4lmhfYyR8eeyP5nuHoQXaf4
# QS6upk/Z6aHGgORimUi8pr0+YsDsQt802k+o6CEQnigtfFF4jRUfawF715F3lPdW
# ir+vyg64phDWH/aVckLI9Z887gYTz1m8+jf4BevfebclzRqK6im7RMLdM13kPAi5
# 84Tw6/2zAuTXKafRduN4rUFfoag0fg4TnCp1a/N87+qLhw==
# SIG # End signature block
