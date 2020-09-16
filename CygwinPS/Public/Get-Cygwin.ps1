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
        $hklm = @();
        # HKEY_LOCAL_MACHINE\SOFTWARE\Cygwin
        if (Test-Path -Path HKLM:\SOFTWARE\Cygwin)
        {
            $hklm = Get-ChildItem -Path HKLM:\SOFTWARE\Cygwin -Recurse -ErrorAction SilentlyContinue;
        }
        $hkcu = @();
        # HKEY_CURRENT_USER\Software\Cygwin
        if (Test-Path -Path HKCU:\SOFTWARE\Cygwin)
        {
            $hkcu = Get-ChildItem -Path HKCU:\SOFTWARE\Cygwin -Recurse -ErrorAction SilentlyContinue;
        }

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

        if (($null -ne $Path) -and ($Path.Count -gt 0))
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
# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURd872HrK7z1koXtd5mANCgUT
# IuagggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBRFU0lw71p6zR87sNTqa6wxX/KDdzANBgkqhkiG9w0B
# AQEFAASCAQA3ToOmn7UU1LzXdujgZBJEuCe4cCaqlWK5UegoVuo9fl488TNN4ywb
# yu+pDO/WebUbz9IRqveFCXfn7tWwnEOxFtzWwOK867aeto28/C6Its827sOTb8ak
# 63pdHLt9BVAmzy8/8m7rUcC63LvNfV/qNli60AF45tJA+FYAhngjwNF15f1JH86C
# IEyZhJ5oc26tVYHuZkBIyPDF8xgSR4zzuEHi7fVhH5lKyuvn3cfu/ekEuv5/rkPT
# PQprNnhbfnAw+Hx3o+n1UE26hqB3pIg11vC2FKO9PGaVOTuBZ7yC6IVnZBCvpaFk
# HrvLXBua9XnaiQakqyh84FRvko7pBhpX
# SIG # End signature block
