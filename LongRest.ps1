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
            Name = "QueryString"
            Value = {
                $this.QueryParams | Format-QueryParameters
            }
        }
        $this | Add-Member @queryStringSplat

        # Add the UrlParts parameter
        $urlPartsSplat = @{
            MemberType = "ScriptProperty"
            Name = "UrlParts"
            Value = {
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
            Name = "FullUrl"
            Value = {
                
            }
        }
    )

    Invoke(){
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
    if($null -eq $QueryParams){
        return
    }

    $parts = $QueryParams.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$($_.Value)"
    }

    return $parts -join "&"
}

Join-Url(
    [Parameter(Position=1)]
    [string[]]$Parts
){

}