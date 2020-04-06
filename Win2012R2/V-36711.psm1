<#
    .Synopsys
    Manual STIG check V-36711 - Windows Store

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-36711 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    Try{
        $win_store = Invoke-Command -ComputerName $server -ScriptBlock{
            Get-ItemPropertyValue HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore -Name "RemoveWindowsStore" 
            } -ErrorAction stop
        if($win_store -ne "1"){
            $result = "a"
            }
        }
    Catch{$result = "c"}
    return $result
    }
Export-ModuleMember -Function V-36711
#Run Create-Manifest.ps1 when finished. 