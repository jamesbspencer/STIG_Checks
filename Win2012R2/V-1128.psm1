<#
    .Synopsys
    Manual STIG checkV-1128 - Security Configuration

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1128 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $return = "b"
    
    return $return
    }
Export-ModuleMember -Function V-1128
#Run Create-Manifest.ps1 when finished. 