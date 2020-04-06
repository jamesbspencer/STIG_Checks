<#
    .Synopsys
    Manual STIG check V-1074 - Anti-Virus

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1074 {
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
Export-ModuleMember -Function V-1074
#Run Create-Manifest.ps1 when finished. 