<#
    .Synopsys
    Manual STIG check V-3245 - File share ACLs

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-3245 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "c"
    $shares = Invoke-Command -ComputerName $server -ScriptBlock {Get-SmbShare}
    foreach($share in $shares){
        if($share.Special -eq $false){
            $result = "b"
            $perms = Invoke-Command -ComputerName $server -ScriptBlock {Param($share) Get-SmbShareAccess -name $share} -ArgumentList $share.Name
            foreach ($perm in $perms){
                if($perm.AccountName -match "Everyone"){
                    $result = "a"
                    }
                }
            }
        }
    return $result
    }
Export-ModuleMember -Function V-3245
#Run Create-Manifest.ps1 when finished. 