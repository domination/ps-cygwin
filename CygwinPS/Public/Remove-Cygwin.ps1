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
                    Remove-Item -Path $CygwinEnvironment.Path -Recurse -Force -ErrorAction Stop
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
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUz6cqFilHU79fh3KjHRIePKRG
# QiygggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUIo71JqJRvc0jT+/0nAzkoUbjYqIw
# DQYJKoZIhvcNAQEBBQAEggEAYiebL02hdNgzM/owX+BKd3OhhLoT0TpF4ttou9PS
# 9NdC6xrVnl93CzGpOF74d2SAn7LNBB9QxdfXc1U7Edj33yBbPaJzQig/FGLcKxE2
# 6fdykq3QxweLof4H7MQhI9GX+bJBuU5LpE4klGunMQpYMr3H3QKte2+q2nqqADGL
# vFfUeH+T8meimdxEoCNRNM8SzDfXvwqeWcWlgXmAVucmmGVLDqLmzQ8pR6dFL1DQ
# JiHG5zOVxff+udioIsWuPTzJZgeF2FWwOlZpWmG7YxU8wqW0bbvLcxSRAo1Ab1tN
# jSU40nIN+btQa33Iamc6WB2OxNoKJXEV/1vTCTUvn7uHKQ==
# SIG # End signature block
