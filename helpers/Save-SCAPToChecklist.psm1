<#
    .Synopsys
    Populates the Checklist with results from the SCAP scan's XCCDF Results file. 

    .Parameter SCAPFile
    The XCCDF Results xml file from a scap scan.

    .Paramter Checklist
    The Server's checklist file or a checklist template.

    .Paramter NewChecklist
    A True/False switch so set the output to the imported checklist or a new file.

    .Paramter OutPath
    The directory path of where to save checklists if WriteBackToChecklist is true.

    .Example
    Save-SCAPToChecklist -SCAPFile *.xml -Checklist *.ckl -WriteBackToChecklist -OutPath C:\dir\
#>


function Save-SCAPToChecklist {
    Param(
        [Parameter(Mandatory=$true)]
        [String]
        $SCAPFile,

        [Parameter(Mandatory=$true)]
        [String]
        $CklFile,

        [Parameter(Mandatory=$false, ParameterSetName="Output")]
        [Switch]
        $NewChecklist,

        [Parameter(Mandatory=$true, ParameterSetName="Output")]
        [Parameter(Mandatory=$false)]
        [String]
        $OutPath
        )

    #Validate the parameters.
    if(-not ([System.IO.Path]::GetExtension($SCAPFile) -eq ".xml")){
        throw "SCAPFile is not a xml file."
        }
    if(-not ([System.IO.Path]::GetExtension($CklFile) -eq ".ckl")){
        throw "Checklist file is not a ckl file."
        }
    if($NewChecklist -and -not (Test-Path $OutPath)){
        throw "OutPath is not a valid directory path"
        }

    [xml]$results = Get-Content $SCAPFile

    [xml]$checklist = Get-Content $CklFile

    # Get the hostname and set it in the checklist
    $host_name = $results.Benchmark.TestResult.target
    $checklist.CHECKLIST.ASSET.HOST_NAME = $host_name

    # Get the IP address(es) and set it in the checklist
    $host_ip = [string]($results.Benchmark.TestResult.'target-address' | where {$_ -notmatch "^127.0" -and $_ -notmatch "^169.254"})
    $checklist.CHECKLIST.ASSET.HOST_IP = $host_ip

    # Get the MAC address(es) and set it in the checklist
    $host_mac = [string](($results.Benchmark.TestResult.'target-facts'.fact | where {$_.name -eq "urn:scap:fact:asset:identifier:mac"}).'#text' | where {$_ -notmatch "^00:00:00"})
    $checklist.CHECKLIST.ASSET.HOST_MAC = $host_mac

    # Get the FQDN and set it in the checklist
    $host_fqdn = ($results.Benchmark.TestResult.'target-facts'.fact | where {$_.name -eq "urn:scap:fact:asset:identifier:fqdn"}).'#text'
    $checklist.CHECKLIST.ASSET.HOST_FQDN = $host_fqdn


    # Get all the results and add them to the checklist
    $rule_results = $results.Benchmark.TestResult.'rule-result'

    foreach($rule_result in $rule_results){
        #Convert the xccdf idref to checklist Rule_ID
        $idref = $rule_result.idref
        if($idref -match "(SV-.*_rule)"){$rule_id = $Matches[1]}
        # Convert the xccdf result to checklist status.
        $result = $rule_result.result
        Switch ($result){
        pass {$status = "NotAFinding"}
        fail {$status = "Open"}
            }

        # Set the status in the checklist
        Write-Verbose "Setting the status of $rule_id to $status" -Verbose
        $checklist.CHECKLIST.STIGS.iSTIG.VULN.Where({$_.STIG_DATA.VULN_ATTRIBUTE -eq "Rule_ID" -and $_.STIG_DATA.ATTRIBUTE_DATA -eq $rule_id}).Item(0).STATUS = $status
        }

    # Now that we have set the values in the checklist. We'll write it to a file.
    # STIG checklist files need different xml writer settings that the one built in to PowerShell

    # Where to put it?
    # If the checklist file contains the hostname and the parameter WriteBackToChecklist is true, write the results to the checklist.
    # Else create a new file 
    if($NewChecklist){
        $out_file = "$OutPath\$(Get-Date -Format FileDate)-$host_name-populated.ckl"
        }
    else{
        $out_file = $CklFile
        }

    $xmlSettings = New-Object -TypeName System.Xml.XmlWriterSettings
    $xmlSettings.Indent = $true
    $xmlSettings.IndentChars = " "
    $xmlSettings.NewLineChars = "`n"
    $xmlWriter = [System.Xml.XmlWriter]::Create($out_file,$xmlSettings)
    Write-Verbose "Saving the results to $out_file" -Verbose
    $checklist.Save($xmlWriter)
    $xmlWriter.Close()

    }