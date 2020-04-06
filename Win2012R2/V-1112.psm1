<#
    .Synopsys
    Manual STIG check V-1112

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1112 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $return = "b"
    $locals = Invoke-Command -ComputerName $SERVER -ScriptBlock{Get-LocalUser | where {$_.Enabled -eq $true}}
    foreach($local in $locals){
        if (($local.LastLogon - $(Get-Date)).Days -lt "-35" -and $local.SID -notmatch "500$"){
            $return = "a"
            }
        }
    return $return
    }
Export-ModuleMember -Function V-1112
#Run Create-Manifest.ps1 when finished. 