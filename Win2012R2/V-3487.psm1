﻿<#
    .Synopsys
    Manual STIG check V-3487 - Unecessary Services

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-3487 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    return $result
    }
Export-ModuleMember -Function V-3487
#Run Create-Manifest.ps1 when finished. 