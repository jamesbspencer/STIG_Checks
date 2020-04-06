<#
    .Synopsys
    Manual STIG check V-40202 - Object Access Central Policy Staging Success

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40202 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $audit = Invoke-Command -ComputerName $server -ScriptBlock {
        auditpol /get /subcategory:"Central Policy Staging" | Select-String "Central Policy Staging"
        }
    if($audit -notmatch "Success"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-40202
#Run Create-Manifest.ps1 when finished. 