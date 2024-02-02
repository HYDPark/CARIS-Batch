

@ECHO OFF

SET SaveAs=C:\Temp\chart\single\ 
SET geotiff_dir=C:\Temp\chart\single\
SET gdbdir=C:\Users\DPArk\Documents\ArcGIS\Projects\MyProject30\MyProject30.gdb\

"C:/Program Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3/python.exe" c:/Projects/Git/Geotiff/rncpanelSingle.py %SaveAs% %geotiff_dir% %gdbdir%
EXIT /B