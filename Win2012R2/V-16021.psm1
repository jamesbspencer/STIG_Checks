<#
    .Synopsys
    Manual STIG check V-16021 - Help Experience

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-16021 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $helpexp = invoke-command -ComputerName $server -ScriptBlock {Get-ItemPropertyValue HKCU:\Software\Policies\Microsoft\Assistance\Client\1.0 -Name "NoImplicitFeedback"}
    if($helpexp -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-16021
#Run Create-Manifest.ps1 when finished. 