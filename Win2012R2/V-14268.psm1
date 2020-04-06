<#
    .Synopsys
    Manual STIG check V-14268 - Attachment Zone infomration

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-14268 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $attach = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -name "SaveZoneInformation"}
    if($attach -ne "2"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-14268
#Run Create-Manifest.ps1 when finished. 