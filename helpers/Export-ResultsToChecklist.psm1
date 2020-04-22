<#
    .Synopsys
    Populates the Checklist with results from the script.

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
            $ckl_file = Get-ChildItem -Path "$ckl_path\*$server*.ckl" -Exclude "*populated*" -ErrorAction Stop
            [xml]$xml = Get-Content -Path $ckl_file.FullName
            }
        CATCH{
            Write-Host "Unable to Checklist file for $server"
            continue
            }
        foreach($key in $array.$server.keys){
                $status = ($array.$server.$key -split "[,-]")[0]
                $findings = ($array.$server.$key -split "[,-]")[1]
                $comments = ($array.$server.$key -split "[,-]")[2]
                $xml.CHECKLIST.STIGS.iSTIG.VULN.Where({$_.STIG_DATA.ATTRIBUTE_DATA -eq $key}).Item(0).STATUS = $status
                if(-not ($findings -eq $null)){
                    $xml.CHECKLIST.STIGS.iSTIG.VULN.Where({$_.STIG_DATA.ATTRIBUTE_DATA -eq $key}).item(0).FINDING_DETAILS = $findings
                    }
                if(-not ($comments -eq $null)){
                    $xml.CHECKLIST.STIGS.iSTIG.VULN.Where({$_.STIG_DATA.ATTRIBUTE_DATA -eq $key}).item(0).COMMENTS = $comments
                    }

                }

        $xmlSettings = New-Object -TypeName System.Xml.XmlWriterSettings
        $xmlSettings.Indent = $true
        $xmlSettings.IndentChars = " "
        $xmlSettings.NewLineChars = "`n"

        $xmlWriter = [System.Xml.XmlWriter]::Create("$ckl_path\$(Get-Date -Format FileDate)-$server-populated.ckl",$xmlSettings)

        $xml.Save($xmlWriter)
        $xmlWriter.Close()

        }
    }
Export-ModuleMember -Function Export-ResultsToChecklist