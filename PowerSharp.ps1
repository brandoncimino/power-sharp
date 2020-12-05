function Import-CSharp(
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=1)]
    [string[]]
    $Path
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

function Import-PowerSharp(){
    Import-CSharp $PowerSharpDir
}

function Get-Type(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$TypeName
) {
    PROCESS {
        return [System.Management.Automation.PSTypeName]$TypeName
    }
}