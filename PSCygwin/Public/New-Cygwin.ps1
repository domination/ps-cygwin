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
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGW4oR7O5aWfLddB9+Lwkdxqt
# 0mSgggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0yMDAzMTUwOTEwNTBaFw0zOTEyMzEyMzU5NTlaMBUxEzARBgNVBAMTCmRvbWlu
# YXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDctlfJa2xVJBNF
# fWOhk/h++cnl/tO5May7dmrFqqMjO1/C4zcCBIarkap31lj2Ky+427sOiH5GSRV7
# GvmjIOUYyabzDuo6N/O/Vuy4D3Dosn2JVQdvz6ZXPMfQBbtw2a0iOhsmxj143de1
# LKCLjDfnoyK2lcEnZmCcal0fdAAGFINNMkFed+9rlS2Qm1wqxjTQGVS0czXrVf1u
# uxGVgXFKKcW6v38GDe8Bkt/52z2XkNiNCKHkzDwVVL4ZAKBZ1BQnXTmUw4bI6eAX
# eU54BLpjITXFKdKT95iKb8UCqsKbPMYa8JA7mtxSKZGaM2ucRTn+sjCsTF/Jl+7q
# P3PGYt3NAgMBAAGjdjB0MBMGA1UdJQQMMAoGCCsGAQUFBwMDMF0GA1UdAQRWMFSA
# EFRLNfCSQeCkWjrGMLkdxfShLjAsMSowKAYDVQQDEyFQb3dlclNoZWxsIExvY2Fs
# IENlcnRpZmljYXRlIFJvb3SCEDIKl+Pl1/+LSwfpbD8Ti50wCQYFKw4DAh0FAAOC
# AQEAWathO3qne+05f5/fCGAMqfCbpr6praX+Z5S5Lqi9OfbKUVk5FUBvoKY1Nt61
# bRKf6PLB+u1tdWlxauORZvMh6zaxv/GbyefWdFsAoi6Y7rrIjG1hYde9H24gR+3e
# mZKjFnwJadygNbu5h42aPnhUkH+Mhw4OvU9IOKE7fqkDJo8ULHRIXA5CLDY5Zqh/
# WIi6+u7Vg4ARMLeJ98EQn6eka1b6nKihQ56zD45QLbUwNLM8XvI1BxL5uJH448Vs
# s10Z4uGYqZl5/+KDx82Sr3gQ9StlZ5JFw339VK3U7cmqnB2gZ4b/8trVuTY6F2jf
# HsDM5YGK6LhuZJC2UjBdFqZOKjGCAeEwggHdAgEBMEAwLDEqMCgGA1UEAxMhUG93
# ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290AhDQhKHJvulbh0eLWlfCmxcv
# MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3
# DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEV
# MCMGCSqGSIb3DQEJBDEWBBQaUkwOM/wRdSBa/i81swr4Ti063jANBgkqhkiG9w0B
# AQEFAASCAQBmOkA+tlAo5pOZje24YtHpJCaJmuGuIicsYxPzPAYNZJsqt+5yN1Nl
# 35rIDiHBbxGTrEXLS6qIANGaLLG0uQF8WAFgVLDw18fjEY4TA1yqdVnI7kww14OZ
# JhOP031YtLZmQ/n4Wk0gqPWiwCdkEuSiQWPO6DGVs0xGrJDS6RNryEXtWyyryPLR
# UDijYua4/FDcp1n4tBMvEM+JLnfdmSd84y8Q/OodNbpLvtBMg6yd2rgea/rdefwV
# wcDuoLk+9d3ki5wjMFA8BCubXSEMGQGSg6Ew2sslJRSAPucF+LLkGlGFjTWn7MQy
# FGHt/uaDSLhIlIxVHkkxA2mOyzEBrzdh
# SIG # End signature block
