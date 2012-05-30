
function Invoke-Puard ()
{
    param (
        [string]$DirToWatch = ".\",
        [string]$Puardfile = ".\PuardFile.ps1"
        )
function get_event_key($eventArgs) {
        if($prev_events.ContainsKey($eventArgs.FullPath)) {
            return $prev_events[$eventArgs.FullPath]
        }
        return $null
    }

    function should_take_action($lastChangedDate) {
        if(!$lastChangedDate) {
                return $true
           }

        $ts = New-TimeSpan $lastChangedDate $(Get-Date)
        if($ts.TotalSeconds -gt 15) {
            return $true
        }
        return $false

    }
	
	function file_changed()
	{
		param (
			[string]$FullPath
		)
		$value = get_event_key $FullPath
        
            $shouldTakeAction = should_take_action $value
            if($shouldTakeAction )
            {
                $actions = $config | Where {$FullPath -match $_.Pattern}
				$actions | foreach { & $_.Action }
           
               write-host "----------------------------------------------"
               write-host $FullPath  -foregroundcolor green
               write-host "----------------------------------------------"
           }
           $prev_events[$FullPath] = get-date;
	}

    cls
    
    #include dsl
    . '.\puard dsl.ps1'

    Write-Host Parsing $Puardfile

    $config = . $Puardfile
    $config 

    $watchdir = convert-path $DirToWatch

    get-eventsubscriber -force | unregister-event -force

    $fsw = New-Object System.IO.FileSystemWatcher $watchdir
    $fsw.Filter = "*.*"
    $fsw.IncludeSubdirectories=$true
    $fsw.EnableRaisingEvents=$true

    $prev_events =@{}
	$conditions = [System.IO.WatcherChangeTypes]::Changed

    Register-ObjectEvent -InputObject $fsw -EventName Changed -SourceIdentifier ChangedEvent -Action $action

    write-host "start watching $watchdir" -foregroundcolor green

	while($TRUE){
		$result = $fsw.WaitForChanged($conditions, 1000);
		if($result.TimedOut){
			continue;
		}
		$filepath = [System.IO.Path]::Combine($watchdir, $result.Name)
		file_changed	$filepath
	}
    wait-event "ctrl-c"
}
