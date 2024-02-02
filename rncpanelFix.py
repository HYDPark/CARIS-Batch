import os
import logging
import traceback
import time
import arcpy
from arcpy import env
from arcpy.sa import *

arcpy.env.workspace = "C:\\Projects\\RNCPANEL\\comp\\cline"
arcpy.env.overwriteOutput = True


geotiff_dir=r"C:\Projects\RNCPANEL\comp\cline"
file_names = os.listdir(geotiff_dir)

inChart = 'NZ 5217'

for file_name in file_names:
    if file_name.endswith(".tif"):
        chart_ver = (file_name.split('_')[0])
        chart_name = (file_name.split('_')[1])
        sheet_no = (file_name.split('_')[2].split('.')[0])
        nChart_name = 'NZ_5217' +'_' +sheet_no +'_'+chart_ver

        print(file_name)


        infc = r"C:\Users\DPArk\Documents\ArcGIS\Projects\MyProject30\MyProject30.gdb\rnc_cline"
        
        cursor = arcpy.da.SearchCursor(infc, ["CHARTVER_I","PANELNUMBE", "STRINGVAL","SHAPE@"])
        for row in cursor:
            print(row)
            if row[2] == inChart and str(int(row[1])) == sheet_no and str(int(row[0])) == chart_ver:

                # print('list', row[1],int(row[0]))
                
                shpe = row[3]

                tifdir = 'C:\\\\Temp\\\chart\\\\'+ file_name
                
                print(tifdir)
                charts = arcpy.Raster(tifdir)


                gdbdir = 'C:\\\\Users\\\DPArk\\\Documents\\\ArcGIS\\\Projects\\\MyProject30\\\MyProject30.gdb\\\\' + nChart_name

                arcpy.management.FeatureToPolygon(shpe, gdbdir)

                tifcutdir = nChart_name + '_c'
                tif_filename = tifcutdir + '.tif'

                #print(tif_filename)

                in_raster = charts
                out_raster = tif_filename
                clipping_geometry = gdbdir

                try:
                    arcpy.Clip_management(in_raster, "#", out_raster, clipping_geometry, "0", "ClippingGeometry", "MAINTAIN_EXTENT")
                except Exception as e:
                    logging.error('Error at %s', 'division', exc_info=e)