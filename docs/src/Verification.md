```@meta
EditURL="https://hirlam.org/trac//wiki//Verification?action=edit"
```
# Verification


## Preparations

### fldextr and obsextr

These programs are part of the gl package.


  Fldextr extracts data from several sources (HIRLAM/IFS/AAA) and

   - recalculates rh,td to be over water (for HIRLAM)
   - Interpolates to geographical points according to a synop.list and temp.list
   - Does MSLP,RH2M,TD2M calculations if the are not available
   - Optional fraction of land check.
   - Interpolates to pressure levels for TEMP data.

Obsextr extracts BUFR data and creates an ascii file. similar to the vfld file.

   - Reads SYNOP and TEMP
   - LUSE_LIST controls the usage of a station list



## The verification step


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
  (GEN,MAP,DAYVAR,TIME,FREQ,SCAT,CONT,XML) for different types of verification [maindefs.pm](https://hirlam.org/trac/browser/Harmonie/util/monitor/scr/maindefs.pm)

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

  For different variables [plotdefs.pm](https://hirlam.org/trac/browser/Harmonie/util/monitor/scr/plotdefs.pm)

```bash
 'PE'=>{
           'TEXT'        => 'Precipitation',
           'CONT_CLASS'  => 7,
           'CONT_LIM'    =>'0.1,0.3,1.0,3.0,10.0,30.0,100.0',
           'MAP_BIAS_INTERVAL'=> '-20.,-10.,-5.,0.,5.,10.,15.',
           'TWIND_SURF'       => 00,
         },
```

  for different domains [areas.pm](https://hirlam.org/trac/browser/Harmonie/util/monitor/scr/areas.pm)

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

  Several top level options are defined in [Env_exp](https://hirlam.org/trac/browser/Harmonie/util/monitor/scr/Env_exp)

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

[More info](https://hirlam.org/trac/browser/Harmonie/util/monitor/doc/README_verobs)


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

[More info](https://hirlam.org/trac/browser/Harmonie/util/monitor/doc/README_WebgraF)
