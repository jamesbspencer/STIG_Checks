<#
    .Synopsys
    Manual STIG check V-36733 - User Level Backup Information

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36733 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-36733
#Run Create-Manifest.ps1 when finished. 