<#
    .Synopsys
    Manual STIG check V-57655 - Emergency Admin Accounts

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-57655 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "c"
    
    return $result
    }
Export-ModuleMember -Function V-57655
#Run Create-Manifest.ps1 when finished. 