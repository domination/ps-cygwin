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
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXRzwW5D892XYdxN/FY4wKvp7
# 6M2gggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBTl7j9LklnMD85K3B6v12vNubwNpDANBgkqhkiG9w0B
# AQEFAASCAQDIXF6coyFZqb9MMaMUoGkOouYPrHQ1Q7n0NQsIo7W6OxQvyBrX6Qqm
# YopYrBDBRO3FS0YbiV8lwRaLGnO9jOMSE2sLS0aOW46CvEIbfnTlp6L4Q2EIO7Un
# 6vr/KaoFu+9Xz9XQUQndZDMt/Qq4Nod0r9j0TPub9rHIpdQMfjkwNlQyiVnw7ZEt
# ED+9FluatfsW1KFlaTI/GyDpfmWK4BTDlUciPmRwHi/C9x8bin/1nzcR5NL7G5bk
# /HzhCyA51+FpC/tJmdPZGYIUUx3KGadai2xHr8bvd+8w5nV+Q/zeaG+kkc3r+8+4
# 380lvDSuZx/gheQz8U451rI78JHq+Mg/
# SIG # End signature block
