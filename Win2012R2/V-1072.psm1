<#
    .Synopsys
    Manual STIG check V-1072

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1072 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    
    return "c"
    }
Export-ModuleMember -Function V-1072
#Run Create-Manifest.ps1 when finished. 