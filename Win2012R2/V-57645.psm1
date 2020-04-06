<#
    .Synopsys
    Manual STIG check V-57645 - Encryption

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-57645 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    
    return $result
    }
Export-ModuleMember -Function V-57645
#Run Create-Manifest.ps1 when finished. 