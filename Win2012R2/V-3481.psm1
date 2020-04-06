<#
    .Synopsys
    Manual STIG check V-3481 - Media Player

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-3481 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $codec = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKCU:\Software\Policies\Microsoft\WindowsMediaPlayer -Name PreventCodecDownload}
    if($codec -eq "1"){
        $result = "b"
        }
    else{$result = "a"}
    return $result
    }
Export-ModuleMember -Function V-3481
#Run Create-Manifest.ps1 when finished. 