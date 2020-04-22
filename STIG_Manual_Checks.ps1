## Script create STIG checklists. 

#Requires -RunAsAdministrator

#Cleanup from a previous run in the same session.
Remove-Variable * -ErrorAction SilentlyContinue
Get-Module -name WIN* | Remove-Module -ErrorAction SilentlyContinue
Remove-Module -name helpers -ErrorAction SilentlyContinue

# Create new manifest files for all the psm1 modules. 
. $PSScriptRoot/helpers/Create-Manifest.ps1

# Try to import the helper modules. Without them nothing can continue.
Try{
    Import-Module -Name $PSScriptRoot\helpers\helpers.psd1 -ErrorAction Stop -WarningAction SilentlyContinue -InformationAction SilentlyContinue
    }
Catch{
    Write-Host "Something went wrong importing the helper modules."
    exit
    }

# See if we passed a server name from the command line. If not, prompt for a server name or text file server list. 
if(!$args[0]){
    $ques = [System.Windows.MessageBox]::Show('Do you want to enter a server name or list?','Input','YesNo','Question')
    Switch ($ques){
        yes{
            $input_box = Get-InputBox -prompt "Enter a Computer name or path to a list"
            if($input_box -match ".txt$"){
                $servers = Get-Content -Path $input_box
                }
            else{
                $servers = $input_box
                }
            }
        no{
            exit
            }
        }
    }
else{$servers = $args[0]}

# Read the config file and set the ini hashtable
Read-ini

# Set whether there is verbose output. 
if($ini.GLOBAL.VERBOSE -eq "True"){$VerbosePreference = "Continue"}

# Create a hash file to put our output in. Needed to populate the checklist later. 
$output = New-Object System.Collections.Hashtable

# Loop through each server. With a big enough server, would be a good place for a parallel statement.
foreach($server in $servers){
    
    # Make sure we can connect to the server. 
    $ver = Validate-Input -SERVER $server
    if($ver -eq $false){
        Write-Verbose "$server failed validation"
        continue
        }
    else{
        Write-Verbose "$server, $ver,  passed validation"
        }


    #Add the server to the output array
    $output[$server] = @{}

    Write-Verbose "Processing the VULs from the ini"
    # Process the STIG items in the ini file.
    $keys = $ini.Keys
    $keys = $ini.Keys
    foreach($key in $keys){
        if($key -match $ver){
            $sub_keys = $ini.$key.keys
            foreach($sub_key in $sub_keys){
                $sub_key_value = $ini.$key.$sub_key
                $status = ($sub_key_value -split "[,-]")[0]
                $finding = ($sub_key_value -split "[,-]")[1]
                $comment = ($sub_key_value -split "[,-]")[2]
                Switch ($status){
                    {$_ -match "^T"}{$return = "NotAFinding,$finding,$comment"}
                    {$_ -match "^F"}{$return = "Open,$finding,$comment"}
                    {$_ -match "^N"}{$return = "Not_Applicable,$finding,$comment"}
                    Default {$return = "Not_Reviewed,$finding,$comment"}
                    }
                $output[$server][$sub_key] = $return
                }
            }
        }
    Write-Verbose "Processing the Manual Checks"
    ## Run through the manual checks.
    # For the Windows systems.
    if($ver -match "WIN"){

        Try{Import-Module -Name $PSScriptRoot\$ver\$ver.psd1 -WarningAction SilentlyContinue -ErrorAction Stop}
        Catch{
            Write-Verbose "Something went wrong importing the STIG check functions."
            exit
            }
        
        $V_functions = (Get-Module -name $ver).ExportedCommands.Keys | Sort-Object {$_ -replace '\D+',""}
        foreach($V_function in $V_functions){
            $g_id = $V_function
            Write-Verbose "Processing $g_id"
            $g_stat = $null
            $g_stat = & $V_function -SERVER $server
            $timer = 0
            While($g_stat -eq $null){
                Start-Sleep -Milliseconds 500
                Write-Verbose "."
                $timer++
                if($timer -eq "60"){
                    Write-Verbose "Timeout on $g_id"
                    Remove-Module -name $ver
                    Remove-Module -name helpers
                    exit
                    }
                }
            $return = Write-Status -SERVER $server -ID $g_id -STATUS $g_stat
            $output[$server][$g_id] = $return
            }
        Remove-Module -Name $ver
        }
    # For the Unix systems.
    elseif($ver -notmatch "WIN"){

            ## Need to implement the ini file. 

            # The Use-Plink module should already be loaded.
            $cmd_files = Get-ChildItem -Path "$PSScriptRoot\$ver\V*.txt"
            foreach($cmd_file in $cmd_files){
                $v_id = $cmd_file.Name -replace ".txt",""
                $status = $null
                if($ini.PUTTY.USE_JUMP_SERVER){
                    $status = Use-Plink -JUMP $ini.PUTTY.JUMP_SERVER_PROXY -Server $server -COMMAND $cmd_file
                    }
                else{
                    $status = Use-Plink -LOAD $server -COMMAND $cmd_file
                    }
                $return = Write-Status -SERVER $server -ID $v_id -STATUS $status
                $output[$server][$v_id] = $return
                } #End foreach cmd_file
        } # End UNX
    $output.$server | Out-File -FilePath "$PSScriptRoot\$(get-date -Format FileDateTime)-$server.txt"
}

if($ini.GLOBAL.POPULATE_CHECKLIST){Export-ResultsToChecklist -ARRAY $output}

Remove-Module -name helpers