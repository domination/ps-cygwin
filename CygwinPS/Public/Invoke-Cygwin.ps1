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
    [CmdletBinding(PositionalBinding = $true)]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline = $true, ValueFromRemainingArguments = $true, Position = 0)]
        [scriptblock] $Script,

        [Parameter()]
        [Cygwin.InstallInfo] $CygwinEnvironment
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
        . $executable @('-c', ("export PATH=/bin:/usr/bin:`$PATH`n{0}" -f $Script)) 2>&1 | Out-String
    }

    end
    {
    }
}
# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvJFsEUF7UX8VXjBMm9kVojBR
# FeigggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBS617V6oqpJLkhhSCLMYTS20WNOEzANBgkqhkiG9w0B
# AQEFAASCAQCd3YlwzpkvSRrJ1ut1y0buigj+3IS6fT6UARd9p0ZMAE8p+s9YInAS
# fm9gVpwIrnxFD9LUpTDAohpqMA7npO6/+gdpJDvSyDRLhQzaar2xWQD30+oSO4aQ
# J474ifu70bvcxXF9azu/aCWxcVoWs46ef7U2VMgx5wLOg3SGGKk9sNA0Vsfs7N1d
# R7E6PAv3IVTPExmjqV30FYCpSNrYs8jpVKVPWfHh0320e1gghqpk5xBllSX+r0j5
# WmwT1vLsZRlFAEIUwP1cZy27P3dMPCAaC0v80bqClswcHIv36tuxeMPmCnlsLw2L
# Ek93PhkU/YOSIZ/oQaRtbnv3SKU/Lj5K
# SIG # End signature block
