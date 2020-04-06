<#
    .Synopsys
    Manual STIG check V-36667 - Object Access Removable Storage Failure

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36667 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $rem_stor_fail = Invoke-Command -ComputerName $server -ScriptBlock {
        auditpol /get /subcategory:"Removable Storage" | Select-String "Removable Storage"
        }
    if($rem_stor_fail -notmatch "Failure"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36667
#Run Create-Manifest.ps1 when finished. 