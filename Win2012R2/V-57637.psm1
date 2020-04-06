<#
    .Synopsys
    Manual STIG check V-57637 - Applocker Policy

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-57637 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    [xml]$xml = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-AppLockerPolicy -Effective -Xml
        }
    if($xml.AppLockerPolicy.RuleCollection.Count -eq "0"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-57637
#Run Create-Manifest.ps1 when finished. 