```@meta
EditURL="https://hirlam.org/trac//wiki//PostPP/gl?action=edit"
```

# Post processing with gl

## Introduction

gl ( as in **g**rib**l**ist ) is a multi purpose tool for file manipulation and conversion. It uses ECMWF's   [ecCodes](https://confluence.ecmwf.int//display/ECC/What+is+ecCodes) library, and can be compiled with and without support for HARMONIE FA/LFI or NETCDF files. The gl package also includes software for extraction for verification, fldextr, and field comparison, [xtool](./PostPP/xtool.md).

```bash
 USAGE: gl file [-n namelist_file] [-o output_file] -[lfgmicpsdtq] [-lbc CONF]

 gl [-f] file, list the content of a file, -f for FA/lfi files  
 -c    : Convert a FA/lfi file to grib ( -f implicit )          
 -p    : Convert a FA file to grib output without extension zone
         (-c and -f implicit )                                  
 -musc : Convert a MUSC FA file ASCII ( -c implicit )           
 -lbc ARG : Convert a CONF file to HARMONIE input               
            where CONF is ifs or hir as in ECMWF/HIRLAM data    
         climate_aladin assumed available                       
 -d    : Together with -lbc it gives a (bogus) NH boundary file   
         climate_aladin assumed available                       
 -s    : Work as silent as possible                             
 -g    : Prints ksec/cadre/lfi info                             
 -m    : Prints min,mean,max of the fields                      
 -i    : Prints the namelist options (useless)                  
 -tp   : Prints the GRIB parameter usage                        
 -t    : Prints the FA/lfi/GRIB table (useful)                  
 -wa   : Prints the atmosphere FA/NETCDF/GRIB table in wiki fmt 
 -ws   : Prints the surfex FA/NETCDF/GRIB table in wiki fmt     
 -q    : Cross check the FA/lfi/GRIB table (try)                
 -pl X : Give polster_projlat in degrees                        

 gl file -n namelist_file : interpolates file according to      
                            namelist_file                       
 gl -n namelist_file : creates an empty domain according to     
                       specifications in namelist_file          
 -igd  : Set lignore_duplicates=T                               
 -igs  : Set lignore_shortname=T. Use indicatorOfParameter      
             instead of shortName for selection                 

```

## ecCodes definition tables

