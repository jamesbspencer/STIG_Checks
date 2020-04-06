<#
    .Synopsys
    Manual STIG check V-36710 - Windows Store

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36710 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $win_store = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore -Name "AutoDownload"
        }
    if($win_store -ne "2"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-36710
#Run Create-Manifest.ps1 when finished. 