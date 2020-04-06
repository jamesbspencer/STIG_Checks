<#
    .Synopsys
    Manual STIG check V-72753 - WDigest disabled

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-72753 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $reg = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue HKLM:\system\CurrentControlSet\Control\SecurityProviders\WDigest -Name "UseLogonCredential"
        }
    if($reg -ne "0"){
        $result = "d"
        }
    return $result
    }
Export-ModuleMember -Function V-72753
#Run Create-Manifest.ps1 when finished. 