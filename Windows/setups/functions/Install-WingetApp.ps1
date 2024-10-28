Import-Module $PSScriptRoot\Show-Spinner.ps1 -force

function Install-WingetApp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ReadableName,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $AppId,

        [Parameter(Position = 2)]
        [string] $AppArgs

    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process{

        if (Confirm-Install($AppId)){
            Write-Verbose  "$AppId already Installed"
            Write-Host "   [✔] $ReadableName" -ForegroundColor green
            Return
        }
        $wingetArgs = "--id $AppId -e --accept-package-agreements --accept-source-agreements -s winget -h $AppArgs"
        $sb = [scriptblock]::Create("winget install $wingetArgs")
        try{
            Show-Spinner $sb -msg $ReadableName -color green >$null 2>&1

            #Check if install is ok
             $IsInstalled = Confirm-Install $AppID

            if ($IsInstalled){
                Write-Host "   [✔] $ReadableName  " -ForegroundColor green
             } else{
                Write-Host "   [✖] $ReadableName  " -ForegroundColor red
             }
        }
        catch {
            $string_err = $_ | Out-String
            Write-Host "   [✖] $ReadableName  " -ForegroundColor red
        }
        #endregion Installer

    }

    end {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}


#Check if app is installed
function Confirm-Install ($AppID) {
    #Get "Winget List AppID"
    $InstalledApp = & "winget" list --Id $AppID | Out-String

    #Return if AppID exists in the list
    if ($InstalledApp -match [regex]::Escape($AppID)) {
        return $true
    }
    else {
        return $false
    }
}
