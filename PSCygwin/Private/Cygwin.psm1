class Registry
{
    # Path to key in registry.
    [string] $Path;
    # Property name.
    [string] $Name;
    # Property value.
    [string] $Value
}

class InstallInfo
{
    # Path to cygwin environment.
    [string] $Path;
    # Collection of registry records about Path.
    [Registry[]] $Registry;
}
