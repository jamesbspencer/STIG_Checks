$folders = Get-ChildItem ((Get-Item $PSScriptRoot).Parent).FullName -Directory -Exclude "RHEL*"

foreach($folder in $folders){
    Clear-Variable -Name nested_modules -ErrorAction SilentlyContinue
    $nested_modules = @()
    $modules = Get-ChildItem -Path "$folder\*.psm1"
    foreach($module in $modules){
        $nested_modules += $module.Name
        }
        
        $manifest = @{
            Author = "James Spencer"
            ModuleVersion = '0.0.1'
            Path = "$folder\$($folder.Name).psd1"
            FunctionsToExport = '*'
            NestedModules = $nested_modules
        }

    New-ModuleManifest @manifest
    }