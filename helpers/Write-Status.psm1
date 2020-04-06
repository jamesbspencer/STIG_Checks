<#
	.Synopsis
	Process the output of the STIG function.

	.Paramter SERVER
	The Name of the function and the status.

	.Example
	Write-Staus -ID $g_id -STATUS $g_stat


#>
function Write-Status{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $ID,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $STATUS
        )
    Write-Host "$SERVER $ID`: " -NoNewline
    if ($STATUS -eq "a"){
        $return = "Open"
        Write-Host "OPEN" -ForegroundColor Red
        }
    elseif($STATUS -eq "b"){
        $return = "NotAFinding"
        write-host "NOT A FINDING" -ForegroundColor Green
        }
    elseif($STATUS -eq "c"){
        $return = "Not_Applicable"
        Write-Host "NOT APPLICABLE" -ForegroundColor Gray
        }
    elseif($STATUS -eq "d"){
        $return = "Not_Reviewed"
        Write-Host "NOT REVIEWED" -ForegroundColor Blue
        }
    else{
        $return = "Invalid"
        Write-host "INVALID STATUS" -ForegroundColor Yellow
        }
    return $return
    }

Export-ModuleMember -Function Write-Status