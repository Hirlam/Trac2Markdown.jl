
# Post processing with gl

If you are working with the grib_api version of gl (gl_grib_api ) check [here](HarmonieSystemDocumentation/PostPP/gl_grib_api).

## Introduction

gl ( as in **g**rib**l**ist ) is a multi purpose tool for file manipulation and conversion. It uses GRIB and BUFR libraries and can be compiled with and without support for HARMONIE FA/LFI or NETCDF files. The gl package also includes software for extraction for verification, fldextr, and field comparison, [xtool](HarmonieSystemDocumentation/PostPP/xtool).

```bash

 USAGE: gl file [-n namelist_file] [-o output_file] -[lfgmicpasdetq]

 gl [-f] file, list the content of a file, -f for FA/lfi files  
 -c    : Convert a FA/lfi file to grib ( -f implicit )          
 -nc   : Convert a FA file to NetCDF output without extension zone
         (-f implicit )                                  
 -p    : Convert a FA file to grib output without extension zone
         (-c and -f implicit )                                  
 -musc : Convert a MUSC FA file ASCII ( -c implicit )           
 -a    : Convert a HIRLAM file to ALADIN input                  
         climate_aladin assumed available                       
 -d    : Together with -a it gives a (bogus) NH boundary file   
 -e    : Convert a ECMWF file to ALADIN input                   
         climate_aladin assumed available                       
 -s    : Work as silent as possible                             
 -g    : Prints ksec/cadre/lfi info                             
 -m    : Prints min,mean,max of the fields                      
 -i    : Prints the namelist options (useless)                  
 -tp   : Prints the GRIB parameter usage                        
 -t    : Prints the FA/lfi/GRIB table (useful)                  
 -q    : Cross check the FA/lfi/GRIB table (try)                
 -pl X : Give polster_projlat in degrees                         

 gl file -n namelist_file : interpolates file according to      
                            namelist_file                       
 gl -n namelist_file : creates an empty domain according to     
                       specifications in namelist_file          
 -igd  : Set lignore_duplicates=T                               
 -ufn  : Use full_name as output name                           

```

## GRIB/FA/LFI file listing

Listing of GRIB/ASIMOF/FA/LFI files.
```bash
 gl [-l] [-f] [-m] [-g] FILE
```
where FILE is in GRIB/ASIMOF/FA/LFI format

||-l || input format is LFI      ||
||-f || input format is FA       ||
||   || -l and -f are equivalent ||
||-g || print GRIB/FA/LFI header ||
||-m ||print min/mean/max values ||

## GRIB/FA/LFI file conversion

```bash
gl [-c|-nc|-p] [-ufn] FILE [ -o OUTPUT_FILE] [ -n NAMELIST_FILE]
```

where 
||-c ||converts the full field (including extension zone) from FA to GRIB ||
||-p ||converts the field excluding the extension zone ("p" as in physical domain) from FA to GRIB ||
||-nc ||converts the field excluding the extension zone ("p" as in physical domain) from FA to NETCDF ||
||-ufn || Use the FA names in the output NETCDF file instead of the CF convention names ||

The FA/LFI to GRIB mapping is done in a table defined by a [translation table](Harmonie/util/gl/inc/trans_tab.h?rev=release-43h2.beta.3)

To view the table as deinfed in [trans_tab.h](Harmonie/util/gl/inc/trans_tab.h?rev=release-43h2.beta.3) use

```bash
gl -t
``` 

To view the table sorted by GRIB parameters use
```bash
gl -tp
``` 

To check for duplicates in the table:
```bash
gl -q
```

The translation can be changed through a namelist like this one:
 ```bash
  &naminterp
    user_trans%full_name ='CLSTEMPERATURE',
    user_trans%tab       = 253,
    user_trans%par       = 123,
    user_trans%typ       = 105,
    user_trans%lev       = 002,
    user_trans%tri       = 000,
  /
 ```

