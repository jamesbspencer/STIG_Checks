<#
    .Synopsys
    A wrapper for Putty plink.

    .Description
    This function requires the use of Putty saved sessions. 
    A special session must be created to use a jump server.
    A separate function will be available to create the jump function.

    .Parameter SERVER
    Mandatory: The server name to use

    .Parameter LOAD
    Mandatory The Putty saved session to use with Plink.

    .Parameter AGENT
    Determins if pageant will be used.

    .Paramter JUMP
    Optional paramter to specify if a jump server is to be used.

    .Paramter COMMAND
    The shell command or path to a file with commands.

    .Output return
    The result of the commands
    

    .Example
    Use-Plink 
#>
function Use-Plink {
    #Input parameters
    Param(
        [Parameter(Mandatory=$true,ParameterSetName="Jump")]
        [String]
        $SERVER,
        [Parameter(Mandatory=$true,ParameterSetName="Load")]
        [String]
        $LOAD,
        [Parameter(Mandatory=$false)]
        [Switch]
        $AGENT,
        [Parameter(Mandatory=$true,ParameterSetName="Jump")]
        [String]
        $JUMP,
        [Parameter(Mandatory=$true)]
        [String]
        $COMMAND
        )
    #Set the array for plink options.
    $opts = New-Object -TypeName System.Collections.ArrayList
    # We don't want prompts
    [void]$opts.Add("-batch")

    # See if we're using pageant.
    if($AGENT){
        Try{
            get-command -name pageant -ErrorAction Stop | Out-Null
            Get-Process -name pageant -ErrorAction stop | Out-Null
            [void]$opts.Add("-agent")
            }
        Catch{
            Write-Verbose "Pageant isn't installed or wasn't running"
            return $false
            }
        }
    # Let's load a saved session
    [void]$opts.Add("-load")

    #Are we using a jump server?
    if($JUMP){
        [void]$opts.Add("$JUMP")
        [void]$opts.Add("$SERVER")
        }
    elseif($LOAD){
        [void]$opts.Add("$LOAD")
        }

    # Command or file?
    if(Test-Path $COMMAND -ErrorAction SilentlyContinue){
        [void]$opts.Add("-m")
        [void]$opts.Add("$COMMAND")
        }
    else{
        [void]$opts.Add("$COMMAND")
        }
    Write-Verbose "Plink options: $opts"
    # At the plink part.
    Try{    
        # Plink installed?
        Get-Command -Name plink -ErrorAction Stop | Out-Null
        #$output = plink $opts
        $processinfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
        $processinfo.FileName = "plink.exe"
        $processinfo.RedirectStandardError = $true
        $processinfo.RedirectStandardOutput = $true
        $processinfo.UseShellExecute = $false
        $processinfo.Arguments = $opts
        $process = New-Object -TypeName System.Diagnostics.Process
        $process.StartInfo = $processinfo
        $process.Start() | Out-Null
        $process.WaitForExit()
        $output = $process.StandardOutput.ReadToEnd()
        $errors = $process.StandardError.ReadToEnd()

        Write-Verbose "Plink output: $output" -Verbose
        $result = ($output.split([System.Environment]::NewLine))[-1]
        }
    Catch{
        # Uh oh
        Write-Verbose "Plink couldn't be found or had an error." -Verbose
        return $false
        }
    return $result
    }
Export-ModuleMember -Function Use-Plink