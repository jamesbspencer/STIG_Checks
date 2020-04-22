Remove-Variable * -ErrorAction SilentlyContinue

$server = "10.10.223.86"
$num = Read-host -Prompt "Which function number?"
$id = "V-$num"
$test = "e"

. $PSScriptRoot/Create-Manifest.ps1

write-host "Importing Modules"
Import-Module -Name $PSScriptRoot\helpers\helpers.psd1 -Verbose

write-host "Reading ini"
Read-ini

write-host "Validating the server"
$local_ver = Validate-Input $server
if($local_ver -eq $false){
    Write-Host "Something went wrong with Validate-Input"
    Remove-Module -Name helpers
    exit
    }
Write-Host "The server version is: $local_ver"


#Check the ini.
if($ini.keys -match $local_ver -and $ini.$local_ver.Keys -match $id){
    write-host "Matched in the ini"
    if($ini.$local_ver.$id -match "^T"){$test = "b"}
    elseif($ini.$local_ver.$id -match "^F"){$test = "a"}
    elseif($ini.$local_ver.$id -match "^N"){$test = "c"}
    else{$test = "d"}
    }
else{
    $item = Get-ChildItem -Path $PSScriptRoot\$local_ver\$id.txt
    Write-Host "The file to run is: $item"


    # Test must return a = OPEN, b = NOT A FINDING, c = NOT APPLICABLE, or c 
    if($ini.PUTTY.USE_JUMP_SERVER){
        $test = Use-Plink -JUMP $ini.PUTTY.JUMP_SERVER_PROXY -SERVER $server -COMMAND $item
        }
    else{
        $test = Use-Plink -LOAD $server -COMMAND $item
        }

    if($test -notmatch "[a-d]"){
        Write-Host "Check your script"
        }
    }
    
Write-Status -SERVER $server -ID $id -STATUS $test

write-host "Removing functions"
Remove-Module -Name helpers