The FA/LFI to NETCDF mapping is done in a table defined by a [translation table](Harmonie/util/gl/inc/nc_tab.h?rev=release-43h2.beta.3). In case of the -ufn flag the FA/LFI names are retained.

### GRIB/FA/LFI file conversion

Conversion can be refined to convert a selection of fields. Below is and example the will write out 
 * T (ppp=011), u (ppp=033) andv (ppp=034) on all (lll=-1) model levels (ttt=109)
 * T (ppp=011) at 2m (lll=2) above the ground (ttt=105) [T2m]
 * Total precipitation (ppp=061,ttt=105,lll=000)
 ```bash
  &naminterp
    readkey%ppp =011,033,034,011,061,228,
    readkey%lll =-01,-01,-01,  2,  0, 10,
    readkey%ttt =109,109,109,105,105,105,
    readkey%tri =  0,  0,  0,  0,  4,  2,
  /
 ```
where 
 * ppp means parameter
 * lll means level
 * ttt means leveltype
 * tri means time range indicator 

The first three ones are well known to most users. The time range indicator is used in HARMONIE to distinguish between instantaneous and accumulated fields. Read more about the options [here](HarmonieSystemDocumentation/Forecast/Outputlist/40h1#TimeunitsWMOcodetable4) Note that for level type 109 setting lll=-1 means all.

We can also pick variables using their FA/lfi name. Some variables do not have GRIB parameters, for these this is the only conversion option. Also, these can only be converted into NetCDF format, for instance with the command gl -nc -p <FA/LFI_file> -n <namelist_file> -igd -ufn:
 ```bash
  &naminterp
    readkey%name = 'SPECSURFGEOPOTEN','SNNNTEMPERATURE',
  /
 ```

Where `SNNNTEMPERATURE` means that we picks all levels. We can also do the equivalent using grib codes

 ```bash
  &naminterp
   readkey%ppp = 6,11,
   readkey%lll = 0,-1,
   readkey%ttt = 105,109
  /
 ```

Fields can be excluded from the conversion by name

 ```bash
  &naminterp
    exclkey%name = 'SNNNTEMPERATURE'
  /
 ```

## postprocessing
gl can be used to produce postprocessed parameters possibly not available directly from the model. 
 * Postprocessed parameters are defined in [util/gl/grb/postprocess.F90](Harmonie/util/gl/grb/postprocess.F90@?rev=release-43h2.beta.3). Some more popular parameters are listed:
   * Pseudo satellite pictures
   * Total precipitation and snow
   * Wind (gust) speed and direction
   * Cloud base, cloud top, cloud mask and significant cloud top

 For a comprehensive list please check the [output information](HarmonieSystemDocumentation/Forecast/Outputlist/40h1#Variablespostprocessedbygl) for each cycle.


 * To produce "postprocessed" MSLP and accumulated total precipitation and visibility use the following namelist, nam_FApp:
```bash
&naminterp
 pppkey(1:3)%ppp=001,061,020
 pppkey(1:3)%ttt=103,105,105,
 pppkey(1:3)%lll=  0, 0, 0,
 pppkey(1:3)%tri=  0, 4, 0,
 lwrite_pponly= .TRUE.,
/
```
```bash
gl -p ICMSHHARM+0003 -o output_pp.grib -n nam_FApp
```
 * Note:
   * Set lwrite_pponly as true to only write the postprocessed fields to file
   * Set lwrite_pponly as false write all fields will be written to the file, input fields as well as the postprocessed fields.

 Readkey and pppkey can also be combined so that we specify exactly what to read. Just make sure that you have enough for your postprocessing parameter.

```bash
&naminterp
 readkey%name='SURFACCPLUIE','SURFACCNEIGE','SURFACCGRAUPEL',
 pppkey(1:3)%ppp=061,
 pppkey(1:3)%ttt=105,
 pppkey(1:3)%lll=  0,
 pppkey(1:3)%tri=  4,
 printlev=$PRINTLEV
/
```

## vertical interpolation

gl can be used to carry out vertical interpolation of parameters:
 * To interpolation temperature to 1.40m (level 140 in cm) use the following namelist, nam_hl:
```bash
&naminterp
 pppkey(1:1)%ppp=11,
 pppkey(1:1)%ttt=125
 pppkey(1:1)%lll=140,
 pppkey(1:1)%tri=  0,
 vint_z_order=1,
 lwrite_pponly= .TRUE.,
/
```
```bash
gl -p ICMSHHARM+0003 -o output_hl.grib -n nam_hl
```
 * Note:
   * Vertical interpolation to z levels is controlled by VINT_Z_ORDER: 0 is nearest level, 1 is bilinear interpolation

 * To height interpolation (Levls 500, 850 and 925 in hPa, type=100) use the following namelist, nam_pl:
```bash
&naminterp
 pppkey(1:3)%ppp=011,011,011,
 pppkey(1:3)%ttt=100,100,100
 pppkey(1:3)%lll=500,850,925,
 pppkey(1:3)%tri=  0,  0,  0,
 lwrite_pponly= .TRUE.,
/
```
```bash
gl -p ICMSHHARM+0003 -o output_pl.grib -n nam_pl
```

## horizontal interpolation

 * Interpolation/resampling between different geometries such as regular lat lon, Lambert conformal, Polar steregraphic, rotated lat lon and rotated Mercator is possible with gl

 * The interpolation methods available are:
   * nearest grid-point (order=-2)
   * most representative grid-point (order=-1)
   * nearest grid-point (order=0)
   * bi-linear (order=1)
   * bi-quadratic (order=2, mask not respected)
   * bi-cubic (order=3, mask not respected)

 * Example of (an Irish) rotated lat lon domain, nam_FArotll:
 ```bash
&naminterp
 outgeo%nlon=50,
 outgeo%nlat=50,
 outgeo%nlev=-1,
 outgeo%projection=10,
 outgeo%west=-2.5,
 outgeo%south=-2.5,
 outgeo%dlon=0.1,
 outgeo%dlat=0.1,
 outgeo%polon=-6.7,
 outgeo%polat=-36.2,
 order= 1,
/
 ```
where DLON/DLAT are in degrees.The HIRLAM [Domain Tool](https://www.hirlam.org/nwptools/domain.html) may be of use for viewing rotated lat lon domains.
```bash
gl -p ICMSHHARM+0003 -n nam_FArotll  -o output.grib
```
 * Example of a lambert domain
 ```bash
&naminterp
  outgeo%nlon       =  50 ,
  outgeo%nlat       =  50,
  outgeo%nlev       =  -1,
  outgeo%projection = 3,
  outgeo%west       =  15.0
  outgeo%south      =  50.0
  outgeo%dlon       = 10000.
  outgeo%dlat       = 10000.
  outgeo%projlat    =  60.
  outgeo%projlat2   =  60.
  outgeo%projlon    =  15.
/
 ```
where DLON/DLAT are in meters.The HIRLAM [Domain Tool](https://www.hirlam.org/nwptools/domain.html) may be of use for viewing rotated lat lon domains.

   * Example polar stereographic projection
 ```bash
&naminterp
  outgeo%nlon       =  50 ,
  outgeo%nlat       =  50,
  outgeo%nlev       =  -1,
  outgeo%projection =   5,
  outgeo%west       =  15.0
  outgeo%south      =  50.0
  outgeo%dlon       = 10000.
  outgeo%dlat       = 10000.
  outgeo%projlat    =  60.
  outgeo%projlon    =  15.
/
 ```
where DLON/DLAT are in meters.Note: the GRIB1 standard assumes that the projection plane is at 60 degrees north whereas HARMONIE assumes it is at 90 degrees north.

 * Example rotated Mercator
 ```bash
&naminterp
  outgeo%nlon       =  50 ,
  outgeo%nlat       =  50,
  outgeo%nlev       =  -1,
  outgeo%projection =  11,
  outgeo%west       =  15.0
  outgeo%south      =  50.0
  outgeo%dlon       = 10000.
  outgeo%dlat       = 10000.
  outgeo%projlat    =  60.
  outgeo%projlon    =  15.
/
 ```
where DLON/DLAT are in metersNote: rotated Mercator is not supported in GRIB1.

 * Geographical points is a special case of projection 0 use namelist file, nam_FAgp:
 ```bash
&naminterp
  outgeo%nlon=3 ,
  outgeo%nlat=1,
  outgeo%nlev=-1,
  outgeo%projection= 0,
  outgeo%arakawa=  'a',
  order             =   0,
  readkey(1:3)%ppp = 11,33,34,
  readkey(1:3)%ttt = 105,105,105,
  readkey(1:3)%lll =   2,  10, 10,
  readkey(1:3)%tri=  0, 0, 0,
  linterp_field     = f,
  gplat          = 57.375,57.35,57.60
  gplon          = 13.55,13.55,14.63
/
 ```
The result will be written to a ASCII file with the name gpYYYYMMDDHHLLL.
```bash
gl -p ICMSHHARM+0003 -n nam_FAgp 
cat gp20140702_1200+003
```

## extract a sub-domain
gl can be used to "cut out" a sub-domain from an input file using the namelist namCUT:
```bash
&naminterp
istart = 150
jstart = 150
istop = 350
jstop = 350
/
```
Use this command:
```bash
gl input.grib -n namCut -o cutout.grib
```
Another way of specifying your sub domain is to define how many points to exclude in the end
```bash
&naminterp
istart = 150
jstart = 150
istop = -10
jstop = -10
/
```

## Output to several files

It is possible to let gl read data once and do processing loops with these data. Let us look at an example namelist

```bash
&naminterp
 OUTPUT_FORMAT='MEMORY'
/
&naminterp
 INPUT_FORMAT='MEMORY'
 OUTPUT_FORMAT='GRIB'
 OUTFILE='test1.grib'
/
&naminterp
 INPUT_FORMAT='MEMORY'
 OUTPUT_FORMAT='GRIB'
 OUTFILE='test2.grib'
 READKEY%NAME='SNNNTEMPERATURE'
/
&naminterp
 INPUT_FORMAT='MEMORY'
 OUTPUT_FORMAT='GRIB'
 READKEY%NAME='CLSTEMPERATURE'
 outgeo%nlon       =  50 ,
 outgeo%nlat       =  50,
 outgeo%nlev       =  -1,
 outgeo%projection =   5,
 outgeo%west       =  15.0
 outgeo%south      =  50.0
 outgeo%dlon       = 10000.
 outgeo%dlat       = 10000.
 outgeo%projlat    =  60.
 outgeo%projlon    =  15.
 OUTFILE='test3.grib'
/
```

In the first loop we read data and store it in memory. In the second look we read the data from memory and output to the file test1.grib. Then we make two more loops where we inte first one only output a subset and in the last one also do an interpolation to a new grid. The data in memory is however still untouched.

## Input from several files

It's also possible to read several files and write them into one. This is used to gather the various FA fields written from the IO-server. A typical namelist would look like

```bash
&naminterp
 maxfl=28,
 output_format='MEMORY',
 output_type = 'APPEND',
 input_format='FA',
 infile='forecast/io_serv.000001.d/ICMSHHARM+0003.gridall',
/
&naminterp
 output_format='MEMORY',
 output_type = 'APPEND',
 input_format='FA',
 infile='forecast/io_serv.000002.d/ICMSHHARM+0003.gridall',
/
...
&naminterp
 input_format = 'MEMORY',
 output_format= 'GRIB'
 output_type  = 'NEW',
 outfile      = 'test.grib'
/
```

Where maxfl tells how many files that will be read.


## musc file
* To convert a history FA file from [MUSC](MUSC) to an ascii file simply run
 ```bash
    gl -musc FAFILE
 ```



----


