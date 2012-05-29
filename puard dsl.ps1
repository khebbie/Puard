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


New-Puard jsActions {
    New-PuardAction "*.js" {echo "hej"} "phantomjs execution"
    New-PuardAction "*.js" {echo "med"} "minimize"
}

New-Puard autoptestActions {
    New-PuardAction "*.test.dll" {echo "dig"} "test changes"
    New-PuardAction "*.dll" {echo "puard"} "app changes"
} 
