Import-Module $PSScriptRoot\..\PowerShell\functions\Write-AnsiProgress.ps1 -force



for ($i=1; $i -le 10; $i++)
{
  $out =Write-ANSIProgress "$($i / 10)"
  Write-Host "`r$out" -NoNewline
  Start-Sleep -Milliseconds 100
}
Write-Host "`n"
