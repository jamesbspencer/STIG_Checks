<#
    .Synopsys
    Manual STIG check V-40178 - Root Directory Permissions

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40178 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
    $result = "b"
    $array = @(
        ("SYSTEM","FullControl","ContainerInherit, ObjectInherit","None"),
        ("Administrators","FullControl","ContainerInherit, ObjectInherit","None"),
        ("Users","ReadandExecute","ContainerInherit, ObjectInherit","None"),
        ("Users","AppendData","ContainerInherit","None"),
        ("Users","CreateFiles","ContainerInherit","InheritOnly"),
        ("CREATOR OWNER","FullControl","ContainerInherit, ObjectInherit","InheritOnly")
        )

    $array2 = [System.Collections.ArrayList]@()
    $acl = Get-Acl -Path \\$server\c$
    $perms = $acl.Access
    foreach($perm in $perms){
        $temp_array = [System.Collections.ArrayList]@()
        if($perm.IdentityReference.Value -match "\\"){
            [void]$temp_array.Add(($perm.IdentityReference.Value -split "\\")[1])
            }
        else{
            [void]$temp_array.Add($perm.IdentityReference.Value)
            }
        if($perm.FileSystemRights -match '[ -~][0-9]'){
            Switch($perm.FileSystemRights){
                268435456 {$rights = "FullControl"}
                -536805376 {$rights = "Modify"}
                -1610612736 {$fights = "ReadandExecute"}
                }
            }
        else{$rights = ($perm.FileSystemRights -split ",")[0]}
        [void]$temp_array.Add($rights)
        [void]$temp_array.Add($perm.InheritanceFlags)
        [void]$temp_array.Add($perm.PropagationFlags)
        [void]$array2.Add($temp_array)
        }
    $compare = Compare-Object -ReferenceObject $array2 -DifferenceObject $array
    if($compare.count -gt "0"){
        $result = "a"
        }
    
    return $result
    }
Export-ModuleMember -Function V-40178
#Run Create-Manifest.ps1 when finished. 