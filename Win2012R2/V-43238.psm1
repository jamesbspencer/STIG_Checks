<#
    .Synopsys
    Manual STIG check V-43238 - Screen Lock Slide Show Disable

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-43238 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $lock = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name "NoLockScreenSlideshow"
        }
    if($lock -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-43238
#Run Create-Manifest.ps1 when finished. 