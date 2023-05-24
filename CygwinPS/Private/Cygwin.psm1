function Cygwin
{
    class Package
    {
        [string]$Name;
        [string]$Version;
        [string]$File;

        Package([string]$Name)
        {
            $this.Name = $Name;
        }

        static [Package] FromInstalled([string]$Installed)
        {
            $package = $null;
            $parts = @($Installed -split '\ ');
            if ($parts.Count -ge 3)
            {
                $package = [Package]::new($parts[0]);
                $package.File = $parts[1];
                $package.Version = $parts[1] -replace ('^{0}-' -f ($parts[0] -replace '\+', '\+')), '' -replace '\.tar\.bz2$', '';
            }
            return $package;
        }
    }

    class Registry
    {
        # Path to key in registry.
        [string] $Path;
        # Property name.
        [string] $Name;
        # Property value.
        [string] $Value;

        [string] ToString()
        {
            if ($this.Path.StartsWith('HKEY_CURRENT_USER'))
            {
                return 'U:{0}' -f $this.Name;
            }
            return 'M:{0}' -f $this.Name;
        }
    }

    class InstallInfo
    {
        # Path to cygwin environment.
        [string] $Path;
        # Timestamp from '/etc/setup/timestamp'
        [uint64]$Timestamp;
        # Collection of registry records about Path.
        [Registry[]] $Registry;

        InstallInfo([String] $Path, $Registry)
        {
            $this.Path = $Path;
            $this.Registry = $Registry;
            $this | Add-Member -MemberType ScriptProperty -Name 'Exists' -Value { Test-Path -Path $this.Path -PathType Container }

            if ($this.Exists)
            {
                $this.Timestamp = [uint64](Get-Content -Path (Join-Path -Path $this.Path -ChildPath 'etc/setup/timestamp') -ErrorAction SilentlyContinue);
                $this.ReadSetupRc();
            }
        }

        [void] ReadSetupRc()
        {
            # last-cache
            # last-mirror
            # net-method
            # last-action
            # mirrors-lst
            $setupRCPath = Join-Path -Path $this.Path -ChildPath 'etc/setup/setup.rc';
            if (Test-Path -Path $setupRCPath -PathType Leaf)
            {
                $key = $null;
                $options = Get-Content -Path $setupRCPath | ForEach-Object {
                    if ($_ -notmatch '^\t+|^\ +')
                    {
                        $key = $_.Trim();
                    }
                    else
                    {
                        [pscustomobject]@{
                            Option = $key;
                            Value  = $_.Trim();
                        };
                    }
                };
                $options | Group-Object Option | ForEach-Object {
                    $this | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Group.Value;
                }
            }
        }

        [Package[]] GetInstalledPackages()
        {
            [array]$results = @();
            if ($this.Exists)
            {
                $installedPath = Join-Path -Path $this.Path -ChildPath 'etc/setup/installed.db';
                if (Test-Path -Path $installedPath -PathType Leaf)
                {
                    Get-Content -Path $installedPath | Select-Object -Skip 1 | ForEach-Object {
                        $package = [Package]::FromInstalled($_);
                        if ($null -ne $package)
                        {
                            $results += $package;
                        }
                    }
                }
            }
            return $results;
        }
    }
}
# SIG # Begin signature block
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXRzwW5D892XYdxN/FY4wKvp7
# 6M2gggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU5e4/S5JZzA/OStwer9drzbm8DaQw
# DQYJKoZIhvcNAQEBBQAEggEAggdYemReTefgXRFbCVdDYYdlnSkGIIq1rEfZ364f
# ETKdedA7x0tjNg5PddbupIlbvrR27qUttYuBmZzyAvVnOp08IMt/sDZ7FBsbf+yz
# jvTwdlfJmZuRMqFoq91kgxdLFbbXpwnMLTr2p11GOG2euyJQhuWHZQWUM96Gj/K3
# J/M3Y19ly1HUgRW2i5hHLxpLIjcQKmF+M9GoCfhEIvEo4/CEmE1mO3FovSeFs3NE
# hAKs7oeGOCyOg5ZY5f+V9GTkm5V8N3+BHzMU1bWld7OtRNwuY4Cxtoha3aNE+L4i
# scTXBcPbq1/82PGShToXVFVLRfykwsRnpjYzsvkJhh9Ssw==
# SIG # End signature block
