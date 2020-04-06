<#
    .Synopsys
    Manual STIG checkV-1168 - Members of the Backup Operators Group

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1168 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $members = Invoke-Command -ComputerName $server -ScriptBlock {Get-LocalGroupMember -Name "Backup Operators"}
    if($members.count -gt 0){$result = "b"}else{$result = "c"}
    return $result
    }
Export-ModuleMember -Function V-1168
#Run Create-Manifest.ps1 when finished. 