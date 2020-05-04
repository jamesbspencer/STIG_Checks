<#
    .Synopsys
    Validates the server and sets the global variable 'ver'. 

    .Description
    Confirms the server is reachable, enumerates the OS, and confirms access.

    .INPUT
    The server name

    .OUTPUT
    The OS version or False

    .Parameter SERVER
    The server to validate.

    .Example
    Validate-Input -SERVER "server1"
#>

function Validate-Input{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SERVER
        )

    # Can we ping it?
    Try{
        $ping = Test-Connection -ComputerName $server -ErrorAction Stop
        $alive = $true
        }
    Catch{$alive = $false}

    # Let's finger that OS if it's alive.
    if($alive){
        $rttl = ($ping | Measure-Object -Property ResponseTimeToLive -Average).Average
        Switch ($rttl){
            {$_ -le 65 -or $_ -gt 128}{
                $os = "UNX"
                Write-Verbose "$os"
                }
            {$_ -gt 65 -and $_ -le 128}{
                $os = "WIN"
                Write-Verbose "$os"
                }
            }
        }
    if($os -eq "WIN"){

        Try{
            $test = Get-WmiObject win32_operatingsystem -ComputerName $SERVER -ErrorAction Stop
            if($test.Version -match "^6.3*" -and $test.ProductType -eq "3"){$return = "WIN2012R2"}
            elseif($test.Version -match "^10.0*" -and $test.ProductType -eq "3"){$return = "WIN2016"}
            elseif($test.Version -match "^6.1*" -and $test.ProductType -eq "3"){$return = "WIN2008R2"}
            else{
                Write-Verbose "The OS Version, $test.Version, is not supported"
                $return =  $false
                }
            }
        Catch{
            Write-Verbose "Cannot manage $SERVER with WMI"
            $return = $false
            }
        Try{
            $test_wsman = Test-WSMan -ComputerName $SERVER -ErrorAction Stop
            }
        Catch{
            $error = [System.Windows.MessageBox]::Show("Cannot manage $SERVER with WS MAN. Would you like to try and fix it?","Error",'YesNo','Error')
            if($error -eq "Yes"){
                $fix = Fix-WsmanWithWmi -SERVER $SERVER
                if($fix -ne "true"){
                    $return = $false
                    }
                }
            else{
                $return = $false
                }
            }
        }
    elseif($os -eq "UNX" -and $ini.PUTTY.USE_JUMP_SERVER -eq $false){
        # The Module Use-Plink should be loaded.
        #Do we have a key for the server?
        Write-Verbose "Not using jump server"
        $reg_key = $(Get-ItemProperty -Path HKCU:\Software\SimonTatham\PuTTY\SshHostKeys) -match $server
        if(! $reg_key){echo y | plink -load $server}

        $version = Use-Plink -SERVER $server -COMMAND "cat /etc/*release"
        if($version -match "Linux"){
            if($version -match "7."){$return = "RHEL7"}
            elseif($version -match "6."){$return = "RHEL6"}
            }
        elseif($version -match "Solaris"){
            if($version -match "11."){$return = "SOL11"}
            elseif($version -match "10."){$return = "SOL10"}
            }
        }
    #If we couldn't ping it, but we're using a jump proxy, it must be a UNIX box. 
    elseif($ini.PUTTY.USE_JUMP_SERVER){
        Write-Verbose "Using a jump server"
        #Do we have a key for the server?
        $reg_key = $(Get-ItemProperty -Path HKCU:\Software\SimonTatham\PuTTY\SshHostKeys) -match $server
        if(! $reg_key){echo y | plink -load $($ini.PUTTY.JUMP_SERVER_PROXY) $server}

        $version = Use-Plink -JUMP $($ini.PUTTY.JUMP_SERVER_PROXY) -SERVER $server -COMMAND "cat /etc/*release"
        Write-Verbose "The server version is: $version"
        if($version -match "Linux"){
            if($version -match "7."){$return = "RHEL7"}
            elseif($version -match "6."){$return = "RHEL6"}
            }
        elseif($version -match "Solaris"){
            if($version -match "11."){$return = "SOL11"}
            elseif($version -match "10."){$return = "SOL10"}
            }
        else{$return = $false}
        }
    return $return
}
Export-ModuleMember -Function Validate-Input