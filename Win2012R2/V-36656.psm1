<#
    .Synopsys
    Manual STIG check V-36656 - Screen Saver

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36656 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $helpexp = invoke-command -ComputerName $server -ScriptBlock {
        Get-ItemPropertyValue 'HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -Name "ScreenSaveActive"
        }
    if($helpexp -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36656
#Run Create-Manifest.ps1 when finished. 