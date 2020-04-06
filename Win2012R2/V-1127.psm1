<#
    .Synopsys
    Manual STIG checkV-1127 - Restricted Admin Access

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1127 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $return = "b"
    $users = Invoke-Command -ComputerName $SERVER -ScriptBlock{Get-LocalGroupMember -Name Administrators | where {$_.ObjectClass -eq "User" }}
    foreach($user in $users){
        if($user -match $SERVER -and $user -notmatch "Admin"){
            $return = "a"
            }
        }
    return $return
    }
Export-ModuleMember -Function V-1127
#Run Create-Manifest.ps1 when finished. 