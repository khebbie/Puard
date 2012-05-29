function New-Puard {
    param(
        [string]$PuardName,
        [scriptblock]$ScriptBlock
    )

    function New-PuardAction {
        param (
            [string]$Pattern,
            [scriptblock]$Action,
            [string]$Name
        )
        New-Object PSObject -Property @{
            PuardName = $PuardName
            Pattern = $Pattern
            Name = $Name
            Action = $Action
        }
    }
    & $ScriptBlock
}
cls