<#
    .Synopsys
    Manual STIG check V-36658 - Documented Administrators

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36658 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-36658
#Run Create-Manifest.ps1 when finished. 