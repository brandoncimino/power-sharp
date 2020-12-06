using namespace System.Collections

function Merge-Map(
    [Parameter(ValueFromPipeline)]
    [IDictionary]$Left,

    [Parameter(Position = 1)]
    [IDictionary]$Right,

    [ValidateSet("Left", "Right")]
    $Prefer = "Right",

    [ValidateSet("Left", "Right")]
    $First = "Left"
) {
    PROCESS {
        if ($null -eq $Left) {
            return $Right
        }

        if ($null -eq $Right) {
            return $Le
        }

        $first_map = $First -eq "Left" ? $Left : $Right
        $second_map = $First -eq "Left" ? $Right : $Left

        $preferred_map = $Prefer -eq "Left" ? $Left : $Right
        $deferred_map = $Prefer -eq "Left" ? $Right : $Left

        $merged_map = [Ordered]@{}
        $all_keys = ($first_map.Keys + $second_map.Keys) | Select-Object -Unique

        foreach ($key in $all_keys) {
            $val = $preferred_map.Contains($key) ? $preferred_map[$key] : $deferred_map[$key]
            $merged_map += @{$key = $val }
        }

        return $merged_map
    }
}