﻿<#
    .Synopsys
    Manual STIG check V-36659 - Separate Admin Accounts

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36659 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-36659
#Run Create-Manifest.ps1 when finished. 