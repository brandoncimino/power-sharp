function Import-CSharp(
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
    [string[]]
    $Path
) {
    BEGIN {
        $results = @{}
    }

    PROCESS {
        $csFiles = Get-ChildItem $Path -Recurse -Include '*.cs'

        foreach ($cs in $csFiles) {
            try {
                $results += @{
                    $cs = Add-Type -Path $cs -PassThru
                }
            }
            catch {
                Write-Warning "Unable to import class(es) from $($cs.name)"
                $results += @{
                    $cs = $_
                }
            }
        }
    }

    END {
        return $results
    }
}

function Import-PowerSharp() {
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