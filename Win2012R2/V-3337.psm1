<#
    .Synopsys
    Manual STIG check V-3337 - Anonymous SID translation

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-3337 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    
    $return = "d"
    return $return
    }
Export-ModuleMember -Function V-3337
#Run Create-Manifest.ps1 when finished. 