<#
    .Synopsys
    Manual STIG check V-36657 - Screen Saver

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36657 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $helpexp = invoke-command -ComputerName $server -ScriptBlock {
        Get-ItemPropertyValue 'HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -Name "ScreenSaverIsSecure"
        }
    if($helpexp -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36657
#Run Create-Manifest.ps1 when finished. 