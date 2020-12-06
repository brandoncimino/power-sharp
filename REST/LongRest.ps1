using namespace System.Collections
using namespace Microsoft.Powershell.Commands

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

function Build-Url(
    [string[]]$UrlParts,
    [IDictionary]$QueryParams
) {
    $url = $UrlParts | Join-Url
    $queryString = Format-QueryParameters $queryParams
    return ($url, $queryString) -join "?"
}

function Invoke-LongRest {
    PARAM (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Uri]$BaseUrl,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BasePath,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ApiVersion,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$Endpoint,

        [Parameter(ValueFromPipelineByPropertyName)]
        [IDictionary]$Headers,

        [Parameter(ValueFromPipelineByPropertyName)]
        [IDictionary]$QueryParams,

        [Parameter(ValueFromPipelineByPropertyName)]
        [WebRequestMethod]$Method = [WebRequestMethod]::Get,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Object]$Body,

        [Parameter(ValueFromPipeline)]
        [RestApi]$Api,

        [switch]$LogEverything
    )

    PROCESS {
        if ($Api) {
            # Combined stuff
            $Headers = $Api.Headers | Merge-Map $Headers -Prefer Right
            $QueryParams = $Api.QueryParams | Merge-Map $QueryParams -Prefer Right
        }

        $url_parts = @(
            $BaseUrl,
            $BasePath,
            $ApiVersion,
            $Endpoint
        ) | ForEach-Object { $_ }

        $url_full = Build-Url -UrlParts $url_parts -QueryParams $QueryParams
    
        if ($LogEverything) {
            [ordered]@{
                BaseUrl     = $BaseUrl
                BasePath    = $BasePath
                ApiVersion  = $ApiVersion
                Endpoint    = $Endpoint
                Headers     = $Headers
                QueryParams = $QueryParams
                Method      = $Method
                Body        = $Body
                Api         = $Api
                url_full    = $url_full
            } | Out-String | Write-Host
        }

        $rest_splat = @{
            Uri     = $url_full
            Headers = $Headers
            Method  = $Method
            Body    = $Body
        }
        
        try {
            $Response = Invoke-RestMethod @rest_splat

            Write-Host -ForegroundColor Green "REST request successful! Storing the response as `$Global:LastRest"
            $Global:LastRest = $Response
        
            if ($Api) {
                $Api.LastResponse = $Response
            }

            return $Response
        }
        catch {
            Write-Host -ForegroundColor Red "The REST request failed! Storing the error as `$Global:LastRestError"
            $Global:LastRestError = $_

            if($Api){
                $Api.LastError = $_   
            }

            throw $_
        }
    }
}