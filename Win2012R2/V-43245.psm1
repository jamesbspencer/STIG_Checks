<#
    .Synopsys
    Manual STIG check V-43245 - Auto Sign-In Last User Disable

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-43245 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $reg = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name "DisableAutomaticRestartSignOn"
        }
    if($reg -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-43245
#Run Create-Manifest.ps1 when finished. 