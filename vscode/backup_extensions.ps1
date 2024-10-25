# Backup vscode extensions, generate a ps script file to restore it.
code --list-extensions | Sort-Object | Out-File -FilePath $PSScriptRoot\backups\vscode_extensions_windows-Encoding 'UTF8'
