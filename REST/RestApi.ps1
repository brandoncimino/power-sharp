using namespace System.Collections
using namespace Microsoft.Powershell.Commands

class RestApi {
    [System.Uri]$BaseUrl
    [string]$BasePath
    [string]$ApiVersion
    [string[]]$Endpoint
    [IDictionary]$Headers
    [IDictionary]$QueryParams
    [PSObject]$LastResponse
    [System.Management.Automation.ErrorRecord]$LastError
    [string]$Nickname

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
                return Build-Url -UrlParts $this.UrlParts -QueryParams $this.QueryParams
            }
        }
        $this | Add-Member @fullUrlSplat
    )

    [RestApi] Copy() {
        [RestApi]$copy = New-Object [RestApi]

        $copy.BaseUrl = $this.BaseUrl
        $copy.BasePath = $this.BasePath
        $copy.ApiVersion = $this.ApiVersion
        $copy.Endpoint = $this.Endpoint
        $copy.Headers = [hashtable]::new($this.Headers)
        $copy.QueryParams = [hashtable]::new($this.QueryParams)

        return $copy
    }

    [PSObject] Invoke(
        [WebRequestMethod]$Method,
        $Body
    ){
       return $this | Invoke-LongRest -Method $Method -Body $Body
    }

    [PSObject] Invoke(
        $Method
    ){
        return $this.Invoke($Method,$null)
    }

    [PSObject] Get (){
        return $this.Invoke([WebRequestMethod]::Get,$null)
    }

    [PSObject] Post (
        $Body
    ){
        return $this.Invoke([WebRequestMethod]::Post,$Body)
    }
}