$folders = Get-ChildItem $PSScriptRoot -Directory

foreach($folder in $folders){
    Clear-Variable -Name nested_modules -ErrorAction SilentlyContinue
    $nested_modules = @()
    $modules = Get-ChildItem -Path "$PSScriptRoot\$folder\*.psm1"
    foreach($module in $modules){
        $nested_modules += $module.Name
        }
        
        $manifest = @{
            Author = "James Spencer"
            ModuleVersion = '0.0.1'
            Path = "$PSScriptRoot\$folder\$folder.psd1"
            FunctionsToExport = '*'
            NestedModules = $nested_modules
        }

    New-ModuleManifest @manifest
    }