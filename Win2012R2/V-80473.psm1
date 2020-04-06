<#
    .Synopsys
    Manual STIG check V-80473 - Powershell Version

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-80473 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $psv = Invoke-Command -ComputerName $server -ScriptBlock{
        $PSVersionTable
        }
    if($psv.PSVersion.Major -lt "5"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-80473
#Run Create-Manifest.ps1 when finished. 