<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet

@("ls -la", "pwd") | Invoke-Cygwin
Invoke-Cygwin @("ls -la", "pwd")

Invoke-Cygwin -Script "ls -la", "pwd"
Invoke-Cygwin "ls -la", "pwd"
"ls -la", "pwd" | Invoke-Cygwin

Invoke-Cygwin -ScriptBlock { ls -la; pwd }
Invoke-Cygwin { ls -la; pwd }
{ ls -la; pwd } | Invoke-Cygwin


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
    [CmdletBinding(DefaultParameterSetName = "Lines", PositionalBinding = $true)]
    param (
        # Parameter help description
        [Parameter(ParameterSetName = "Lines", ValueFromPipeline = $true, ValueFromRemainingArguments = $true, Position = 0)]
        [string[]] $Script,

        # Parameter help description
        [Parameter(ParameterSetName = "ScriptBlock", ValueFromPipeline = $true, ValueFromRemainingArguments = $false)]
        [scriptblock] $ScriptBlock,

        [Parameter()]
        [Cygwin.InstallInfo] $CygwinEnvironment
    )

    begin
    {
        $selectedEnvironment = $CygwinEnvironment;
        if ($null -eq $selectedEnvironment)
        {
            # get latest of already installed
            $selectedEnvironment = Get-Cygwin | Sort-Object Timestamp -Descending | Select-Object -First 1;
        }
        if ($null -ne $selectedEnvironment)
        {
            Write-Verbose ('Selecting [{0}] as current environment.' -f $selectedEnvironment.Path);

            $executable = Join-Path -Path $selectedEnvironment.Path -ChildPath 'bin/bash.exe';
            # . "$RootDir\bin\bash.exe" --login -c $Script;
        }

        [array]$arguments = @('-c', "export PATH=/bin:/usr/bin:`$PATH`n");

        [array]$commandsToExecute = @();
    }

    process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'Lines'
            {
                $commandsToExecute += $Script;
            }
            'ScriptBlock'
            {
                $commandsToExecute += $ScriptBlock.ToString();
            }
        }
    }

    end
    {
        if ($null -ne $executable)
        {
            $arguments[1] += ("{0}" -f ($commandsToExecute -join "`n"));
            . $executable @arguments 2>&1
        }
    }

# SIG # Begin signature block
# MIIFXgYJKoZIhvcNAQcCoIIFTzCCBUsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUF8MViKYT4TzS6lEQnfzxcz1l
# P12gggL+MIIC+jCCAeKgAwIBAgIQPOk5qMHujKJIWIAsO7Qk9zANBgkqhkiG9w0B
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU86DTTbDBOaibZxCKUu2kJkXqElIw
# DQYJKoZIhvcNAQEBBQAEggEAku3EsfockpCHBc/4dxhmbNg2hFxTKklGG2herLgo
# XoH1zSRJQNiZ9/qWvZDBENGtw74y5t72w50A8MKqLIf0QygRfdTAhqD0VFd48rHn
# xqUEhjhUURrSNcNP0f0B12M35BDaBZpW7q3PhAUJnooN2NzBh4Je/BUkewcAndcY
# oSCHDO8SnFvx5geypbkmp824XSctUf5ewVpfcZFw42nNjGbomIT4aGcarb1UxYlM
# KlJ1RzNkUhbs8tpT3vOMdH4vppdyLz+J03aa8ntnb2aIWbTAl75MMHWM1iz5UH5g
# 5GIUFDI5xS8bpcY9ir6zn6C5CRphTRjxz4d17Tpu5zMWAw==
# SIG # End signature block
