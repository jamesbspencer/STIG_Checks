<#
    .Synopsys
    Manual STIG check V-75915 - LSA User Rights Assignment

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-75915 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "d"
    
    return $result
    }
Export-ModuleMember -Function V-75915
#Run Create-Manifest.ps1 when finished. 