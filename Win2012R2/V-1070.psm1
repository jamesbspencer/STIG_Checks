<#
    .Synopsys
    Manual STIG check V-1070

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1070 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    
    return "b"
    }
Export-ModuleMember -Function V-1070
#Run Create-Manifest.ps1 when finished. 