function testing() {

}


New-Puard jsActions {
    New-PuardAction ".*.js" {echo "hej"} "phantomjs execution"
    New-PuardAction ".*.js" {echo "med"} "minimize"
}

New-Puard autoptestActions {
    New-PuardAction ".*.test.dll" {echo "dig"} "test changes"
    New-PuardAction ".*.dll" {echo "puard"} "app changes"
} 