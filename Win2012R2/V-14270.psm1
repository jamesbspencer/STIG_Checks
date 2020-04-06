<#
    .Synopsys
    Manual STIG check V-14270 - Attachment Scan with AV

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-14270 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $attach = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -name "ScanWithAntiVirus"}
    if($attach -ne "3"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-14270
#Run Create-Manifest.ps1 when finished. 