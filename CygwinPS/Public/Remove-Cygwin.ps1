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
                try
                {
                    Remove-Item -Path $CygwinEnvironment.Path -Recurse -ErrorAction Stop
                }
                catch
                {
                    Write-Error ('Cannot remove: [{0}]' -f $CygwinEnvironment.Path);
                }
            }
            else
            {
                Write-Host ('Remove: [{0}]' -f $CygwinEnvironment.Path);
            }
        }

        if (-not($CygwinEnvironment.Exists))
        {
            $CygwinEnvironment.Registry | ForEach-Object {
                $reg = $_;
                $registryItemPath = $reg.Path -replace '^HKEY_CURRENT_USER', 'HKCU:' -replace '^HKEY_LOCAL_MACHINE', 'HKLM:';
                $registryItem = Get-ItemProperty -Path $registryItemPath -Name $reg.Name -ErrorAction SilentlyContinue;
                if ($null -ne $registryItem)
                {
                    if ($PSCmdlet.ShouldProcess(('{0}\{1}' -f $reg.Path, $reg.Name), 'Delete'))
                    {
                        try
                        {
                            Remove-ItemProperty -Path $registryItemPath -Name $reg.Name -ErrorAction Stop;
                        }
                        catch
                        {
                            Write-Warning ('Cannot remove from registry: [{0}] {1}' -f $reg.Path, $reg.Name);
                            if ($PSCmdlet.ShouldProcess("aa", "bb", "cc"))
                            {
                                try
                                {
                                    $scriptBlock = "Remove-ItemProperty -Path $registryItemPath -Name $($reg.Name) -ErrorAction Stop";
                                    Start-Process -FilePath (Get-Process -id $pid).Path -ArgumentList ('-Command &{{ {0} }}' -f $scriptBlock) -Verb RunAs -Wait -ErrorAction Stop
                                }
                                catch
                                {
                                    Write-Error ($_.Exception.Message);
                                }
                            }
                        }
                    }
                    else
                    {
                        Write-Host ('Remove: [{0}]' -f $CygwinEnvironment.Path);
                    }
                }
            }
        }
    }
}
# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxo4JdZ1CWLpm2xjoByO5KQXr
# yoagggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBTrIpGII0MFPmq0Gr8i3QKPYhjCrjANBgkqhkiG9w0B
# AQEFAASCAQDIj4dSNfHYUDrBAbhNfuUg3N1ykQ3IRma0HFj7zcCclQ3LbEgYngM0
# k/IGAGXPAsExQkAcLZ8an+Bs7D6FZ0Urz68b5bKuGG9JpqD3MSmbn7TwYRotO7Ky
# wvOOBK1PTtlvhz+Go30XrHEGkQ9zddqtqcXyc3PwO2nRrr4jnqqYUKgYK2emt8+0
# DyteNlob9oSPj+D7SFCI/tbp4vHp+Ny0HNvz8gg7Uk1UdZ5bITkdpA0Baqswso+b
# 3ww2qCyW3PT939DfEOAfUK/YI+YoiqHejoLjIR/YtZWYpEAvGWwvRcycHsR+/R72
# BjDcvrfGVQkUGwgPQjBqa5eJH7OxH82D
# SIG # End signature block
