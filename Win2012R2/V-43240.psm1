<#
    .Synopsys
    Manual STIG check V-43240 - Logon Screen Network UI Disable

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-43240 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $lock = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "DontDisplayNetworkSelectionUI"
        }
    if($lock -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-43240
#Run Create-Manifest.ps1 when finished. 