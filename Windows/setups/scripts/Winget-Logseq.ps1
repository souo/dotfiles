[CmdletBinding()]
param()

$ReadableName = "Logseq"
$AppId = "Logseq.Logseq"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
