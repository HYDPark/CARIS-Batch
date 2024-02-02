import os
import logging
import traceback
import time
import arcpy
from arcpy import env
from arcpy.sa import *


import sys
saveAs = sys.argv[1]
geotiff_dir = sys.argv[2]
gdbdir = sys.argv[3]

# for arg in sys.argv:     
#     print('Arg:', arg) 

arcpy.env.workspace = saveAs
arcpy.env.overwriteOutput = True



file_names = os.listdir(geotiff_dir)

for file_name in file_names:
    if file_name.endswith(".tif"):
        chart_ver = (file_name.split('_')[0])
        chart_name = (file_name.split('_')[1])
        sheet_no = (file_name.split('_')[2].split('.')[0])
        nChart_name = chart_name +'_' +sheet_no +'_'+chart_ver

        print('Processing... ',chart_ver,chart_name,sheet_no)
           
        gdb_panel_dir = gdbdir +'\\rnc_panel'
        
        cursor = arcpy.da.SearchCursor(gdb_panel_dir, ["CHARTVER_I","PANELNUMBE", "STRINGVAL","SHAPE@"])
        
        for row in cursor:
            if row[2] == chart_name and str(int(row[1])) == sheet_no and str(int(row[0])) == chart_ver:
                #print('list', row[1],int(row[0]))
                shpe = row[3]

                tifdir = saveAs + file_name
                
                #print(tifdir)
                charts = arcpy.Raster(tifdir)

                gdbchartdir = gdbdir + nChart_name

                arcpy.management.FeatureToPolygon(shpe, gdbchartdir)

                tifcutdir = nChart_name + '_c'
                tif_filename = tifcutdir + '.tif'


                in_raster = charts
                out_raster = tif_filename
                clipping_geometry = gdbchartdir

                try:
                    arcpy.Clip_management(in_raster, "#", out_raster, clipping_geometry, "0", "ClippingGeometry", "MAINTAIN_EXTENT")
                    print('#Chart clipped with Rnc pannel as '+out_raster)
                except Exception as e:
                    logging.error('Error at %s', 'division', exc_info=e)

                break
        else:
            print('#No Panel data in GDB file#')