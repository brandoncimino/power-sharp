class HistoricalEvent {
    [string]$Name
    [DateTime]$Begin
    $End
    [string]$Details
    [int]$id

    HistoricalEvent(){}

    HistoricalEvent(
        [string]$Name,
        [DateTime]$Begin,
        $End,
        [string]$Details
    ){
        $this.Name = $Name
        $this.Begin = $Begin
        $this.End = $End
        $this.Details = $Details
    }

    HistoricalEvent(
        [string]$Name,
        [DateTime]$Date
    ){
        this($Name,$Date,$null,$null)
    }
}

function New-History(
    [Parameter(Mandatory)]
    [string]
    $Name,

    [Parameter(Mandatory, ParameterSetName="date")]
    [DateTime]
    $Date,

    [Parameter(ParameterSetName="date")]
    [TimeSpan]
    $Duration,

    [Parameter(Mandatory, ParameterSetName="bookend")]
    [DateTime]
    $Begin,

    [Parameter(Mandatory, ParameterSetName="bookend")]
    [DateTime]
    $End,

    $Details
){
    $historical_event = New-Object Event
    $historical_event.Name = $Name
    $historical_event.Details = $Details
    
    switch($PSCmdlet.ParameterSetName){
        "date" {
            $historical_event.Begin = $Date

            if($Duration){
                $historical_event.End = $Date + $Duration
            }
        }

        "bookend" {
            $historical_event.Begin = $Begin
            $historical_event.End = $End
        }
    }

    return $historical_event
}

enum RavnicanMonth {
    UNKNOWN = 0
    Selesnezi = 1
    Dhazo
    Prahz
    Mokosh
    Paujal
    Cizarm
    Tevnember
    Golgar
    Quaegar
    Xivaskir
    Griev
    Zuun
}

$BaseYear_Ravnica = 10076
$BaseYear_Gregorian = 2020
$YearOffset = $BaseYear_Ravnica - $BaseYear_Gregorian

function ConvertTo-RavnicanYear(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias("Year")]
    $GregorianYear
) {
    return $GregorianYear + $YearOffset
}

function ConvertTo-RavnicanMonth(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias("Month")]
    [int]$GregorianMonth
) {
    $ravnican_offset = $GregorianMonth + 10
    $ravnican_number = ($ravnican_offset % 12) + 1
    return [RavnicanMonth]$ravnican_number
}

function Format-RavnicanDate(
    [Parameter(ValueFromPipeline)]
    [DateTime]$GregorianDate,

    [switch]$IncludeTime
) {
    $rav_year_number = $GregorianDate | ConvertTo-RavnicanYear

    if ($rav_year_number -ge 1) {
        $rav_year = "$rav_year_number ZC"
    }
    else {
        $anti_year_number = ($rav_year_number -1) * -1;
        $rav_year = "$anti_year_number AC"
    }

    $rav_month = $GregorianDate | ConvertTo-RavnicanMonth

    $date_format = "dddd, '$rav_month' d, '$rav_year'"

    if($IncludeTime){
        $date_format += " hh:mm:ss tt"
    }

    return $GregorianDate.ToString($date_format)
}


