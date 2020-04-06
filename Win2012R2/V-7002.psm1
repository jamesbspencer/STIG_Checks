<#
    .Synopsys
    Manual STIG check V-7002 - Password Required

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-7002 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $users = Invoke-Command -ComputerName $server -ScriptBlock{Get-LocalUser}
    foreach($user in $users){
        if($user.PasswordRequired -eq $false -and $user.Enabled -eq $true){
            $result = "a"
            }
        }
    return $result
    }
Export-ModuleMember -Function V-7002
#Run Create-Manifest.ps1 when finished. 