. '.\puard dsl.ps1'

$config = . .\spikeconfig.ps1
$config | foreach { & $_.Action }