<#
    .Synopsys
    Manual STIG check V-43241 - Microsoft Accounts Enable

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-43241 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $reg = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name "MSAOptional"
        }
    if($reg -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-43241
#Run Create-Manifest.ps1 when finished. 