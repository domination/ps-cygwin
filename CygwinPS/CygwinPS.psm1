Set-StrictMode -Version Latest

$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

$Script:PSModuleLocalTemp = Join-Path -Path $PSModuleRoot -ChildPath 'LocalTemp';

if (-not(Test-Path -Path $Script:PSModuleLocalTemp -PathType Container))
{
    try
    {
        New-Item -Path $Script:PSModuleLocalTemp -ItemType Directory -ErrorAction Stop
    }
    catch
    {
        throw $_;
    }
}

$public = Get-ChildItem -Path (Join-Path -Path $PSModuleRoot -ChildPath 'Public') -Filter '*.ps1';

$public | ForEach-Object {
    Import-Module $_ -ErrorAction Stop
}

# Update-FormatData -Prepend (Join-Path $PSScriptRoot '*.ps1xml')

# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWFZQXTZn/kWwiWHtd2TZtqaU
# ZDegggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBTxjktRNKDZ9qyV9Ag5qo1CDuEXUjANBgkqhkiG9w0B
# AQEFAASCAQAuol5L7HcqbLVibhQlNCozh1KERjiLUypiTduyIHDv3aGbBSWdN1gN
# WnJR3G+mlchiDQ18gIclLMaL18UqWFZSimIUBsx4+Ray6ikNhUxhygJW/WdpRVuf
# KknjNTzruQJjAq0SLz9IOvzbIKQFIcBpsCkVMtPAbc4yVoJE9bfixmyVd2LyIxl9
# OHHscXhHik6rA/BXyVeT2Tl4wu1TZSVPpbctTQGUy6+nQbncUuJK7sw2p9DKLxE9
# L20bKxZHqfxAawJoKyjPRPK4tSu721ac5ezqAR2+7qsm5zVK0a643WBD+e4cexSY
# mzN2C39A2CJrLrUv01HdE/3JLBxGOwVB
# SIG # End signature block
