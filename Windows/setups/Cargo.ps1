[CmdletBinding()]
param()


. $PSScriptRoot\functions\Show-Spinner.ps1
function Install-App {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ReadableName,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $AppName

    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {

        if (CommandExists $AppName) {
            Write-Verbose  "$AppName already Installed"
            Write-Host "   [✔] $ReadableName" -ForegroundColor green
            Return
        }
        $sb = [scriptblock]::Create("cargo install $AppName")
        try {
            Show-Spinner $sb -msg $ReadableName -color green >$null 2>&1

            #Check if install is ok
            $IsInstalled = CommandExists $AppName

            if ($IsInstalled) {
                Write-Host "   [✔] $ReadableName  " -ForegroundColor green
            }
            else {
                Write-Host "   [✖] $ReadableName  " -ForegroundColor red
            }
        }
        catch {
            $_ | Out-String
            Write-Host "   [✖] $ReadableName  " -ForegroundColor red
        }
        #endregion Installer

    }

    end {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}


# Function to check if a command exists
function CommandExists {
    param (
        [string]$command
    )
    $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}


# Define the list of apps to be installed
$apps = @("fnm", "tealdeer")


# Check if Cargo is installed
if (CommandExists "cargo") {
    foreach ($app in $apps) {
        Install-App  $app  $app
    }
}
