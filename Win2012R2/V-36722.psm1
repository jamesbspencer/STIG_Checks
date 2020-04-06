<#
    .Synopsys
    Manual STIG check V-36722 - Application Log Perms

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36722 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $matches = "EventLog","SYSTEM", "Administrators"
    $matches2 = [System.Collections.ArrayList]@($matches)
    $acl = Get-Acl -Path \\$server\C$\Windows\System32\WINEVT\LOGS\Application.evtx
    foreach($match in $matches){
        $member = $acl.Access | where {$_.IdentityReference -match $match}
        if($member -ne $null){
            $matches2.Remove($match)
            if($member.FileSystemRights -ne "FullControl"){
                $result = "a"
                }
            }
        }
    if($matches2.Count -ne "0"){$result = "a"}
    return $result
    }
Export-ModuleMember -Function V-36722
#Run Create-Manifest.ps1 when finished. 