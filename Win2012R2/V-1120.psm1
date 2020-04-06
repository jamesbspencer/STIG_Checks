<#
    .Synopsis
    V-1120 - Prohibit FTP anonymous logins

    .Parameter SERVER
    The server naem to run the function against.

    .Example
    V-1120 -SERVER "server1"
#>

function V-1120{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $ftp = Get-WindowsFeature -ComputerName $server -Name Web-FTP-Server
    if ( -not $ftp.Installed){$return = "c"}else{$return = "a"}
    return $return
    }

Export-ModuleMember -Function V-1120