Remove-Variable * -ErrorAction SilentlyContinue
Get-Module -name WIN* | Remove-Module -ErrorAction SilentlyContinue
Remove-Module -name helpers -ErrorAction SilentlyContinue

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

$output = New-Object System.Collections.ArrayList
foreach($server in $servers){
    $ver = Validate-Input -SERVER $server
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
    $s_output = New-Object System.Collections.ArrayList
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
        [void]$s_output.Add($server)
        [void]$s_output.Add($g_id)
        [void]$s_output.Add($return)
        [void]$output.Add($s_output)
        }

    Remove-Module -Name $ver
}

Remove-Module -name helpers

$output | Out-File -FilePath "$PSScriptRoot\$(get-date -Format FileDateTime).txt"