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
    . $_.FullName -ErrorAction Stop
}

# Update-FormatData -Prepend (Join-Path $PSScriptRoot '*.ps1xml')

# SIG # Begin signature block
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUygWoQ3zrtnQMaM9cTgIUzq4k
# lr6gggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUegO9OGYdLvvnzqdUrR8e7nfkvBkw
# DQYJKoZIhvcNAQEBBQAEggEAmmm7SayTZD/P+5O0dZR90TKC3T8r4BTDuYQnA3C+
# kgHtCtQX7u5piKNrsMWJIgUqFk4sKJYcd0zC4uf8u7X5KfP1461vNkGlmVLAlnr+
# zwebRQs08tbVK4WYn+/DIKedIECxvKMz0mRvXGLQmnlEO3Iu2rRvsdLcys5mHUxv
# do7MsINO0avWvz/WmkK0VOlSO3iCvX8a9ig/dJxTC+iJCZeUjDV2w24+gkdntrv+
# egR+x25nyw2+RsKBJajEkOiM4JZfOaiB+dGi8Ft6C6gj9VonubnpeZcXZp13d580
# ApEzAQ4t7s8JVSPQTF+wXWK+7bPGLar1ygDXg3b/7iIaPg==
# SIG # End signature block
