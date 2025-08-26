# Profile.ps1
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# Aliases 🔗
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name cat -Value bat
Set-Alias -Name touch -Value New-File
Set-Alias -Name us -Value Update-Software
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name vsc -Value CodeOpenCurrent
Set-Alias dk docker
Set-Alias -Name loc -Value tokei
Set-Alias -Name which -Value Get-Command
Set-Alias -Name grep -Value Select-String

# Functions 🎉
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


Function CodeOpenCurrent { code . }
function Find-DotsRepository {
    <#
    .SYNOPSIS
        Finds the local Windots repository.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProfilePath
    )

    Write-Verbose "Resolving the symbolic link for the profile"
    $profileSymbolicLink = Get-ChildItem $ProfilePath | Where-Object FullName -EQ $PROFILE.CurrentUserAllHosts
    return $profileSymbolicLink.Target | Split-Path | Split-Path | Split-Path
}
function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    Write-Verbose "Updating software installed via Winget & Chocolatey"
    sudo cache on
    sudo winget upgrade --all --include-unknown --silent --verbose
    sudo choco upgrade all -y
    sudo -k
    $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
}


function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}


# Environment Variables 🌐
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$ENV:DotsLocalRepo = Find-DotsRepository -ProfilePath $PSScriptRoot
# $ENV:_ZO_DATA_DIR = $ENV:DotsLocalRepo
$ENV:BAT_CONFIG_DIR = "$ENV:DotsLocalRepo\config\bat"
$ENV:FZF_DEFAULT_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="border-rounded" --height 40% --preview="bat -n --color=always {}"'
$ENV:_ZO_FZF_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="hidden" --height 20%'
$ENV:FNM_NODE_DIST_MIRROR = 'https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/'
$ENV:NODE_MIRROR = 'https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/'
$ENV:NVM_NODEJS_ORG_MIRROR = 'https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/'

. (Join-Path -Path $ENV:DotsLocalRepo -ChildPath "PowerShell\functions\Git\Remove-MergedGitBranch.ps1" )
. (Join-Path -Path $ENV:DotsLocalRepo -ChildPath "PowerShell\functions\Console\Out-Copy.ps1" )
. (Join-Path -Path $ENV:DotsLocalRepo -ChildPath "PowerShell\functions\General\Get-MyAlias.ps1" )
. (Join-Path -Path $ENV:DotsLocalRepo -ChildPath "PowerShell\functions\General\ssh-copy-id.ps1" )

# Prompt & Shell Configuration 🐚
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Start-ThreadJob -ScriptBlock {
    $wingetUpdatesString = Start-Job -ScriptBlock { winget list --upgrade-available | Out-String } | Wait-Job | Receive-Job
    $chocoUpdatesString = Start-Job -ScriptBlock { choco upgrade all --noop -y | Out-String } | Wait-Job | Receive-Job
    if ($wingetUpdatesString -match "upgrades available" -or $chocoUpdatesString -notmatch "can upgrade 0/") {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = " "
    }
    else {
        $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
    }
} | Out-Null

Invoke-Expression (& { ( zoxide init powershell  | Out-String ) })

#fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

$colors = @{
    "Operator"         = "`e[35m" # Purple
    "Parameter"        = "`e[36m" # Cyan
    "String"           = "`e[32m" # Green
    "Command"          = "`e[34m" # Blue
    "Variable"         = "`e[37m" # White
    "Comment"          = "`e[38;5;244m" # Gray
    "InlinePrediction" = "`e[38;5;244m" # Gray
}

Set-PSReadLineOption -Colors $colors
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key Alt+l
Import-Module -Name CompletionPredictor


oh-my-posh init pwsh --config "$ENV:DotsLocalRepo/config/zsh/pure.omp.json" | Invoke-Expression


# Skip fastfetch for non-interactive shells
if (-Not ([Environment]::GetCommandLineArgs().Contains("-NonInteractive"))) {
    fastfetch
}
