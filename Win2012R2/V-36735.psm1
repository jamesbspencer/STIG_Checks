<#
    .Synopsys
    Manual STIG check V-36735 - Patching

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36735 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $me = $MyInvocation.MyCommand.Name
    if ($Global:ini.$Global:ver.$me -match "^T"){
        $result = "b"
        }
    elseif($Global:ini.$Global:ver.$me -match "^F"){
        $result = "a"
        }
    elseif($Global:ini.$Global:ver.$me -match "^N"){
        $result = "c"
        }
    else{$result = "d"}
    return $result
    }
Export-ModuleMember -Function V-36735
#Run Create-Manifest.ps1 when finished. 