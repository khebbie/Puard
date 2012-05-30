function testing() {
    param (
        [string]$InputStr
        )
    echo "hej fra function - $InputStr"
}

New-Puard csActions {
    New-PuardAction ".*.cs$" {echo "start building"} "build project"
}

New-Puard jsActions {
    New-PuardAction ".*.js$" { param ([string]$path )echo "hej $path"} "phantomjs execution"
    New-PuardAction ".*.js$" { testing("parameter sent in") } "minimize"
}

New-Puard autoptestActions {
    New-PuardAction ".*.test.dll$" {echo "dig"} "test changes"
    New-PuardAction ".*.dll$" {echo "puard"} "app changes"
} 