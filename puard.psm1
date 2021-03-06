
function Invoke-Puard ()
{
    param (
        [string]$DirToWatch = ".\",
        [string]$Puardfile = ".\PuardFile.ps1"
        )
				
		function get_event_key($eventArgs) {
	        if($prev_events.ContainsKey($eventArgs)) {
	            return $prev_events[$eventArgs]
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
		$lastChangedDate = get_event_key $FullPath
        
            $shouldTakeAction = should_take_action $lastChangedDate
            if($shouldTakeAction )
            {
                $actions = $config | Where {$FullPath -match $_.Pattern}
				if($actions -eq $null)
				{
					return;
				}
				
				$actions | foreach { 
                if($FullPath -eq $null -or $_.Action -eq $null)
                {
                    continue;
                }
                write-host "----------------------------------------------"
	            write-host $FullPath  -foregroundcolor green                
	            write-host "----------------------------------------------"
				Invoke-Command -ScriptBlock $_.Action -ArgumentList $FullPath
				}
                
	        }
           $prev_events[$FullPath] = get-date;
	}

    cls
    
    #include dsl	
    $path = Join-Path $env:USERPROFILE -childpath '\Documents\WindowsPowershell\Modules\puard\puard dsl.ps1'
    .$path

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
	$conditions = [System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Deleted -bor [System.IO.WatcherChangeTypes]::Created

    write-host "start watching $watchdir" -foregroundcolor green

	while($TRUE){
		$result = $fsw.WaitForChanged($conditions, 1000);
		if($result.TimedOut){
			continue;
		}
		$filepath = [System.IO.Path]::Combine($watchdir, $result.Name)
        if($filepath -eq $null)
        {
            continue;
        }
		file_changed	$filepath
	}
    wait-event "ctrl-c"
}

Export-ModuleMember Invoke-Puard