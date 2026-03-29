[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch] $UpdateDotbot,
    [Parameter(Mandatory, Position = 0)]
    [string[]] $Configs
)

$ErrorActionPreference = "Stop"

$BASE_CONFIG = "base"
$CONFIG_SUFFIX = ".yaml"
$META_DIR = "meta"
$CONFIG_DIR = "configs/windows"
$DOTBOT_DIR = "dotbot"
$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

Set-Location $BASEDIR

Write-Host "🚀 Initializing submodules..." -ForegroundColor Cyan

# Check if submodules are already initialized
$GitModulesPath = Join-Path $BASEDIR ".git/modules"
if ($UpdateDotbot) {
    Write-Host "🔄 Updating dotbot from remote..." -ForegroundColor Cyan
    git -C $DOTBOT_DIR submodule sync --quiet --recursive
    git submodule update --init --recursive $DOTBOT_DIR
} elseif (-not (Test-Path $GitModulesPath)) {
    git -C $DOTBOT_DIR submodule sync --quiet --recursive
    git submodule update --init --recursive $DOTBOT_DIR
} else {
    Write-Host "✨ Submodules already initialized, skipping fetch..." -ForegroundColor Green
}

# --- Find Python ---
foreach ($PYTHON in ('python', 'python3', 'FAIL')) {
    if (& { $ErrorActionPreference = "SilentlyContinue"; ![string]::IsNullOrEmpty((&$PYTHON -V)); $ErrorActionPreference = "Stop" }) { break }
}
if ($PYTHON -eq 'FAIL') { Write-Error "Error: Cannot find Python."; return }

# --- Prepare Combined Config ---
Write-Host "📦 Preparing unified configuration for standalone configs..." -ForegroundColor Cyan
$TempConfigFile = [IO.Path]::GetTempFileName()

try {
    $BaseConfigPath = Join-Path $BASEDIR "$META_DIR/$BASE_CONFIG$CONFIG_SUFFIX"
    if (-not (Test-Path $BaseConfigPath)) { Write-Error "Base config not found at $BaseConfigPath"; return }
    Get-Content $BaseConfigPath | Set-Content $TempConfigFile

    $ValidCount = 0
    foreach ($Config in $Configs) {
        $ConfigPath = Join-Path $BASEDIR "$META_DIR/$CONFIG_DIR/$Config$CONFIG_SUFFIX"
        if (Test-Path $ConfigPath) {
            Add-Content $TempConfigFile "`n# --- Fragment: $Config ---"
            Get-Content $ConfigPath | Add-Content $TempConfigFile
            $ValidCount++
        } else {
            Write-Warning "Configuration $Config not found at $ConfigPath. Skipping."
        }
    }

    if ($ValidCount -eq 0) { Write-Error "No valid configuration fragments found."; return }

    Write-Host "✨ Deploying $ValidCount standalone fragments via Dotbot..." -ForegroundColor Green

    # --- Run Dotbot ONCE ---
    $DotbotPath = Join-Path $BASEDIR "$DOTBOT_DIR/$DOTBOT_BIN"
    & $PYTHON $DotbotPath -d $BASEDIR -c $TempConfigFile
}
finally {
    if (Test-Path $TempConfigFile) { Remove-Item $TempConfigFile -Force }
}

Write-Host "`n✅ Finished standalone installation!" -ForegroundColor Green
