$Global:Scryfall = New-Object RestApi

$Global:Scryfall.BaseUrl = "https://api.scryfall.com"
$Global:Scryfall.Endpoint = "cards","named"
$Global:Scryfall.QueryParams += @{"exact" = "Vraska, Golgari Queen"}
$Global:Scryfall.Nickname = "Scryfall"