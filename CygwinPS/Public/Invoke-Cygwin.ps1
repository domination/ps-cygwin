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
        if ($null -eq $CygwinEnvironment)
        {
            # get latest of already installed
            $selectedEnvironment = Get-Cygwin | Sort-Object Timestamp -Descending | Select-Object -First 1;
            Write-Verbose ('Selecting [{0}] as current environment.' -f $selectedEnvironment.Path);
        }

        $executable = Join-Path -Path $selectedEnvironment.Path -ChildPath 'bin/bash.exe';
        # . "$RootDir\bin\bash.exe" --login -c $Script;

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
        $arguments[1] += ("{0}" -f ($commandsToExecute -join "`n"));
        . $executable @arguments 2>&1
    }
}
# SIG # Begin signature block
# MIIFtAYJKoZIhvcNAQcCoIIFpTCCBaECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBoOheP/HQ4Qoki+5972+eWl8
# heCgggM9MIIDOTCCAiWgAwIBAgIQ0IShyb7pW4dHi1pXwpsXLzAJBgUrDgMCHQUA
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
# MCMGCSqGSIb3DQEJBDEWBBQ8xuQJXNptQm2ihfHPTG8sjNahBzANBgkqhkiG9w0B
# AQEFAASCAQBUZGCSvPZ2KMHGMVLJLfgXOY35m+NcZG3ngX699jSRx2/+ljT2igxV
# XEEQM+vc7sJ/cOQ3pUoX+eUXxCk+PEMkveHf1M5zce2Se/ngVlbddMCFfyUJhLv2
# bRdcKcpNgBT4mu2ieDv2ZXZvjczdsX5nK+qDKMQTHxYmH3jW6WMX43saa58YkDjl
# KyduEUNoFweBlvh6NzSq13PIDCgpzB0Kfz/WZWHBAiMPGHb8FDDhWoPG91UlV9sn
# C7skel32+vtTkcSskEiP79UOoem/wc7cTkhPIJd2/8cIg7dbdLiI7Jl8eROOPqdc
# D4h4+tcL1zHGJIHpJjYSEUfcO7EUHWU2
# SIG # End signature block
