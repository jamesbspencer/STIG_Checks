<#
    .Synopsys
    Manual STIG check V-42420 - HBSS

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-42420 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $svc = Get-Service -ComputerName $server -Name masvc
    if($svc.Status -ne "Running"){
        $result = "a"
        }

    return $result
    }
Export-ModuleMember -Function V-42420
#Run Create-Manifest.ps1 when finished. 