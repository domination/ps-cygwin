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
        [ulong]$Timestamp;
        # Collection of registry records about Path.
        [Registry[]] $Registry;

        InstallInfo([String] $Path, $Registry)
        {
            $this.Path = $Path;
            $this.Registry = $Registry;
            $this | Add-Member -MemberType ScriptProperty -Name 'Exists' -Value { Test-Path -Path $this.Path -PathType Container }

            if ($this.Exists)
            {
                $this.Timestamp = [ulong](Get-Content -Path (Join-Path -Path $this.Path -ChildPath 'etc/setup/timestamp') -ErrorAction SilentlyContinue);
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
