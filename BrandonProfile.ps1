#region Namespaces
using namespace System.IO
using namespace PowerSharp
#endregion

Write-Host -ForegroundColor Green "Importing BrandonProfile.ps1"

#region Variables
$ProfileHome = [Path]::GetDirectoryName($Profile)
$PowerSharpDir = "$ProfileHome/power-sharp"
#endregion

#region Sources
. $PowerSharpDir/REST/LongRest.ps1
. $PowerSharpDir/PowerSharp.ps1
#endregion

#region Aliases
New-Alias -Name psharp -Value Import-PowerSharp
#endregion

#region Startup

#endregion