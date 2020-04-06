$server = "RADFB7111V11896"
$num = Read-host -Prompt "Which function number?"
$item = Get-ChildItem $PSScriptRoot\*\*-$num.psm1 -Recurse
$test = "d"

Import-Module -Name $PSScriptRoot\helpers\Write-Status.psm1 -Verbose
Import-Module -name $item -Verbose -ErrorAction SilentlyContinue
Get-Module

$function = "V-$num"

$test = & $function -SERVER $server
write-status -SERVER $server -ID $function -STATUS $test


Remove-Module -Name Write-Status
Remove-module -name $function -ErrorAction SilentlyContinue
