using namespace System.IO.Path

$Today = Get-Date -Day 30 -Month 10 -Year 2020

$TimelinePath = "$PSScriptRoot/RTRTRA.json"

function Load-Timeline(
    $Path = $TimelinePath
){
    $fromJson = Get-Content $Path | ConvertFrom-Json
    if($fromJson){
        $Global:Timeline = $fromJson
    }

    $Global:Timeline | sort Begin
}

Load-Timeline

function Save-Timeline(
    $Path = $TimelinePath
){
    # TODO: grab my file-name-suffix-changing-thing from work and use that to mark backups of the timeline.json
    $Global:Timeline | ConvertTo-Json -EnumsAsStrings -Depth 99 | Set-Content -Path $TimelinePath
}

function Save-Event(
    [Parameter(ValueFromPipeline)][HistoricalEvent]$HistoricalEvent
){
    $Global:Timeline.events += $HistoricalEvent
}

#region Events
# [HistoricalEvent]$bunsenBirth = [HistoricalEvent]::new()
# $bunsenBirth.Name = "Bunsen MKII is produced"
# $bunsenBirth.Begin = (Get-date).Subtract([Timespan]::FromDays(365*5.3))
# # $Global:Timeline.Events += @($bunsenBirth)

# [HistoricalEvent]$nhilloshRetires = [HistoricalEvent]::new()
# $nhilloshRetires.Name = "Nhillosh retires"
# $nhilloshRetires.Begin = $bunsenBirth.Begin.AddDays(365*2.6)
# $Global:Timeline.Events += @($nhilloshRetires)


#endregion