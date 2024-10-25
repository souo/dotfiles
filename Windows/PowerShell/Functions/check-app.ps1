function CountCrashDumps {
    [string]$path = Resolve-Path -Path "~\AppData\Local\CrashDumps"
    $files = (Get-ChildItem -path "$path\*.dmp" -attributes !Directory)
    return $files.Count
}

try {
    $status = "   [✔]"

    Write-Progress "Querying installed apps..."
    $apps = Get-AppxPackage
    Write-Progress -completed "Done."
    $reply = "$($apps.Count) Win apps installed"

    [int]$numNonOk = 0
    foreach ($app in $apps) { if ($app.Status -ne "Ok") { $numNonOk++ } }
    if ($numNonOk -gt 0) { $status = "   [✖]"; $reply += ", $numNonOk non-ok" }

    [int]$numErrors = (Get-AppxLastError)
    if ($numErrors -gt 0) { $status = "   [✖]"; $reply += ", $numErrors errors" }

    $numUpdates = (winget upgrade --include-unknown).Count - 5
    $reply += ", $numUpdates upgrades available"

    $numCrashDumps = CountCrashDumps
    if ($numCrashDumps -ne 0) { $status = "   [✖]"; $reply += ", $numCrashDumps crash dump(s) found" }

    Write-Host "$status $reply"
    exit 0 # success
}
catch {
    "   [✖] Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
