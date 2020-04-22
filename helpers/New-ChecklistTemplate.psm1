# Converts XCCDF Manual XML to Checklist
# XCCDF Manual XMLs: https://public.cyber.mil/stigs/downloads/?_dl_facet_stigs=operating-systems
# Derived/Borrowed from https://github.com/microsoft/PowerStig/blob/dev/Module/STIG/Functions.Checklist.ps1
# and from https://github.com/microsoft/PowerStig/blob/dev/Module/Common/Function.Xccdf.ps1

<#
    .SYNOPSIS
        Automatically creates a Stig Viewer checklist from the XCCDF Manual XML

    .PARAMETER XccdfPath
        The path to the matching xccdf file. 

    .PARAMETER OutputPath
        The location you want the checklist saved to.

    .PARAMETER Hostname
        The hostname to add to the file.

    .EXAMPLE
        New-StigCheckList -XccdfPath $xccdfPath -OutputPath $outputPath
    
#>
function New-ChecklistTemplate {
    [CmdletBinding()]
    [OutputType([xml])]
    param(

        [Parameter(Mandatory = $true)]
        [string]
        $XccdfPath,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $OutputPath,

        [Parameter(Mandatory = $false)]
        [string]
        $Hostname

    )

     # Validate parameters before continuing
    if (-not (Test-Path -Path $OutputPath.DirectoryName)){
        throw "$($OutputPath.DirectoryName) is not a valid directory. Please provide a valid directory."
    }

    if ($OutputPath.Extension -ne '.ckl'){
        throw "$($OutputPath.FullName) is not a valid checklist extension. Please provide a full valid path ending in .ckl"
    }

    # New XML writer to store the output.
    $xmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
    $xmlWriterSettings.Indent = $true
    $xmlWriterSettings.IndentChars = " "
    $xmlWriterSettings.NewLineChars = "`n"
    $writer = [System.Xml.XmlWriter]::Create($OutputPath.FullName, $xmlWriterSettings)

    $xccdfBenchmarkContent = Get-StigXccdfBenchmarkContent -Path $xccdfPath

    $writer.WriteStartElement('CHECKLIST')

    #region ASSET

    $writer.WriteStartElement("ASSET")

    $assetElements = [ordered] @{
        'ROLE'            = 'None'
        'ASSET_TYPE'      = 'Computing'
        'HOST_NAME'       = "$Hostname"
        'HOST_IP'         = ''
        'HOST_MAC'        = ''
        'HOST_FQDN'       = ''
        'TECH_AREA'       = ''
        'TARGET_KEY'      = $xccdfBenchmarkContent.Group[0].Rule.reference.identifier
        'WEB_OR_DATABASE' = 'false'
        'WEB_DB_SITE'     = ''
        'WEB_DB_INSTANCE' = ''
    }

    foreach ($assetElement in $assetElements.GetEnumerator())
    {
        $writer.WriteStartElement($assetElement.name)
        $writer.WriteString($assetElement.value)
        $writer.WriteEndElement()
    }

    $writer.WriteEndElement(<#ASSET#>)

    #endregion ASSET

    $writer.WriteStartElement("STIGS")
    $writer.WriteStartElement("iSTIG")

    #region STIGS/iSTIG/STIG_INFO

    $writer.WriteStartElement("STIG_INFO")

    #$xccdfBenchmarkContent = Get-StigXccdfBenchmarkContent -Path $xccdfPath

    $stigInfoElements = [ordered] @{
        'version'        = $xccdfBenchmarkContent.version
        'classification' = 'UNCLASSIFIED'
        'customname'     = ''
        'stigid'         = $xccdfBenchmarkContent.id
        'description'    = $xccdfBenchmarkContent.description
        'filename'       = Split-Path -Path $xccdfPath -Leaf
        'releaseinfo'    = $xccdfBenchmarkContent.'plain-text'.InnerText
        'title'          = $xccdfBenchmarkContent.title
        'uuid'           = (New-Guid).Guid
        #'notice'         = $xccdfBenchmarkContent.notice.InnerText
        'notice'         = $xccdfBenchmarkContent.notice.id
        'source'         = $xccdfBenchmarkContent.reference.source
    }

    foreach ($StigInfoElement in $stigInfoElements.GetEnumerator())
    {
        $writer.WriteStartElement("SI_DATA")

        $writer.WriteStartElement('SID_NAME')
        $writer.WriteString($StigInfoElement.name)
        $writer.WriteEndElement(<#SID_NAME#>)

        $writer.WriteStartElement('SID_DATA')
        $writer.WriteString($StigInfoElement.value)
        $writer.WriteEndElement(<#SID_DATA#>)

        $writer.WriteEndElement(<#SI_DATA#>)
    }

    $writer.WriteEndElement(<#STIG_INFO#>)
    
    #endregion STIGS/iSTIG/STIG_INFO

    #region STIGS/iSTIG/VULN[]

    $vulnerabilities = Get-VulnerabilityList -XccdfBenchmark $xccdfBenchmarkContent

    foreach ($vulnerability in $vulnerabilities){
        $writer.WriteStartElement("VULN")

        foreach ($attribute in $vulnerability.GetEnumerator()){
            #$status = $null
            $status = "Not_Reviewed"
            $findingDetails = $null
            $comments = $null
            $manualCheck = $null

            if ($attribute.Name -eq 'Vuln_Num'){
                $vid = $attribute.Value
                }

            $writer.WriteStartElement("STIG_DATA")

            $writer.WriteStartElement("VULN_ATTRIBUTE")
            $writer.WriteString($attribute.Name)
            $writer.WriteEndElement(<#VULN_ATTRIBUTE#>)

            $writer.WriteStartElement("ATTRIBUTE_DATA")
            $writer.WriteString($attribute.Value)
            $writer.WriteEndElement(<#ATTRIBUTE_DATA#>)

            $writer.WriteEndElement(<#STIG_DATA#>)
            } #End foreach attribute

        $writer.WriteStartElement("STATUS")
        $writer.WriteString($status)
        $writer.WriteEndElement(<#STATUS#>)

        $writer.WriteStartElement("FINDING_DETAILS")
        $writer.WriteString($findingDetails)
        $writer.WriteEndElement(<#FINDING_DETAILS#>)

        $writer.WriteStartElement("COMMENTS")
        $writer.WriteString($comments)
        $writer.WriteEndElement(<#COMMENTS#>)

        $writer.WriteStartElement("SEVERITY_OVERRIDE")
        $writer.WriteString('')
        $writer.WriteEndElement(<#SEVERITY_OVERRIDE#>)

        $writer.WriteStartElement("SEVERITY_JUSTIFICATION")
        $writer.WriteString('')
        $writer.WriteEndElement(<#SEVERITY_JUSTIFICATION#>)

        $writer.WriteEndElement(<#VULN#>)

        } #End foreach vulnerability

    #endregion STIGS/iSTIG/VULN[]

    $writer.WriteEndElement(<#iSTIG#>)
    $writer.WriteEndElement(<#STIGS#>)
    $writer.WriteEndElement(<#CHECKLIST#>)
    $writer.Flush()
    $writer.Close()

    } #End function New-ChecklistTemplate

Export-ModuleMember -Function New-ChecklistTemplate


<#
    .SYNOPSIS
        Gets the vulnerability details from the rule description
#>

function Get-VulnerabilityList
{
    [CmdletBinding()]
    [OutputType([xml])]
    param
    (
        [Parameter()]
        [psobject]
        $XccdfBenchmark
    )

    [System.Collections.ArrayList] $vulnerabilityList = @()

    foreach ($vulnerability in $XccdfBenchmark.Group)
    {
        [xml]$vulnerabiltyDiscussionElement = "<discussionroot>$($vulnerability.Rule.description)</discussionroot>"

        [void] $vulnerabilityList.Add(
            @(
                [PSCustomObject]@{Name = 'Vuln_Num'; Value = $vulnerability.id},
                [PSCustomObject]@{Name = 'Severity'; Value = $vulnerability.Rule.severity},
                [PSCustomObject]@{Name = 'Group_Title'; Value = $vulnerability.title},
                [PSCustomObject]@{Name = 'Rule_ID'; Value = $vulnerability.Rule.id},
                [PSCustomObject]@{Name = 'Rule_Ver'; Value = $vulnerability.Rule.version},
                [PSCustomObject]@{Name = 'Rule_Title'; Value = $vulnerability.Rule.title},
                [PSCustomObject]@{Name = 'Vuln_Discuss'; Value = $vulnerabiltyDiscussionElement.discussionroot.VulnDiscussion},
                [PSCustomObject]@{Name = 'IA_Controls'; Value = $vulnerabiltyDiscussionElement.discussionroot.IAControls},
                [PSCustomObject]@{Name = 'Check_Content'; Value = $vulnerability.Rule.check.'check-content'},
                [PSCustomObject]@{Name = 'Fix_Text'; Value = $vulnerability.Rule.fixtext.InnerText},
                [PSCustomObject]@{Name = 'False_Positives'; Value = $vulnerabiltyDiscussionElement.discussionroot.FalsePositives},
                [PSCustomObject]@{Name = 'False_Negatives'; Value = $vulnerabiltyDiscussionElement.discussionroot.FalseNegatives},
                [PSCustomObject]@{Name = 'Documentable'; Value = $vulnerabiltyDiscussionElement.discussionroot.Documentable},
                [PSCustomObject]@{Name = 'Mitigations'; Value = $vulnerabiltyDiscussionElement.discussionroot.Mitigations},
                [PSCustomObject]@{Name = 'Potential_Impact'; Value = $vulnerabiltyDiscussionElement.discussionroot.PotentialImpacts},
                [PSCustomObject]@{Name = 'Third_Party_Tools'; Value = $vulnerabiltyDiscussionElement.discussionroot.ThirdPartyTools},
                [PSCustomObject]@{Name = 'Mitigation_Control'; Value = $vulnerabiltyDiscussionElement.discussionroot.MitigationControl},
                [PSCustomObject]@{Name = 'Responsibility'; Value = $vulnerabiltyDiscussionElement.discussionroot.Responsibility},
                [PSCustomObject]@{Name = 'Security_Override_Guidance'; Value = $vulnerabiltyDiscussionElement.discussionroot.SeverityOverrideGuidance},
                [PSCustomObject]@{Name = 'Check_Content_Ref'; Value = $vulnerability.Rule.check.'check-content-ref'.href},
                [PSCustomObject]@{Name = 'Weight'; Value = $vulnerability.Rule.Weight},
                [PSCustomObject]@{Name = 'Class'; Value = 'Unclass'},
                [PSCustomObject]@{Name = 'STIGRef'; Value = "$($XccdfBenchmark.title) :: $($XccdfBenchmark.'plain-text'.InnerText)"},
                [PSCustomObject]@{Name = 'TargetKey'; Value = $vulnerability.Rule.reference.identifier}

                # Some Stigs have multiple Control Correlation Identifiers (CCI)
                $(
                    # Extract only the cci entries
                    $CCIREFList = $vulnerability.Rule.ident |
                    Where-Object {$PSItem.system -eq 'http://iase.disa.mil/cci'} |
                    Select-Object 'InnerText' -ExpandProperty 'InnerText'

                    foreach ($CCIREF in $CCIREFList)
                    {
                        [PSCustomObject]@{Name = 'CCI_REF'; Value = $CCIREF}
                    }
                )
            )
        )
    }

    return $vulnerabilityList
}


<#
    .SYNOPSIS
        Returns the benchmark element from the xccdf xml document.
    .PARAMETER Path
        The literal path to the the zip file that contain the xccdf or the specifc xccdf file.
#>
function Get-StigXccdfBenchmarkContent
{
    [CmdletBinding()]
    [OutputType([xml])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    if (-not (Test-Path -Path $path))
    {
        Throw "The file $path was not found"
    }

    if ($path -like "*.zip")
    {
        [xml] $xccdfXmlContent = Get-StigContentFromZip -Path $path
    }
    else
    {
        [xml] $xccdfXmlContent = Get-Content -Path $path -Encoding UTF8
    }

    $xccdfXmlContent.Benchmark
}

#Export-ModuleMember -Function Get-StigXccdfBenchmarkContent

<#
    .SYNOPSIS
        Extracts the xccdf file from the zip file provided from the DISA website.
    .PARAMETER Path
        The literal path to the zip file.
#>
function Get-StigContentFromZip
{
    [CmdletBinding()]
    [OutputType([xml])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    # Create a unique path in the users temp directory to expand the files to.
    $zipDestinationPath = "$((Split-Path -Path $path -Leaf) -replace '.zip','').$((Get-Date).Ticks)"
    Expand-Archive -LiteralPath $path -DestinationPath $zipDestinationPath
    # Get the full path to the extracted xccdf file.
    $getChildItem = @{
        Path = $zipDestinationPath
        Filter = "*Manual-xccdf.xml"
        Recurse = $true
    }

    $xccdfPath = (Get-ChildItem @getChildItem).fullName
    # Get the xccdf content before removing the content from disk.
    $xccdfContent = Get-Content -Path $xccdfPath
    # Cleanup to temp folder
    Remove-Item $zipDestinationPath -Recurse -Force

    $xccdfContent
}
