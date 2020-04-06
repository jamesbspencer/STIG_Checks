<#
    .Synopsys
    Validate the input.

    .Parameter SERVER
    The server to validate.

    .Example
    Validate-Input -SERVER "server1"
#>

function Validate-Input{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    Try{
        $test = Get-WmiObject win32_operatingsystem -ComputerName $SERVER -ErrorAction Stop
        if($test.Version -match "^6.3*" -and $test.ProductType -eq "3"){$return = "Win2012R2"}
        elseif($test.Version -match "^10.0*" -and $test.ProductType -eq "3"){$return = "Win2016"}
        elseif($test.Version -match "^6.1*" -and $test.ProductType -eq "3"){$return = "Win2008R2"}
        else{
            Write-Host "The OS Version, $test.Version, is not supported"
            $return = "false"
            }
        }
    Catch{
        Write-Host "Cannot manage $SERVER with WMI"
        $return = "false"
    }
    Try{
        $test_wsman = Test-WSMan -ComputerName $SERVER -ErrorAction Stop
        }
    Catch{
        $error = [System.Windows.MessageBox]::Show("Cannot manage $SERVER with WS MAN. Would you like to try and fix it?","Error",'YesNo','Error')
        if($error -eq "Yes"){
            $fix = Fix-WsmanWithWmi -SERVER $SERVER
            if($fix -ne "true"){
                $return = "false"
                }
            }
        else{
            $return = "false"
            }
        }
    return $return
}
Export-ModuleMember -Function Validate-Input