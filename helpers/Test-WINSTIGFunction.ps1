$server = Read-Host -Prompt "Server name?"
$num = Read-host -Prompt "Which function number?"
$item = Get-ChildItem $PSScriptRoot\*\*-$num.psm1 -Recurse
$test = "e"

. $PSScriptRoot/Create-Manifest.ps1

Import-Module -Name $PSScriptRoot\helpers\helpers.psd1 -Verbose
Import-Module -name $item -Verbose -ErrorAction SilentlyContinue
Get-Module

Read-ini

$local_ver = Validate-Input $server

$function = "V-$num"

$test = & $function -SERVER $server
write-status -SERVER $server -ID $function -STATUS $test


Remove-Module -Name helpers
Remove-module -name $function -ErrorAction SilentlyContinue
