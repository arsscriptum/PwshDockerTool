

function Get-ProcessNamesIds {
    Get-Process | % { $p = $_
       $startTime = $p.StartTime
       $pname = $p.Name
       $len = 30 - $pname.Length
      $pad = [string]::new(' ',$len)
      if($Null -ne $startTime) { $formattedTime = $startTime.ToString("ddHHmmss") }else{ $formattedTime = $p.Id.ToString("D8") }
      $log = "{0}{1}`: {2}" -f $pname, $pad, $formattedTime
      Write-Host "$log" -f Red 
    }
}

function Get-ProcessNameMaxLength {
    [int]$maxlen = 0
    Get-Process | % { $p = $_
       $pname = $p.Name
       if($pname.Length -gt $maxlen){$maxlen = $pname.Length}
    }
    $maxlen
}

function ConvertTo-PipeList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Data
    )

    begin {
        # Initialize the result array
        $result = @()
    }

    process {
        foreach ($line in $NewData) {
            # Match lines that end with a numeric ID
            if ($line -match '(.+)\s+(\d+)$') {
                $location = $matches[1].Trim()
                $id = [int]$matches[2]
                $result += [PSCustomObject]@{
                    ServerID       = $id
                    ServerLocation = $location
                }
            }
        }
    }

    end {
        # Output the result array
        $result
    }
}


function Test-MiniPorts {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false) ]
        [string]$ServerAddress='mini',
        [Parameter(Mandatory=$false, Position = 1, HelpMessage="The ports") ]
        [int[]]$Ports = @(8000, 9000, 9443),
        [Parameter(Mandatory=$false, HelpMessage="Timeout in milliseconds") ]
        [int]$Timeout = 100 # im on the LAN
    )

    try{

        $jobs = @()


        foreach ($port in $Ports) {
            $jobs += Start-Job -ScriptBlock {
                param ($server, $port, $timeout)
                try {
                    $tcpClient = [System.Net.Sockets.TcpClient]::new()
                    $connectTask = $tcpClient.ConnectAsync($server, $port)
                    $completed = $connectTask.Wait($timeout)

                    if ($completed -and $tcpClient.Connected) {
                        $tcpClient.Close()
                        return $true
                    } else {
                        return $false
                    }
                } catch {
                    return $false
                }
            } -ArgumentList $ServerAddress, $port, $Timeout
        }
        $ErrorOccured = $False

        try{
            $jobs | ForEach-Object { $OutJob = Wait-Job -Job $_ }
        }catch{
            $ErrorOccured = $True
        }

        $portCheckResults = $jobs | ForEach-Object {
            $result = Receive-Job -Job $_
            Remove-Job -Job $_
            $result
        }
        if($ErrorOccured){ return $False }

        return ($portCheckResults -notcontains $false)
    }catch{
        Show-ExceptionDetails $_
    }
}


$alist = @("1","2")
Start-Job -Name "mytimedjob" -ScriptBlock {
    param (
        [Parameter(Mandatory=$false) ]
        [string]$Containers,
        [Parameter(Mandatory=$false) ]
        [string]$StacksList
    )
    function JobLog{
        param (
        [Parameter(Mandatory=$true, position=0) ]
        [string]$msg)
        Add-Content -Path "d:\joblog.txt" -Value "$(Get-Date) $msg"
    }
    function Invoke-TimedFunction {
        JobLog "$Containers"
        JobLog "Invoke-TimedFunction"
    }
    JobLog "start $($Containers.GetType())"
    Invoke-TimedFunction
    while ($true) {
        Start-Sleep -Seconds 20  # Sleep for 2 minutes
        Invoke-TimedFunction
        
    }
} -ArgumentList $alist
