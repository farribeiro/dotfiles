$CS = Gwmi Win32_ComputerSystem -Comp "ti-fabio"

    $UserName = New-Object System.Windows.Forms.Label
	$UserName.Location = '10, 110'
	$UserName.Name = "UserName"
	$UserName.Size = '100, 23'
	$UserName.TabIndex = 12
	$UserName.Text = $cs.UserName
	$UserName.TextAlign = 'MiddleLeft'
    # $UserName.FontSize = 42

	$formMain = New-Object System.Windows.Forms.Form
	$formMain.Controls.Add($UserName)
    $formMain.    
    $formMain.ShowDialog()