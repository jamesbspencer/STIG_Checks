<#
    .Synopsys
    Manual STIG check V-1119 - Dual Boot

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1119 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $bcd = Invoke-Command -ComputerName $server -ScriptBlock{
        bcdedit /enum
        }
    $pattern = $bcd | Select-String -Pattern "description" -AllMatches | where {$_ -notmatch "Windows Boot Manager"}
    if($pattern.count -gt "1"){$result = "a"}
    return $result
    }
Export-ModuleMember -Function V-1119
#Run Create-Manifest.ps1 when finished. 