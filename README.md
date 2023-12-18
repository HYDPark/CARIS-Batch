<!-- ABOUT THE PROJECT -->
## About The Project



The purpose of this project is to extract GeoTIFF files that were previously generated from BSB directly from HPD without BSB.

Project Scope:
* Automate GeoTIFF File Extraction Using Caris Batch
* Create files of the same quality as BSB extraction
* Improve issues with existing GeoTIFF files


## Current GeoTIFF ISSUES

Issues
* The Tiff chart currently distributed in the [NZ Chart Catalog](https://charts.linz.govt.nz/charts/paper-chart)is not a geographically referenced chart
* Chart images distributed via LDS do not have a proper color index
* Neither side has information about image resolution


## Getting Started

First, analyze the BSB file currently in use and check the current extraction setting

BSB File Analysis

<img src=BSB_con.PNG 
 width="600"
 height="400"
/>

### BSB Settings

* resolution : 254dpi
* Depth of the colormap / bits per pixel :  3 bits = 8 numbers
* Coordinate system : WGS84 
* Projection : TM

### Prerequisites

Carisbatch requires the following to run
* HPD PaperChartBuilder License
* Oracle Client and access permission
### Running CARIS® Batch

1. Oracle connection test
```bat
   TNSPING PHPD
```
2. Check the batch options
```bat
    carisbatch --run ExportChartToTIFF [options] <input> <output>
```

* -r : run
* -D : dpi / default 300
* -e : EXPORT_AREA / default SHEET
* -d : colour-depth / default 24 
* -C : boundary-colour "RGB(255,255,255,100)"  
* -g : geospatial
* -p : panel-number 1 

4. Completed batch code
```bat
carisbatch -r ExportChartToTIFF -D 300 -e EXPORT_AREA -d 8 -C "RGB(255,255,255,100)"  -g -p 1 hpd://<USERID>:<PW>@<DBNAME>/db?ChartVersionId=1234 C:\temp\chart\chart_1234.tif
```

### Extracting Chart Lists

```sql
Use case:
How to get the geometry of the $rncpanel features for a given chart/panel?

View: CHART_ATTRIBUTES_VIEW
get the chartver_id using the chart number
ex:
select chartver_id from CHART_ATTRIBUTES_VIEW
WHERE acronym = 'CHTNUM' and stringval = '4905';


chart number =4905
ID = 13
panelver_id = 14005
rep_id = 84152
foid = QQ 0000071224 00001


View: CHART_SHEET_PANEL_VW
Columns:
	chartver_id
	sheetver_id
	panelver_id
ex:
select panelver_id from CHART_SHEET_PANEL_VW
WHERE chartver_id = '13';



View:  PANEL_FEATURE_VW
Columns of interest:  
	panelver_id   (See above queries)
	object_acronym   ($rncpanel)
	rep_id   (need this to extract its geom from another table. See below)
ex:
select rep_id from panel_feature_vw
where object_acronym = '$rncpanel'
and panelver_id = '14005';



View: FEATURE_GEOMETRY_VW
Columns of interest:
	rep_id
	LLDG_geom
	branch_geom   (for those features created after 4, refer to the p_feature_api.getBranchgeometry function)
ex:
select LLDG_geom from feature_geometry_vw
where rep_id = '84152';


Function: P_FEATURE_API.getBranchGeometry	
Input: v_rep_id     (spatial representation id)
Output: SDO_GEOMETRY    (geometry for the line/area feature)


Putting it all together:

select LLDG_geom from feature_geometry_vw
where rep_id = (
	select rep_id from panel_feature_vw
	where object_acronym = '$rncpanel'
	and panelver_id = (
		select panelver_id from CHART_SHEET_PANEL_VW
		WHERE chartver_id = (
			select chartver_id from CHART_ATTRIBUTES_VIEW
			WHERE acronym = 'CHTNUM' and stringval = '4905')));

```

<!-- USAGE EXAMPLES -->
## Usage

Create a chart list with sql for automated execution and run it on Powershell.
* `geotiffExport.ps1`
* Saved GeoTIFF file location `N:\Projects\GeoTIFF\chart`

_For more details, please refer to the [Caris ticket CSR-44402](https://jira.teledynecaris.com/plugins/servlet/theme/portal/3/CSR-44402)_

<!-- ROADMAP -->
## Roadmap

- [x] GeoTIFF from HPD
- [x] GeoTIFF georeferencing
- [x] GeoTIFF colour index
- [x] Rnc Panel data generation
- [ ] Cut chart image with Rnc Panel boundary
- [ ] Automated cut out process

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- CONTACT -->
## Contact

Daehyun Park - - dpark@linz.govt.nz

Project Link: [Caris Batch](https://github.com/HYDPark/CARIS-Batch)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [HPD1 and Desktop Solutions 4.1](https://www.teledynecaris.com/docs/6.5/caris%20hpd/changes%20list/index.html#page/HPD%25204%2FHPD_40CHANGES_410.html%23)
* [Export Chart to TIFF](https://www.teledynecaris.com/docs/6.5/caris%20hpd//index.html#page/CARIS%2520HPD%2520Help%2FCARISBatch%2520HPD%2520Processes.081.30.html%23)