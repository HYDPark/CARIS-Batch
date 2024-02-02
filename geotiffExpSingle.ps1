

### get valus from bat
$chartName = $args[0]
$Save = $args[1]
$DBName = $args[2]
$DBhost = $args[3]
$DBPort = $args[4]
$USERID = $args[5]
$PW = $args[6]


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
$OracleConnectionString = "SERVER=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DBhost)(PORT=$DBPort))(CONNECT_DATA=(SERVICE_NAME=$DBName)));uid=$USERID;pwd=$PW;"

### open up oracle connection to database ###
$OracleConnection = New-Object System.Data.OracleClient.OracleConnection($OracleConnectionString);
$OracleConnection.Open()

try {

    ### sql query command ###
    $OracleSQLQuery = "select c.CHARTVER_ID, c.STRINGVAL, e.intval
                        from CHART_ATTRIBUTES_VIEW c, CHART_SHEET_PANEL_VW b, panel_version_attribute e
                        where c.acronym = 'CHTNUM'
                        and b.chartver_id = c.chartver_id
                        and e.panelvr_panelver_id=b.panelver_id
                        and e.attributeclass_id=171
                        and c.STRINGVAL = '${chartName}'"

    ### create object ###
    $SelectCommand1 = New-Object System.Data.OracleClient.OracleCommand;
    $SelectCommand1.Connection = $OracleConnection
    $SelectCommand1.CommandText = $OracleSQLQuery
    $SelectCommand1.CommandType = [System.Data.CommandType]::Text

    ### create datatable and load results into datatable ###
    $SelectDataTable = New-Object System.Data.DataTable
    $SelectDataTable.Load($SelectCommand1.ExecuteReader())
    # $SelectDataTable[0].Rows[0].CHARTVER_CHARTVER_ID
    
    $Rows = $SelectDataTable[0].Rows[0].CHARTVER_ID.Count
    for ($Row = 0; $Row -le $Rows; $Row++){
        $ChartverNum = $SelectDataTable[0].Rows[$Row].CHARTVER_ID
        $ChartN = $SelectDataTable[0].Rows[$Row].STRINGVAL
        $PanelN = $SelectDataTable[0].Rows[$Row].INTVAL
        Write-Host($Row, $ChartverNum, $ChartN, $PanelN)

        $FilePath = ($Save + $ChartverNum + "_" + $ChartN + "_" + $PanelN +".tif")

        If (Test-Path -path $FilePath -PathType Leaf) {
                    Write-Host "The file exists" -f Green
                    Write-Host $FilePath
        }
        Else {
            carisbatch -r ExportChartToTIFF -D 300 -e EXPORT_AREA -d 8 -C "RGB(255,255,255,100)"  -g -p $PanelN ("hpd://" + $USERID + ':' + $PW + '@' + $DBName + "/db?ChartVersionId=" + $ChartverNum) $FilePath
        }

    }

}
catch {

    Write-Host "Error while retrieving data!"

}