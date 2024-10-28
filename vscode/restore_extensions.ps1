# Script for batch installing Visual Studio Code extensions

$extensions = Get-Content -Encoding "UTF8" -Path "$PSScriptRoot\backups\vscode_extensions_windows"
$installed = & "code" --list-extensions | Sort-Object

foreach ($ext in $extensions) {
    if ($installed.Contains($ext)) {
        Write-Verbose "$ext already installed."
        Write-Host "   [✔] $ext" -ForegroundColor green
    } else {
        try{
            &"code" --install-extension $ext >$null
            Write-Host "   [✔] $ext" -ForegroundColor green
        } catch{
            Write-Host "   [✖] $ext" -ForegroundColor red
        }
    }
}
