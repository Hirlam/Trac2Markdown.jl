```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/PostppVerification?action=edit"
```

# Post processing and Verification

## GL 

 === GRIB/FA/LFI manipulation ===

 gl uses EMOSLIB ( or AUXLIBS), can be compiled with and without FA/LFI support, requires some IFS libraries. Can be used to list GRIB/ASIMOF/FA/LFI files.

 gl GRIB/ASIMOF-FILE
 gl -[l/f] FA/LFI-FILE
 gl -g gives you the GRIB/FA/LFI header
 gl -m prints min/mean/max values

FA/lfi files are converted to grib by gl

  gl -c FA/LFI-FILE, converts the full field (including extension zone)
  gl -p FAFILE, excludes the extension zone ( p as in physical domain )

  The FA/LFI 2 grib mapping is done in a table defined by a [translation table](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/inc/trans_tab.h)

  **AD HOC coding of the translation**

  gl -t to view the table
  gl -q to cross check duplicates

  Conversion can be tuned, to a subset of fields

```bash
  &naminterp
    readkey%ppp   =011,033,034,051,058,062,071,076,079,200,201,212,213,
    readkey%lll   =-01,-01,-01,-01,-01,-01,-01,-01,-01,-01,-01,-01,-01,
    readkey%ttt   =109,109,109,109,109,109,109,109,109,109,109,109,109,
;
 }}}

  or with the FA name

```bash
  &naminterp
    readkey%name = 'SPECSURFGEOP'
;
 }}}

 === gl postprocessing ===

  - To pressure levels,MSLP

```bash
  &naminterp
    pppkey%ppp   =001,
    pppkey%lll   =000,
    pppkey%ttt   =103,
    lwrite_pponly=T,
;
 }}}

  - To height interpolation (LEVEL in cm, type=125)
```bash
  &NAMINTERP
    PPPKEY%ppp=011
    PPPKEY%lll=20000
    PPPKEY%ttt=125
    LWRITE_PPONLY=T
    VINT_Z_ORDER=1
    OUTPUT_FORMAT='ASCII',
;
 }}}
  - Total precipitation
  - Pseudo satellite pictures
    [source:trunk/harmonie/util/gl/grb/any2any.F90@#L463 any2any.F90]
 
  - Interpolation/resampling between different geometries (0,3,5,10)
```bash
  &naminterp
 OUTGEO%NLON    =         50 ,
 OUTGEO%NLAT    =         50,
 OUTGEO%NLEV    =          -1,
 OUTGEO%PROJECTION      =   10,
 OUTGEO%WEST    =   -10.0
 OUTGEO%SOUTH   =   -10.0
 OUTGEO%DLON    =  0.1
 OUTGEO%DLAT    =  0.1
 OUTGEO%POLON  =  -30.
 OUTGEO%POLAT  =  -30.
 LRESAMPLE =F,
 ORDER=1,
 DEMAND_INSIDE=F,
;
 }}}

  - Geographical points is a special case of projection 0
```bash
 &NAMINTERP
 OUTGEO%NLON       =   3 ,
 OUTGEO%NLAT       =   1,
 OUTGEO%NLEV       =  -1,
 OUTGEO%PROJECTION =   0,
 OUTGEO%ARAKAWA    =  'A',
 ORDER             =   0
 READKEY(1:18)%ppp  = 011,011,011,011,011,011,002,122,121,005,061,062,079,201,003,004,005,001,
 READKEY(1:18)%lll  = 002,760,770,775,780,785,775,775,775,775,000,755,755,755,750,750,750,750,
 READKEY(1:18)%ttt  = 105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,
 READKEY(1:18)%nnn  = 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,
 LINTERP_FIELD     = F,
 GPLAT          = 57.375,57.35,57.60
 GPLON          = 13.55,13.55,14.63
;
 }}}

 - scum conversion to GRIB/ASCII


 === fldextr and obsextr ===

  Fldextr extracts data from several sources (HIRLAM/IFS/AAA) and

   - recalculates rh,td to be over water (for HIRLAM)
   - Interpolates to geographical points according to a synop.list and temp.list
   - Does MSLP,RH2M,TD2M calculations if the are not available
   - Optional fraction of land check.
   - Interpolates to pressure levels for TEMP data.

Obsextr extracts BUFR data and creates an ascii file. similar to the vfld file.

   - Reads SYNOP and TEMP
   - LUSE_LIST controls the usage of a station list


== xtool ==

