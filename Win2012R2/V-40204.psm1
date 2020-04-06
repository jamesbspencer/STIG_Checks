<#
    .Synopsys
    Manual STIG check V-40204 - RDS Default Printer

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40204 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $rds = Invoke-Command -ComputerName $server -ScriptBlock{
        Get-ItemPropertyValue 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "RedirectOnlyDefaultClientPrinter"
        }
    if($rds -ne "1"){$result = "a"}
    return $result
    }
Export-ModuleMember -Function V-40204
#Run Create-Manifest.ps1 when finished. 