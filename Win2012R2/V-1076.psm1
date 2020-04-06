<#
    .Synopsys
    Manual STIG check V-1076 - System-level Backup

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1076 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    
    return $result
    }
Export-ModuleMember -Function V-1076
#Run Create-Manifest.ps1 when finished. 