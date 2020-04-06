<#
    .Synopsys
    Manual STIG check V-36670 - Review Audit logs

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36670 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    
    return $result
    }
Export-ModuleMember -Function V-36670
#Run Create-Manifest.ps1 when finished. 