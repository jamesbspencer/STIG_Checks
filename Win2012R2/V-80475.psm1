<#
    .Synopsys
    Manual STIG check V-80475 - Powershell Script Block Logging

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-80475 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $psb_log = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name "EnableScriptBlockLogging"
        }
    if($psb_log -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-80475
#Run Create-Manifest.ps1 when finished. 