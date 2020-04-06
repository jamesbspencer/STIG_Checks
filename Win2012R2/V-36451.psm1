<#
    .Synopsys
    Manual STIG check V-36451 - Admin accounts no Internet

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36451 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-36451
#Run Create-Manifest.ps1 when finished. 