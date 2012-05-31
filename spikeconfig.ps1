function testing() {
    param (
        [string]$InputStr
        )
    echo "hej fra function - $InputStr"
}


New-Puard jsActions {
    New-PuardAction "*.js" {testing("parameter sent to function") } "phantomjs execution"
    New-PuardAction "*.js" {
        param ([string]$input)
        echo "med"
        $input
        } "minimize"
}

New-Puard autoptestActions {
    New-PuardAction "*.test.dll" {echo "dig"} "test changes"
    New-PuardAction "*.dll" {echo "puard"} "app changes"
} 