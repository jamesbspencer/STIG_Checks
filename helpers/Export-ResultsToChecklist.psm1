<#
    .Synopsys
    Populates the Checklist with results 

    .Parameter ARRAY
    A hashtable array of STIG results.

    .Example
    Export-ResultsToChecklist -ARRAY $output
#>

function Export-ResultsToChecklist {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $ARRAY
        )
    $ckl_path = $ini.GLOBAL.CHECKLIST_DIR
    $servers = $array.keys
    foreach($server in $servers){
        TRY{
            [xml]$xml = Get-Content -Path "$ckl_path\*$server*.ckl" -ErrorAction stop
            foreach($key in $array.$server.keys){
                $status = $($array.$server.$key)
                $xml.CHECKLIST.STIGS.iSTIG.VULN.Where({$_.STIG_DATA.ATTRIBUTE_DATA -eq $key}).Item(0).STATUS = $status
                }
            }
        CATCH{
            Write-Host "Unable to load file"
            exit
            }

        $xmlSettings = New-Object -TypeName System.Xml.XmlWriterSettings
        $xmlSettings.Indent = $true
        $xmlSettings.IndentChars = " "
        $xmlSettings.NewLineChars = "`n"

        $xmlWriter = [System.Xml.XmlWriter]::Create("$ckl_path\$(Get-Date -Format FileDate)-$server-populated.ckl",$xmlSettings)

        $xml.Save($xmlWriter)

        }
    }
Export-ModuleMember -Function Export-ResultsToChecklist