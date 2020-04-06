<#
    .Synopsys
    Manual STIG checkV-1135 - Printer Shares

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-1135 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $return = "c"
    $printers = Get-Printer -ComputerName $server
    foreach($printer in $printers){
        if($printer.Name -notmatch "XPS" -and  $printer.Name -notmatch "PDF"){
            $return = "b"
            if($printer.shared -eq $true){
                $return = "a"
                }
            }
        }
    return $return
    }
Export-ModuleMember -Function V-1135
#Run Create-Manifest.ps1 when finished. 