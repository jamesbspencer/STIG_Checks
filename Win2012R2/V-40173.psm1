<#
    .Synopsys
    Manual STIG check V-40173 - Backup

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40173 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    
    return $result
    }
Export-ModuleMember -Function V-40173
#Run Create-Manifest.ps1 when finished. 