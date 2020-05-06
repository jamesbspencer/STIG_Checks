## Example script to show how to use the function Save-SCAPToChecklist.psm1

# Try to import the module. If not, exit.
Try{
    Import-Module "$PSScriptRoot\Save-SCAPToChecklist.psm1" -Verbose -ErrorAction Stop
    }
Catch{
    Throw "Import Module failed. Exiting."
    }

# See, it's loaded.
Get-Module -Name Save-ScapToChecklist

# List of servers
$servers = "server1","server2","server3"

# Where our SCAP XCCDF Results files are located.
$scap_path = "\"

# Where our Checklist template or Checklists are being stored. 
$checklist_folder = "$PSScriptRoot\checklists"

# Loop through our servers.
foreach($server in $servers){
    write-host $server

    # Get the server's SCAP file
    $scap_file = (Get-ChildItem -Path "$scap_path\*$server*.xml").FullName
    # Is it really there?
    if(-not (Test-Path $scap_file)){throw "SCAP file doesn't exist"}

    # Get the checklist file.
    $ckl_file = (Get-ChildItem -Path "$checklist_folder\*$server*.ckl").FullName
    # Is it really there?
    if(-not (Test-Path $ckl_file)){throw "Checklist file doesn't exist"}

    # Lets combine the two.
    # If we wanted to overwrite the files we have, or use a single checklist template. We would run this:
    # Save-SCAPToChecklist -SCAPFile $scap_file -Checklist $ckl_file

    # Let's create new checklist files
    Save-SCAPToChecklist -SCAPFile $scap_file -CklFile $ckl_file -NewChecklist -OutPath $checklist_folder
    }

# Open file explorer when finished.
explorer $checklist_folder


# Remove the module when finished. 
Remove-Module -Name Save-SCAPToChecklist -ErrorAction SilentlyContinue