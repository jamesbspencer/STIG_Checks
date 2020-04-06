<#
    .Synopsys
    Manual STIG check V-36777 - Windows Push Notification

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36777 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $win_push = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications -Name "NoToastApplicationNotificationOnLockScreen"
        }
    if($win_push -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36777
#Run Create-Manifest.ps1 when finished. 