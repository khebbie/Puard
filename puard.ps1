'.\puard dsl.ps1'

function Invoke-Puard ()
{
    param (
        [string]$DirToWatch = ".\",
        [string]$Puardfile = "PuardFile.ps1"
        )

    get-eventsubscriber -force | unregister-event -force

    $fsw = New-Object System.IO.FileSystemWatcher $watchdir
    $fsw.Filter = "*.dll"
    $fsw.IncludeSubdirectories=$true
    $fsw.EnableRaisingEvents=$true

    $prev_events =@{}

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

     $action = {
        
            $value = get_event_key $eventArgs
        
            $shouldTakeAction = should_take_action $value
            if($shouldTakeAction )
            {
           
               write-host "----------------------------------------------"
               write-host $eventArgs.FullPath  -foregroundcolor green
               write-host "----------------------------------------------"
           }
           $prev_events[$eventArgs.FullPath] = get-date;
        }

    Register-ObjectEvent -InputObject $fsw -EventName Changed -SourceIdentifier ChangedEvent -Action $action

    write-host "start watching $watchdir" -foregroundcolor green

    wait-event "ctrl-c"
}
