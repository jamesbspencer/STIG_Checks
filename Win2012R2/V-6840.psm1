<#
    .Synopsys
    Manual STIG check V-6840 - Password Expiration Disabled

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-6840 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $users = Invoke-Command -ComputerName $server -ScriptBlock{Get-LocalUser}
    foreach($user in $users){
        if($user.PasswordExpires -eq $false -and $user.Enabled -eq $true){
            $result = "a"
            }
        }
    return $result
    }
Export-ModuleMember -Function V-6840
#Run Create-Manifest.ps1 when finished. 