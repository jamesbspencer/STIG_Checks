# Path to the STIG Manual XCCDF XML file. 
$xmlpath = "\\user-smb4.local.altess.army.mil\windows_ops\RDP\Users\SpencerJ\STIG Checklists\U_RedHat_6_V1R24_STIG\U_RedHat_6_V1R24_Manual_STIG\U_RedHat_6_STIG_V1R24_Manual-xccdf.xml"

# Output directory
$outdir = "$PSScriptRoot\checklists"

# List of servers
$servers = "radfa0a31v12035","radfa0a31v12036","RADFW6DYL1PX314"

# Today's date
$date = Get-date -Format FileDate

# Get the STIG OS from the file name
$stig_os = ((Split-Path $xmlpath -Leaf) -split "_")[1] + "_" + ((Split-Path $xmlpath -Leaf) -split "_")[2]

# Get the STIG Version from the file name
$stig_ver = ((Split-Path $xmlpath -Leaf) -split "_")[4]


# Try to import the module or exit.
Try{
    Import-Module "$PSScriptRoot\New-ChecklistTemplate.psm1" -Verbose -ErrorAction Stop
    }
Catch{
    Write-Host "Import module failed"
    exit
    }

# Make the output directory if it doesn't exist
if( -not (Test-Path $outdir)){
    New-Item -Path $outdir -ItemType Directory
    }

# Show the imported module.
Get-Module New-ChecklistTemplate


foreach($server in $servers){
    write-host $server
    $outpath = "$outdir\$date-$server-$stig_os-$stig_ver.ckl"
    New-ChecklistTemplate -XccdfPath $xmlpath -OutputPath $outpath -Hostname $server
    }

# Unload the module
Remove-Module New-ChecklistTemplate -ErrorAction SilentlyContinue