@ECHO OFF

SET chartName=NZ534
SET SaveAs=C:\Temp\chart\single\
SET DBName=DEV41
SET DBhost=drakodb01.ad.linz.govt.nz
SET DBPort=1522
SET USERID=<USERID>
SET PASSWORD=<PASSWORD>

SET PSScript=C:\Projects\Git\Geotiff\geotiffExpSingle.ps1

REM SET PowerShellDir=C:\Windows\System32\WindowsPowerShell\v1.0
REM CD /D "%PowerShellDir%"
Powershell -ExecutionPolicy Bypass -Command "& '%PSScript%' '%chartName%' '%SaveAs%' '%DBName%' '%DBhost%' '%DBPort%' '%USERID%' '%PASSWORD%'"
EXIT /B