<#
    .Synopsys
    

    .Parameter SERVER
    

    .Example
    function_name -SERVER server1
#>

function function_name {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    ## The work
    return # a, b, or c
    }
Export-ModuleMember -Function function_name
#Run Create-Manifest.ps1 when finished. 