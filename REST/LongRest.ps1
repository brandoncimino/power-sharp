class RestApi {
    [System.Uri]$BaseUrl
    [string]$BasePath
    [string]$ApiVersion
    [string]$Endpoint
    [System.Collections.IDictionary]$Headers
    [System.Collections.IDictionary]$QueryParams

    hidden $_constructor = @(
        # Add the QueryString property
        $queryStringSplat = @{
            MemberType = "ScriptProperty"
            Name       = "QueryString"
            Value      = {
                $this.QueryParams | Format-QueryParameters
            }
        }
        $this | Add-Member @queryStringSplat

        # Add the UrlParts parameter
        $urlPartsSplat = @{
            MemberType = "ScriptProperty"
            Name       = "UrlParts"
            Value      = {
                $this.BaseUrl
                $this.BasePath
                $this.ApiVersion
                $this.Endpoint
            }
        }
        $this | Add-Member @urlPartsSplat

        # Add the FullUrl parameter
        $fullUrlSplat = @{
            MemberType = "ScriptProperty"
            Name       = "FullUrl"
            Value      = {
                
            }
        }
    )

    Invoke() {
        $restSplat = @{

        }
        Invoke-RestMethod -ur
    }
}

function Format-QueryParameters(
    [Parameter(ValueFromPipeline)]
    [System.Collections.IDictionary]
    $QueryParams
) {
    if ($null -eq $QueryParams) {
        return
    }

    $parts = $QueryParams.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$($_.Value)"
    }

    return $parts -join "&"
}

function Join-Url(
    [Parameter(ValueFromPipeline)]
    $PipelineParts,

    [Parameter(Position = 1)]
    $Parts
) {
    BEGIN {
        $allParts = @()
        $flatParamParts = $Parts | ForEach-Object { $_ }
    }

    PROCESS {
        $allParts += @($PipelineParts)
    }

    END {
        $allParts += @($flatParamParts)
        $trimmedParts = $allParts | ForEach-Object {
            $s = "$_"

            if (![string]::IsNullOrWhitespace($s)) {
                return $s.Trim("/")
            }
        }

        return $trimmedParts -join "/"
    }
}