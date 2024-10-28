function Show-Spinner {

    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a scriptblock",
            ValueFromPipeline
        )]
        [Alias("sb")]
        [scriptblock]$Expression,

        [ValidateRange(10, 5000)]
        [Alias("sleep")]
        [double]$Interval = 200,


        [Parameter(Mandatory, HelpMessage = "Specify a Message.")]
        [ValidateNotNullOrEmpty()]
        [Alias("msg")]
        [string] $Message,


        [Parameter(Mandatory, HelpMessage = "Specify message color .")]
        [Alias("color")]
        [system.consolecolor] $MsgColor

    )


    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

    }


    process {
        Write-Verbose ($PSBoundParameters | Out-String)
        Write-Verbose "Expression:"
        Write-Verbose ($Expression | Out-String)


        Write-Verbose "Running as a background job"
        Write-Verbose "Show-Spinner with interval: ${Interval}ms."

        $job= Start-Job -ScriptBlock $Expression
        # saved cursor position
        $saved = $host.UI.RawUI.CursorPosition
        $i=0
        $Symbols = @("/", "-", "\", "|")
        $count = $Symbols.Count;
        [System.Console]::CursorVisible = $false
        while ($Job.State -eq "Running"){
            $Symbol = $Symbols[$i % $count]
            $i++;

            Write-Host -NoNewline "    [$Symbol] $Message" -ForegroundColor $MsgColor
            [System.Console]::SetCursorPosition($saved.X, $saved.Y)
            Start-Sleep -Milliseconds $Interval
        }
        Write-Host -NoNewline "`r"
        [System.Console]::SetCursorPosition($saved.X, $saved.Y)

        # $Output = Receive-Job $Job

        if ($LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq -1) {
            Write-Error "Error"
        }
    }

    end {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}
