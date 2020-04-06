<#
    .Synopsys
    Manual STIG check V-40177 - Program File Directory Permissions

    .Parameter SERVER
    The server to test

    .Example
    function_name -SERVER server1
#>

function V-40177 {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )
        $result = "b"
        $array = @(
            ("TrustedInstaller","FullControl","ContainerInherit","None"),
            ("SYSTEM","FullControl","ContainerInherit, ObjectInherit","InheritOnly"),
            ("SYSTEM","Modify","None","None"),
            ("Administrators","Modify","None","None"),
            ("Administrators","FullControl","ContainerInherit, ObjectInherit","InheritOnly"),
            ("Users","ReadandExecute","ContainerInherit, ObjectInherit","None"),
            ("CREATOR OWNER","FullControl","ContainerInherit, ObjectInherit","InheritOnly"),
            ("ALL APPLICATION PACKAGES","ReadAndExecute","ContainerInherit, ObjectInherit","None")
            )
        Write-Host $array
        $folders = "Program Files", "Program Files (x86)"
        foreach($folder in $folders){
            $array2 = [System.Collections.ArrayList]@()
            $acl = Get-Acl -Path \\$server\c$\$folder
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
            write-host $array2
            $compare = Compare-Object -ReferenceObject $array2 -DifferenceObject $array
            write-host $compare
            if($compare.count -gt "0"){
                $result = "a"
                }
            }
        return $result
    }
Export-ModuleMember -Function V-40177
#Run Create-Manifest.ps1 when finished. 