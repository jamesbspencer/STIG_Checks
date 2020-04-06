<#
    .Synopsys
    Manual STIG check V-14269 - Attachment Zone infomration

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-14269 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $attach = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -name "HideZoneInfoOnProperties"}
    if($attach -ne "1"){
        $result = "a"
        }
    return $result
    }
Export-ModuleMember -Function V-14269
#Run Create-Manifest.ps1 when finished. 