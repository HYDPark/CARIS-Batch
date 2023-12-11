$File = "C:\Projects\Git\Geotiff\Chart_val.xls" 
$Save = "C:\temp\chart\"

$Excel = New-Object -ComObject Excel.Application  
$WorkBook = $Excel.Workbooks.Open($File)  
$WorkSheet = $WorkBook.Worksheets.Item(1)  
$UsedRange = $WorkSheet.UsedRange  
$Rows = $UsedRange.Rows.Count  
 
$Objs = @()  
for ($Row = 2; $Row -le $Rows; $Row++) {  
    $Objs += [PSCustomObject]@{  
        ChartVersionId = $UsedRange.Cells($Row, 1).Text
        Chartname      = $UsedRange.Cells($Row, 2).Text  
        panelId        = $UsedRange.Cells($Row, 8).Text      
    }   
                        
}  
  
$WorkBook.Close($false)  
$Excel.Quit()  
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null  
Stop-Process -Name "EXCEL"  

$chartNum = $Objs.Rows.Count 
for ($chartNum = 0; $chartNum -le $Rows - 2; $chartNum++) { 

    $FilePath = ($Save + $Objs.ChartVersionId[$chartNum] + "_" + $Objs.Chartname[$chartNum] + "_" + $Objs.panelId[$chartNum] + ".tif")

    If (Test-Path -path $FilePath -PathType Leaf) {
        Write-Host "The file exists" -f Green
        Write-Host $FilePath
    }
    Else {
        carisbatch -r ExportChartToTIFF -D 300 -e EXPORT_AREA -d 8 -C "RGB(255,255,255,100)"  -g -p $Objs.panelId[$chartNum] ("hpd://<USERID>:<PW>@<DBNAME>/db?ChartVersionId=" + $Objs.ChartVersionId[$chartNum]) $FilePath
    }
    
}
