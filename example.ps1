function testing() {
	echo "calling function from action" 
}

New-Puard csActions {
    New-PuardAction ".*.cs$" {echo "start building"} "build project"
}

New-Puard jsActions {
    New-PuardAction ".*.js$" {echo "hej"} "phantomjs execution"
    New-PuardAction ".*.js$" { testing } "minimize"
}

New-Puard autoptestActions {
    New-PuardAction ".*.test.dll$" {echo "dig"} "test changes"
    New-PuardAction ".*.dll$" {echo "puard"} "app changes"
} 