Since ecCodes has replaced grib_api as the ECMWF primary software package to handle GRIB, we will hereafter only refer to ecCodes but same similar settings applies for grib_api as well. With the change to ecCodes we heavily rely on the shortName key for identification. To get the correct connection between the shortnames and the GRIB1/GRIB2 identifiers we have defined specific tables for harmonie. These tables can be found in [gl/definitions](https://hirlam.org/trac/browser/Harmonie/util/gl/definitions). To use these tables you have to define the `ECCODES_DEFINITION_PATH` environment variable as 

```bash
export ECCODES_DEFINITION_PATH=SOME_PATH/gl/definitions:PATH_TO_YOUR_ECCODES_INSTALLATION
```

If this is not set correctly the interpretation of the fields may be wrong.

## GRIB/FA/LFI file listing

Listing of GRIB/ASIMOF/FA/LFI files.
```bash
 gl [-l] [-f] [-m] [-g] FILE
```
where FILE is in GRIB/ASIMOF/FA/LFI format


|-l | input format is LFI      |
| --- | --- |
|-f | input format is FA       |
|   | -l and -f are equivalent |
|-g | print GRIB/FA/LFI header |
|-m |print min/mean/max values |

## GRIB/FA/LFI file conversion

### Output to GRIB1

```bash
gl [-c] [-p] FILE [ -o OUTPUT_FILE] [ -n NAMELIST_FILE]
```

where 

|-c |converts the full field (including extension zone) from FA to GRIB1 |
| --- | --- |
|-p |converts field excluding the extension zone ("p" as in physical domain) from FA to GRIB1 |

The FA/LFI to GRIB mapping is done in a table defined by a [translation table](https://hirlam.org/trac/browser/Harmonie/util/gl/inc/trans_tab.h)

To view the table:
```bash
gl -t
gl -tp
```
To check for duplicates in the table:
```bash
gl -q
```

The translation from FA/LFI to GRIB1 can be changed through a namelist like this one:
```bash
  &naminterp
    user_trans%full_name ='CLSTEMPERATURE',
    user_trans%t2v       = 253,
    user_trans%pid       = 123,
    user_trans%levtype   = 'heigthAboveGround',
    user_trans%level     = 002,
    user_trans%tri       = 000,
  /
```
or for the case where the level number is included in the FA name
```bash
  &naminterp
    user_trans%full_name='SNNNEZDIAG01',
    user_trans%cpar='S'
    user_trans%ctyp='EZDIAG01',
    ...
  /
```


Conversion can be refined to convert a selection of fields. Below is and example that will write out 
 * T (shortname='t',pid=011), u (shortname='u',pid=033) andv (shortname='v',pid=034) on all (level=-1) model levels (levtype='hybrid')
 * T (shortname='t',pid=011) at 2m (lll=2) above the ground (levtype='heightAboveGround') [T2m]
 * Total precipitation (shortname='tp',pid=061,levtype='heightAboveGround',level=000)
```bash
  &naminterp
   readkey%shortname=   't',     'u',     'v',                't',               'tp',               'fg',
   readkey%levtype='hybrid','hybrid','hybrid','heightAboveGround','heightAboveGround','heightAboveGround',
   readkey%level=        -1,      -1,      -1,                  2,                  0,                 10,
   readkey%tri =          0,       0,       0,                  0,                  4,                  2,
  /
```
where 
 * shortname is the ecCodes shortname of the parameter 
 * levtype is the ecCodes level type
 * level is the GRIB level
 * tri means timeRangeIndicator and is set to distinguish between instantaneous, accumulated and min/max values.

The first three ones are well known to most users. The time range indicator is used in HARMONIE to distinguish between instantaneous and accumulated fields. Read more about the options [here](./Forecast/Outputlist/40h1#TimeunitsWMOcodetable4.md) Note that for levtype hybrid setting level=-1 means all. 

We can also pick variables using their FA/lfi name:
```bash
  &naminterp
    readkey%faname = 'SPECSURFGEOP','SNNNTEMPERATURE',
  /
```

Where `SNNNTEMPERATURE` means that we picks all levels.

Fields can be excluded from the conversion by name

```bash
  &naminterp
    exclkey%faname = 'SNNNTEMPERATURE'
  /
```

### Output to GRIB2
 To get GRIB2 files the format has to be set in the namelist as 

```bash
  &naminterp
    output_format = 'GRIB2'
  /
```

 The conversion from FA to GRIB2 is done in gl via the ecCodes tables. All translations are defined in [source:Harmonie/util/gl/scr/harmonie_grib1_2_grib2.pm] where we find all settings required to specify a parameter in GRIB1 and GRIB2.

```bash

  tmax => {
   editionNumber=> '2',
   comment=> 'Maximum temperature',
   discipline=> '0',
   indicatorOfParameter=> '15',
   paramId=> '253015',
   parameterCategory=> '0',
   parameterNumber=> '0',
   shortName=> 'tmax',
   table2Version=> '253',
   typeOfStatisticalProcessing=> '2',
   units=> 'K',
  },

```

 To create ecCodes tables from this file run
```bash
   cd gl/scr
   ./gen_tables.pl harmonie_grib1_2_grib2
```

 and copy the grib1/grib2 directories to gl/definitions.

 Note that there are no GRIB2 transations yet defined for the SURFEX fields!

## postprocessing
gl can be used to produce postprocessed parameters possibly not available directly from the model. 
 * Postprocessed parameters are defined in [util/gl/grb/postprocess.f90](https://hirlam.org/trac/browser/Harmonie/util/gl/grb/postprocess.f90) and [util/gl/grb/postp_pressure_level.f90](https://hirlam.org/trac/browser/Harmonie/util/gl/grb/postp_pressure_level.f90). Some more popular parameters are listed:
   * Pseudo satellite pictures
   * Total precipitation and snow
   * Wind (gust) speed and direction
   * Cloud base, cloud top, cloud mask and significant cloud top

 For a comprehensive list please check the [output information](./Forecast/Outputlist/40h1#Variablespostprocessedbygl.md) for each cycle. **NOTE that all parameters may not be implemented in gl**

 * To produce "postprocessed" MSLP and accumulated total precipitation and visibility use the following namelist, nam_FApp:
```bash
&naminterp
 pppkey(1:3)%shortname='pres','tp','vis',
 pppkey(1:3)%levtype='heightAboveSea','heightAboveGround','heightAboveGround'
 pppkey(1:3)%level=  0, 0, 0,
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

## Vertical interpolation

gl can be used to carry out vertical interpolation of parameters. Four types are available
 * HeightAboveSea, give height above sea in meters
 * HeightAboveGround, give height above ground in meters
 * HeightAboveGroundHighPrecision, give height above ground in centimeters
 * isobaricInHpa, give height above sea in hPa
 * To interpolation temperature to 1.40m (level 140 in cm) use the following namelist, nam_hl:
```bash
&naminterp
 pppkey(1:1)%shortname='t',
 pppkey(1:1)%levtype='heightAboveGroundHighPrecision',
 pppkey(1:1)%level=  140,
 pppkey(1:1)%tri=  0,
 vint_z_order=1,
 lwrite_pponly= .TRUE.,
/
```
```bash
gl -p ICMSHHARM+0003 -o output_hl.grib -n nam_hl
```
 * Note:
   * Vertical interpolation to z levels is controlled by VINT_Z_ORDER: 0 is nearest level, 1 is linear interpolation

 * To height interpolation (Levls 500, 850 and 925 in hPa, type=100) use the following namelist, nam_pl:
```bash
&naminterp
 pppkey(1:3)%shortname='t','t','t',
 pppkey(1:3)%levtype='isobaricInhPa','isobaricInhPa','isobaricInhPa',
 pppkey(1:3)%level=  500, 850, 925,
 pppkey(1:3)%tri=  0, 0, 0,
 vint_z_order=1,
 lwrite_pponly= .TRUE.,
/
```
```bash
gl -p ICMSHHARM+0003 -o output_pl.grib -n nam_pl
```

## Horizontal interpolation

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
 outgeo%gridtype='rotated_ll',
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
  outgeo%gridtype   =  'lambert',
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
  outgeo%gridtype   =  'polar_stereographic',
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
  outgeo%gridtype='regular_ll',
  outgeo%arakawa=  'a',
  order             =   0,
  readkey(1:3)%shortname='t','u','v',
  readkey(1:3)%levtype='heightAboveGround','heightAboveGround','heightAboveGround',
  readkey(1:3)%level=   2,  10, 10,
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

## Extract a sub-domain
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
 READKEY%FANAME='SNNNTEMPERATURE'
/
&naminterp
 INPUT_FORMAT='MEMORY'
 OUTPUT_FORMAT='GRIB'
 READKEY%FANAME='CLSTEMPERATURE'
 outgeo%nlon       =  50 ,
 outgeo%nlat       =  50,
 outgeo%nlev       =  -1,
 outgeo%gridtype   =  'polar_stereographic',
 outgeo%west       =  15.0
 outgeo%south      =  50.0
 outgeo%dlon       = 10000.
 outgeo%dlat       = 10000.
 outgeo%projlat    =  60.
 outgeo%projlon    =  15.
 OUTFILE='test3.grib'
/
```

In the first loop we read data and store it in memory. In the second look we read the data from memory and output to the file test1.grib. Then we make two more loops where we in the first one only output a subset and in the last one also do an interpolation to a new grid. The data in memory is however still untouched.

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


## domain_prop

domain_prop is used do extract various properties from a file. 



Climate:  $MPPGL $BINDIR/domain_prop -DOMAIN_CHECK $LCLIMDIR/m$M1 -f || \

### Check an existing domain with a namelist specification

```bash
domain_prop -DOMAIN_CHECK -f CLIMATE_FILE
```

The geometry is read from fort.10 and the program aborts if the new and old geometries differs. See the [Climate](https://hirlam.org/trac/browser/Harmonie/scr/Climate) for an example.

### Check if Q is in gridpoint or spectral representation

```bash
domain_prop -f -QCHECK FAFILE
```
returns 1 if Q is spectral and 0 if Q is in gridpoint space.


### Check if a specific field is present

```bash
domain_prop -f -CHECK_FIELD S001CLOUD_FRACTI
```

returns 1 if S001CLOUD_FRACTI is found, 0 otherwise

### Check the number of levels in a file

```bash
domain_prop -f -NLEV FAFILE  
```


### Check the geographical extension of the domain

```bash
domain_prop -f -MAX_EXT FAFILE  
```

This is used in several places to determine the domain to be extracted from MARS or limit the observations sample. Another way is to provide the projection parameters of your domain as input

```bash
domain_prop -MAX_EXTR \
-NLON $NLON -NLAT $NLAT \
-LATC $LATC -LONC $LONC \
-LAT0 $LAT0 -LON0 $LON0 \
-GSIZE $GSIZE
```

To get the geographical position of the lower left corner use

```bash
domain_prop -f -LOW_LEFT FAFILE  
```

To print out the important projection parameters in a file use:

```bash
domain_prop -f -4JB FAFILE
```

### Get time information from a file

```bash
domain_prop -f -DATE FAFILE
```


## fldextr and obsextr

 Read about the verification extraction programs [here](./PostPP/Extract4verification.md)



----


