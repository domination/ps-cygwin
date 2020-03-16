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
# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUi/Jy2Q8OOqZjIFgqpWne9Z1Q
# GWagggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBRqYQK7ItwxVYq4+ahpeNaH+wUvqjANBgkqhkiG9w0B
# AQEFAASCAQDEKfHR88pjj8jSkS/A46/jKMqm/9TLZZq664WhAFRyMCzn9NS23MCM
# cHWpGRQtqc0G13hRkHZj08alsF78GbkEwJFA/hXMHG0hI2Tvo5jQmPe3fZBQrW7L
# EcwoN4h7SK5TfsIn7JtjDOWzYzS53zFFHojKM/c3hRw30V4YTPNRjJRLPuyrRG6v
# EUHt1q6lLWZQuz9Hie/9BwKRB3iRVJrJxKbzb+Jh86RbgMq3NpWvZXFoXy3/490a
# TZdRFX1KIE8ig/onAvoIAJGwTB/52C0f3WLH16c5iR+Nvv/bxf/JvdEoo8UrJ9Vb
# +BwflLD13v29lY8SslZR1wOqQqUAkztc
# SIG # End signature block
