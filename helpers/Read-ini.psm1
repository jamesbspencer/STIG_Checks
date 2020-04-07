<#
    .SYNOPSIS
    Function to read an ini file and convert it to a hashtable

    .DESCRIPTION
    Function to read an ini file and convert it to a hashtable

    .OUTPUTS
    Outputs a hash table

    .EXAMPLE
    Read-ini

#>

function Read-ini {
    $ini_file = "$PSScriptRoot\..\options.ini"
    $ini = New-Object -TypeName System.Collections.Hashtable
    switch -Regex -File $ini_file {
        "^\[(.+)\]$" #Section
            {
                $section = $matches[1]
                $ini[$section] = @{}
            }
        "^(#\s)"  #Comment (ignore)
            {
            continue
            }
        "(.+?)\s*=(.*)" #Key
            {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
            }
        }
    $Global:ini = $ini
    }
Export-ModuleMember -Function Read-ini