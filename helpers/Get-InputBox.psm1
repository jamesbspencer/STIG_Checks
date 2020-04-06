<#
    .Synopsys
    Function to create input boxes

    .Parameter PROMPT
    The input box message


    .Example
    Get-InputBox -PROMPT "What would you like to input"
#>

function Get-InputBox {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $PROMPT
        )
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Input Request'
    $form.Size = New-Object System.Drawing.Size(370,150)
    $form.StartPosition = 'CenterScreen'
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,75)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(175,75)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)
    $browseButton = New-Object System.Windows.Forms.Button
    $browseButton.Location = New-Object System.Drawing.Point(275,40)
    $browseButton.Size = New-Object System.Drawing.Size(70,20)
    $browseButton.Text = 'Browse'
    $browseButton.Name = 'Browse'
    $form.Controls.Add($browseButton)
    $browseButton.Add_Click(
        {
            $fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                InitialDirectory = [System.Environment]::GetFolderPath('Desktop')
                Filter = 'Text Files (*.txt)|*.txt'
                }
            $output = $fileBrowser.ShowDialog()
            if($output -eq "OK"){
                $path = $fileBrowser.FileName
                $textBox.Text = $path
                }
            else{$path = $null}
        }
        )
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = $PROMPT
    $form.Controls.Add($label)
    $form.Topmost = $true
    $form.Add_Shown({$textBox.Select()})
    #$result = $form.ShowDialog()
    Do{
       if($result -ne $null){[void][System.Windows.MessageBox]::Show('You must enter a value or choose CANCEL.','Data','OK','Exclamation')}
       $result = $form.ShowDialog()
       } While ($result -eq [System.Windows.Forms.DialogResult]::OK -and [string]::IsNullOrWhiteSpace($textBox.Text))
    if($result -eq [System.Windows.Forms.DialogResult]::OK){
        return $textBox.Text
        }
    else{return "CANCEL"}
    }
Export-ModuleMember -Function Get-InputBox