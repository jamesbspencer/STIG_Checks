<#
    .Synopsys
    Try to fix WSMAN with WMI

    .Parameter SERVER
    The server to fix.

    .Example
    Fix-WsmanWithWmi -SERVER "server1"
#>

function Fix-WsmanWithWmi{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $commands = "powershell Enable-PSRemoting -force", "powershell winrm quickconfig", "powershell New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\WinRS -Name AllowRemoteShellAccess -Value 1 -PropertyType DWORD -Force", "powershell Restart-Service WinRM"
    foreach ($command in $commands){
        try{
            Invoke-WmiMethod -ComputerName $SERVER -Path Win32_Process -Name create -ArgumentList $commmand  -ErrorAction stop
            If(Test-WSMan $SERVER){
                return "true"
                }
            else{
                Write-Host "Couldn't fix WS Man with WMI"
                return "false"
                }
            }
        Catch{
            Write-Host "Couldn't fix WS Man with WMI"
            return "false"
            }
        }
    }
Export-ModuleMember -Function Fix-WsmanWithWmi