<#
    .Synopsis
    V-1121 - Prohibit FTP anonymous logins

    .Parameter SERVER
    The server naem to run the function against.

    .Example
    V-1121 -SERVER "server1"
#>

function V-1121{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $tcp_test = Test-NetConnection -ComputerName $server -Port 21 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    if($tcp_test.TcpTestSucceeded){
        $return = "a"
        }
    else{
        $return = "c"
        }

    return $return
    }

Export-ModuleMember -Function V-1121