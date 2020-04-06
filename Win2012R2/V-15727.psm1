<#
    .Synopsys
    Manual STIG check V-15727 - User Network Shares

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-15727 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $attach = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -name "NoInPlaceSharing"}
    if($attach -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-15727
#Run Create-Manifest.ps1 when finished. 