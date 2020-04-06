<#
    .Synopsys
    Manual STIG check V-36662 - Manually Managed Service Accounts

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36662 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "d"
    return $result
    }
Export-ModuleMember -Function V-36662
#Run Create-Manifest.ps1 when finished. 