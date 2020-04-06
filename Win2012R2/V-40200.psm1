<#
    .Synopsys
    Manual STIG check V-40200 - Object Access Central Policy Staging Failure

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40200 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $rem_stor_fail = Invoke-Command -ComputerName $server -ScriptBlock {
        auditpol /get /subcategory:"Central Policy Staging" | Select-String "Central Policy Staging"
        }
    if($rem_stor_fail -notmatch "Failure"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-40200
#Run Create-Manifest.ps1 when finished. 