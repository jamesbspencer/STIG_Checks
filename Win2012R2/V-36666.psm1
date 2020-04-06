<#
    .Synopsys
    Manual STIG check V-36666 - SA Training

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36666 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-36666
#Run Create-Manifest.ps1 when finished. 