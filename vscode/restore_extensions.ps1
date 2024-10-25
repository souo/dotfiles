# Script for batch installing Visual Studio Code extensions

$extensions = @(
    "antfu.icons-carbon"
	"antfu.theme-vitesse"
	"eamodio.gitlens"
	"editorconfig.editorconfig"
	"esbenp.prettier-vscode"
	"ms-vscode-remote.remote-containers"
	"ms-vscode-remote.remote-ssh"
	"ms-vscode-remote.remote-ssh-edit"
	"ms-vscode-remote.remote-wsl"
	"ms-vscode-remote.vscode-remote-extensionpack"
	"ms-vscode.makefile-tools"
	"ms-vscode.powershell"
	"ms-vscode.remote-explorer"
	"ms-vscode.remote-server"
	"pkief.material-icon-theme"
	"usernamehw.errorlens"

)

$cmd = "code --list-extensions"
Invoke-Expression $cmd -OutVariable output | Out-Null
$installed = $output -split "\s"

foreach ($ext in $extensions) {
    if ($installed.Contains($ext)) {
        Write-Host $ext "already installed." -ForegroundColor Gray
    } else {
        Write-Host "Installing" $ext "..." -ForegroundColor White
        code --install-extension $ext
    }
}
