$File = "C:\Projects\Geotiff\LLDG.xls"  
$Excel = New-Object -ComObject Excel.Application  
$WorkBook = $Excel.Workbooks.Open($File)  
$WorkSheet = $WorkBook.Worksheets.Item(1)  
$UsedRange = $WorkSheet.UsedRange  
$Rows = $UsedRange.Rows.Count  
 
$Objs = @()  
for($Row=2; $Row -le $Rows; $Row++){  
    $Objs += [PSCustomObject]@{  
        ChartVersionId = $UsedRange.Cells($Row,1).Text    
    }   
                        
}  
  
$WorkBook.Close($false)  
$Excel.Quit()  
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null  
Stop-Process -Name "EXCEL"  

Write-Output $Objs.ChartVersionId    