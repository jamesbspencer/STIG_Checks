<#
    .Synopsys
    Manual STIG check V-3472 - Windows Time

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-3472 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $time = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKLM:\system\CurrentControlSet\Services\W32Time\Parameters -Name Type}
    if($time -eq "NT5DS"){
        $return = "b"
        }
    elseif($time -eq "NTP"){
        $ntp = Invoke-Command -ComputerName $server -ScriptBlock{Get-ItemPropertyValue HKLM:\system\CurrentControlSet\Services\W32Time\Parameters -Name NtpServer}
        if ($ntp -ne $null){
            $return = "b"
            }
        else{$return = "a"}
        }
    else{
        $return = "a"
        }
    return $return
    }
Export-ModuleMember -Function V-3472
#Run Create-Manifest.ps1 when finished. 