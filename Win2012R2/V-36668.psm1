<#
    .Synopsys
    Manual STIG check V-36668 - Object Access Removable Storage Success

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36668 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $rem_stor_fail = Invoke-Command -ComputerName $server -ScriptBlock {
        auditpol /get /subcategory:"Removable Storage" | Select-String "Removable Storage"
        }
    if($rem_stor_fail -notmatch "Success"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36668
#Run Create-Manifest.ps1 when finished. 