'''Xtool''' is part of '''gl'''-package provides utility to calculate differences between GRIB/FA files and give output to a new GRIB file. See xtool part of [https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README#L221 gl-README]. Below is a simple example of how to use '''xtool'''

 What is the difference between +24h and +48h MSLP forecasts during August 2008?

 1. Namelist for '''xtool''', which lists the parameters (here mean sea level pressure) to be examined:

```bash
&NAMINTERP
  PPPKEY%ppp = 001,
  PPPKEY%lll = 000,
  PPPKEY%ttt = 103,
;
}}} 

 2. Run xtool.

```bash
xtool -sdtg1 2008080100 -edtg1 2008083000 -ll1 48 \
      -sdtg2 2008073100 -edtg2 2008082900 -ll2 24 \
      -p1 /your_model_data/YYYY/MM/HH/fcYYYYMMDD_HH+LLL \
      -p2 /your_model_data/YYYY/MM/HH/fcYYYYMMDD_HH+LLL \
      -fcint 6 -op DIFF -n your_namelist \
      -o output.grb
```

  * **-sdtg1**, **-edtg1**, **-ll1**: The cycles to look for the +48h forecast.
  * **-sdtg2**, **-edtg2**, **-ll2**: The cycles to look for the +24h forecast.
  * **-p1**, **-p2**: Naming rules for the files in cycle 1 and 2, respectively.
  * **-fcint**: Interval between forecast cycles.
  * **-op**: Operation to be applied. Possible choices *DIFF*, *SUM*, *AVE*, *STDV* or *SAL*
  * **-n**: Namelist file.
  * **-o**: Name of the output grib file.

 3. Output file (**output.grb**) now contains one 2D-field with accumulated 48-24h difference of mean sea level pressure.  

### SAL

**S**tructure **A**mplitude **L**ocation (**SAL**) is object based quality measure for the verification of QPFs ([Wernli et al., 2008](http://ams.allenpress.com/perlserv/?request=get-abstract&doi=10.1175%2F2008MWR2415.1)). **SAL** contains three independent components that focus on Structure, Amplitude and Location of the precipitation field in a specified domain. 

 * **S**: Measure of structure of the precipitation area (-2 - +2). Large **S**, if model predicts too large precipitation areas.
 * **A**: Measure of strength of the precipitation (-2 - +2). Large **A**, if model predicts too intense precipitation.
 * **L**: Measure of location of the precipitation object (0 - +2). Large **L**, if modelled precipitation objects are far from the observed conterparts. 

 * **SAL** can be activated in **xtool** by using *-op SAL* option. e.g.

```bash
 xtool -f1 model.grib -f2 observation.grib -op SAL -n namelist
```

 * Output of the **SAL** are 2 simple ascii-files:
  1. *scatter_plot.dat* containing date, **S**,**A** and **L** parameters.
  2. *sal_output.dat* containing more detailed statistics collected during the verification (location of center of mass, number of objects, measure of object size etc.).

## verobs


 Constructed initially to verify HIRLAM/MM5 data.

 Separate the data input from the internal data structure. Keeping everything in
 memory allows for strict consistency but it has some drawbacks.....

 Main structure 

 - Read namelist
 - Call my_choice
     - Read observations
     - Read model data

 - LOOP over namelists
     - Make station/area selection
     - Make quality control
     - Verify
     - Check for new namelist

- Verify
  For each station we loop over all (used) forecast lengths and accumulate the statistics 
  Data is stored by:
    - statistic by forecast length or time of day, for each station and for
      all stations used for MAP,VERT,GEN,DAYVAR
    - timeserie array for each station and for all stations ;TIME
    - scatter/contingency/frequency distribution. memory consuming!
      SCAT,XML,FREQ,CONT

    Output information as graphics (MAGICS) or text files suitable for e.g. gnuplot.


### Quality control

The quality control is controlled by the flag LQUALITY_CONTROL.
An observation is accepted if ABS(mod - exp) < err_limit for **ANY** experiment used
in the verification. Forecast lengths used for quality control can be set by namelist
variable QC_FCLEN. If QC_FCLEN is not set The forecasts < forecast interval is used.
The limits can be set explicitly in namelist by XX_LIM for each variable or by
QC_LIM for all variables. By setting ESTIMATE_QC_LIMIT the QC_LIM will be set as
SCALE_QC_LIM * STDV for the forecasts in QC_FCLEN.
QC ouput may be controlled by print_qc={0,1,2}


### Script framework

 It all started with an in-script namelist but user demands (read Xiaohua ) forced through a bit more complex structure....

  Separate on script level, different types of statistics
  (GEN,MAP,DAYVAR,TIME,FREQ,SCAT,CONT,XML) for different types of verification [maindefs.pm](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/scr/maindefs.pm)

```bash
 'DAYVAR' => {
          # Daily variation
          'LPLOT_STAT' => 'T',
          'LSTAT_GEN'  => 'T',
          'LFCVER'     => 'F',
          'USE_FCLEN'  => join(',',split(' ',$ENV{FCLEN_DAYVAR})),
          'SHOW_OBS'   => 'T',
         },
```

  For different variables [plotdefs.pm](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/scr/plotdefs.pm)

```bash
 'PE'=>{
           'TEXT'        => 'Precipitation',
           'CONT_CLASS'  => 7,
           'CONT_LIM'    =>'0.1,0.3,1.0,3.0,10.0,30.0,100.0',
           'MAP_BIAS_INTERVAL'=> '-20.,-10.,-5.,0.,5.,10.,15.',
           'TWIND_SURF'       => 00,
         },
```

  for different domains [areas.pm](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/scr/areas.pm)

```bash
'Norway' => {
          'STNLIST'=> '01025,01049,01102,01152,01205,01241,
              01271,01317,01384,01415,01452,01494',
           'MAP_SCALE'=>1.0e7,
        'MAP_CENTRE_LATITUDE'=>63.,
        'MAP_CENTRE_LONGITUDE'=>20.,
        'MAP_VERTICAL_LONGITUDE'=>-10.,
        'MAP_PROJECTION'=> '\'POLAR_STEREOGRAPHIC\'',
        'MAP_AREA_DEFINITION '=> '\'CENTRE\'',
        },

 'Baltex' => {
        'LPOLY'               => 'T',
        'POLYFILE'            => '\'Baltex.poly\'',
        'MAP_SCALE'           => 1.5e7,
        'MAP_CENTRE_LATITUDE' => 60.,
        'MAP_CENTRE_LONGITUDE'=> 30.,
        'MAP_VERTICAL_LONGITUDE'=>20.,
        'MAP_PROJECTION'      => '\'POLAR_STEREOGRAPHIC\'',
        'MAP_AREA_DEFINITION '=> '\'CENTRE\'',
        },

```

   Namelist 1 : reading,qc
     AREA:ALL
       Namelist 2 : GEN,MAPS       Namelist 3 : DAYVAR       Namelist 4 : TIMESERIE       Namelist 5 : SCATTER     AREA:Norway
       Namelist 6 : GEN,MAPS

  Several top level options are defined in [Env_exp](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/scr/Env_exp)

    * Basic PATHS
    * Experiment names and paths
    * Parameters and areas for surface/temp verification
    * Forecast lengths for different plots
    * Output format
    * Average format (monthly,period)
    * ALL_AT_ONCE=yes means read and verify all variables at the same time. More memory demanding
    * WebgraF settings

Examples :
    * [SMHI](https://hirlam.org/portal/smhi/WebgraF/ALARO_33h1/index.html?choice_ind=Surface)
    * [FMI](http://fminwp.fmi.fi/WebgraF/AROME/)
    * [Comparison of everything](https://hirlam.org/portal/oprint/ObsVer/InterComp/index.html?choice_ind=Surface)

[More info](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_verobs)


## WebgraF

   Orignially written to mimic the ECMWF "chart" facility
     - ECMWF solution is a perl based server solution
     - WebgraF is a javascript running locally i.e. portable

   Span the Menu space where each menu is an axis
      - Easy to distribute, compare, animate, organize your pictures,
      - Definition file driven
      - Internal date function
      - A perl script WebgraF to add/remove PROJECT/ENTRY

Examples :
      * [RAOBCORE](http://homepage.univie.ac.at/leopold.haimberger/leoweb/index.html) [Definition file](http://homepage.univie.ac.at/leopold.haimberger/leoweb/bg-obs_timeseries.js)
      * [ObsUse](https://hirlam.org/portal/oprint/ObsVer/ObsUse/) [Definition file](https://hirlam.org/portal/oprint/ObsVer/ObsUse/Obs_Map.js)
      * [Daily maps](https://hirlam.org/portal/smhi/WebgraF/ALARO_33h1/) [Definition file](https://hirlam.org/portal/smhi/WebgraF/ALARO_33h1/Maps.js)

[More info](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_WebgraF)


## FULLPOS

 * [Postprocessing switches](https://hirlam.org/trac/wiki/HirlamSystemDocumentation/Mesoscale/HarmonieScripts#Postprocessingandverification) in [config_exp.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/config_exp.h)
 * [Postprocessing Script](https://hirlam.org/trac/wiki/HirlamSystemDocumentation/Mesoscale/HarmonieScripts#Fullpospostprocessing).
 * [Fullpos namelists](https://hirlam.org/trac/wiki/HirlamSystemDocumentation/Mesoscale/HarmonieScripts#Fullposnamelists).


## [Hands On Tasks] (../../../HarmonieSystemTraining2008/Training/PostppVerification.md)


[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)
----
[[Center(begin)]]