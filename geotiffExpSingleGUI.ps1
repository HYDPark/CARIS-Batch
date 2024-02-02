#GUI FORM
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Chart Search Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the Chart Name in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $chartName = $textBox.Text
    $chartName
}

#  $x ='NZ534'
Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

$a = Get-Folder

### Find chart version number with Chart name ###


$Assembly = [System.Reflection.Assembly]::LoadWithPartialName("System.Data.OracleClient")

if ( $Assembly ) {
    Write-Host "System.Data.OracleClient Loaded!"
}
else {
    Write-Host "System.Data.OracleClient could not be loaded! Exiting..."
    Exit 1
}
### connection string ###
$OracleConnectionString = "SERVER=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=drakodb01.ad.linz.govt.nz)(PORT=1522))(CONNECT_DATA=(SERVICE_NAME=DEV41)));uid=<USERID>;pwd=<PASSWORD>;"

### open up oracle connection to database ###
$OracleConnection = New-Object System.Data.OracleClient.OracleConnection($OracleConnectionString);
$OracleConnection.Open()

try {

    ### sql query command ###
    $OracleSQLQuery = "select chartver_chartver_id, charval from chart_version_attribute where attributeclass_id=86 and CHARVAL = '${chartName}' "

    ### create object ###
    $SelectCommand1 = New-Object System.Data.OracleClient.OracleCommand;
    $SelectCommand1.Connection = $OracleConnection
    $SelectCommand1.CommandText = $OracleSQLQuery
    $SelectCommand1.CommandType = [System.Data.CommandType]::Text

    ### create datatable and load results into datatable ###
    $SelectDataTable = New-Object System.Data.DataTable
    $SelectDataTable.Load($SelectCommand1.ExecuteReader())
    $SelectDataTable[0].Rows[0].CHARTVER_CHARTVER_ID

}
catch {

    Write-Host "Error while retrieving data!"

}