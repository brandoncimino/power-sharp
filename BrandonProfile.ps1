#region Namespaces
using namespace System.IO
using namespace PowerSharp
#endregion

$ProfileHome = $PSScriptRoot
$PowerSharpDir = "$ProfileHome/PowerSharp"

function Import-PowerSharp(
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Path = $PowerSharpDir
) {
    BEGIN {
        $results = @{}
    }

    PROCESS {
        $csFiles = Get-ChildItem $Path -Recurse -Include '*.cs'

        foreach ($cs in $csFiles) {
            Add-Type -Path $cs
        }
    }
}

New-Alias -Name psharp -Value Import-PowerSharp

function Find-Type(
    [Parameter(ParameterSetName = "TypeName", Position = 1)]
    [string]$TypeName

    # [Parameter(ParameterSetName="Class")]
    # [Type]$Type
) {
    if (([System.Management.Automation.PSTypeName]$TypeName).Type) {
        return $true;
    }

    return $false;
}

#region Startup

#endregion