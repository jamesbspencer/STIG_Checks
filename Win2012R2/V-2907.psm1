<#
    .Synopsys
    Manual STIG check V-2907 - System File Checks

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-2907 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-2907
#Run Create-Manifest.ps1 when finished. 