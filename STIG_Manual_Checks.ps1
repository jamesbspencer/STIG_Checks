Remove-Variable * -ErrorAction SilentlyContinue
Get-Module -name WIN* | Remove-Module -ErrorAction SilentlyContinue
Remove-Module -name helpers -ErrorAction SilentlyContinue
. $PSScriptRoot/Create-Manifest.ps1

Try{
    Import-Module -Name $PSScriptRoot\helpers\helpers.psd1 -ErrorAction Stop -WarningAction SilentlyContinue
    }
Catch{
    Write-Host "Something went wrong importing the helper modules."
    exit
    }

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

#Read the config file and set the ini hashtable.
Read-ini

$output = New-Object System.Collections.Hashtable
foreach($server in $servers){
    Validate-Input -SERVER $server
    if($ver -eq "false"){
        Remove-Module -name helpers
        exit
        }
    else{Write-host "$server passed validation"}

    Try{Import-Module -Name $PSScriptRoot\$ver\$ver.psd1 -WarningAction SilentlyContinue -ErrorAction Stop}
    Catch{
        Write-Host "Something went wrong importing the STIG check functions."
        exit
        }
    $output[$server] = @{}
    $V_functions = (Get-Module -name $ver).ExportedCommands.Keys | Sort-Object {$_ -replace '\D+',""}
    foreach($V_function in $V_functions){
        $g_id = $V_function
        write-host "Processing $g_id  " -NoNewline -ForegroundColor Gray
        $g_stat = $null
        $g_stat = & $V_function -SERVER $server
        $timer = 0
        While($g_stat -eq $null){
            Start-Sleep -Milliseconds 500
            Write-Host "." -NoNewline -ForegroundColor Gray
            $timer++
            if($timer -eq "60"){
                Write-Host "Timeout on $g_id" -ForegroundColor Red
                Remove-Module -name $ver
                Remove-Module -name helpers
                exit
                }
            }
        $return = Write-Status -SERVER $server -ID $g_id -STATUS $g_stat
        $output[$server][$g_id] = $return
        }
    $output.$server | Out-File -FilePath "$PSScriptRoot\$(get-date -Format FileDateTime)-$server.txt"
    Remove-Module -Name $ver
}

if($ini.GLOBAL.POPULATE_CHECKLIST){Export-ResultsToChecklist -ARRAY $output}

Remove-Module -name helpers