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
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURd872HrK7z1koXtd5mANCgUT
# IuagggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQURVNJcO9aes0fO7DU6musMV/yg3cw
# DQYJKoZIhvcNAQEBBQAEggEAV2CHmxgTRtYmU4CnO+2l3+bua6qVdwXmrbDbsw/s
# zoDZtA1OJizAkgZDkkJ2Md6mXlctIPfiMEtuxlNXt51QpLHQZG2NxCFIKPhr5xvm
# O8xrJxuHgAaFvPNaPLWg17fsigD8Swv226zJBRolIxBhtf+2YjQ2X3WO2ugaOvCn
# u2sf2EZi6J9mbE0kJlblf4jYSv78SJlKarfQzYTD/mL4fdaQ9W7X1uTKlb8xp+3U
# Pc/waZDBudceNkFql4EMXFveqFlTRfNG2pP5584TK4/YRB0warM+7O3DGV4IrHYo
# fpCuBehd0+mebsR5d6w+GUc551gDDDaXbMjHoO+zcqZ2ag==
# SIG # End signature block
