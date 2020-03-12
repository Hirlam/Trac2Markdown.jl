```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2016/Exercises?action=edit"
```


# Hands On Practice

## Test data and preparations
* Verification data
 * vobs files, vfld files for AROME 38h1.1 and 38h1.2.beta.2 for 201401. [Monitor data](https://hirlam.org/portal/download/system_training/monitor_test_data.tar.gz)
 * More data for verification can be found on ` ecgate:/scratch/ms/dk/nhz/oprint/ `

## Postprocessing exercises


### FULL-POS

[FULL-POS documentation](../../HarmonieSystemDocumentation/PostPP/Fullpos.md) will hopefully help with the following exercise.
 * Exercise 1:Instructions to add extra FULL-POS parameters in the [Select_postp.pl](https://hirlam.org/trac/browser/tags/harmonie-40h1.1/scr/Select_postp.pl) perl script to any of your experiments are detailed below.
   * On ecgate "check out" scr/Select_postp.pl:
```bash
cd $HOME/hm_home/YOUR_EXP
~hlam/harmonie_release/tags/harmonie-40h1.1/config-sh/Harmonie co scr/Select_postp.pl
cp scr/Select_postp.pl scr/Select_postp.pl_original
```
   * Add *u* and *v* (only) on height above ground levels at 75m, 125m and 150m to the model output.
     * Hint 1: RFP3H will need to changed
     * Hint 2: namfpdyh_lev will need to be changed and namfpdyh_lev2 will need to be created to allow for extra *u* and *v* levels
   * Rerun a short period to test your changes:
```bash
~hlam/harmonie_release/tags/harmonie-40h1.1/config-sh/Harmonie prod DTGEND=YYYYMMDDHH BUILD=no
```


### gl

 Examples and data are available on ecgb under

```bash
/scratch/ms/spsehlam/hlam/Training/gl/exercises/Run_gl_examples
```

Copy the full directory to your own scratch area on ecgb

```bash
rsync -vaux /scratch/ms/spsehlam/hlam/Training/gl/ $SCRATCH/gl_training/
```



 * Exercise 2: Convert FA file (ICMSHHARM+0003, say) to GRIB with gl à la Makegrib:
   * On cca or your PC choose a forecast FA file to convert to GRIB
   * Convert this file to GRIB1 using gl
   * Use gl or grib_ls to list the contents of your GRIB file

 * Exercise 3: Vertical interpolation with gl exercise (model levels --> pressure levels)
   * Use the forecast FA file from *Exercise 2* to convert to GRIB and carry out vertical interpolation
   * Output temperature on heights above ground at levels 1.0m, 1.5m, 2.0m, 2.5m and 3.0m only
   * Test impact of using  VINT_Z_ORDER=0 vs  VINT_Z_ORDER=1
     * Hint 1: Use lwrite_pponly= .TRUE.,
     * Hint 2: Use level type (pppkey%ttt) = 125

 * Exercise 4: Horizontal interpolation with gl exercise (lambert --> rotated lat-lon)
   * Use the forecast FA file from *Exercise 2* to convert to GRIB and carry out horizontal interpolation
   * Use gl_grib_api to produce a 50x50 0.02° rotated lat-lon grid of data centred on Malmo (if you are using the MALMO domain)
     * Hint 1: Ole's domain tool may help: [https://www.hirlam.org/nwptools/domain.html](https://www.hirlam.org/nwptools/domain.html)

 * Exercise 5: Extract set of grid-points with gl exercise:
   * Use the forecast FA file from *Exercise 2* to extract some grid-point information
   * Use gl to extract 2m temperature for the following SYNOP locations: "LUND, SOL"; "MALMO"; "MALMO-STURUP"
     * Hint 1: Use [util/gl_grib_api/scr/allsynop.list](https://hirlam.org/trac/browser/trunk/harmonie/util/gl_grib_api/scr/allsynop.list) to get the lat/lon information

 * Exercise 6: Produce postprocessed parameters using gl
      * Use the forecast FA file from *Exercise 2* to produce some postprocessed parameters
      * Use gl_grib_api to produce *Total precipitation*, *Visibility* from your model output file.
        * Hint 1: Have a look at [HarmonieSystemDocumentation/Forecast/Outputlist/40h1#Variablespostprocessedbygl](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/Forecast/Outputlist/40h1#Variablespostprocessedbygl)

 [gl documentation](../../HarmonieSystemDocumentation/PostPP/gl.md) 

### xtool

[learn to use gl/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)
  * Run a difference between to files and print the result on the screen
  * Compare the orography between to files with SAL. Change the thresholds
  * Make a analysis increment file for a month of RCR data
   * use xtool to manipulate fields
     * Print difference between to fields on the screen
     * Create accumulated differences 
     * Create a monthly average
     * Use SAL to compare different fields from different resolutions

### fldextr/obsextr

   * use fldextr to extract model data for obs verification
   * use obsextr to extract observation data for obs verification
     * Run with and without station list

## Monitoring

 === Verification ===

     * Try the setup on ecgb available under

```bash
       cd $SCRATCH 
       rsync -vaux /scratch/ms/spsehlam/hlam/Training/monitor .
       cd monitor/scr
       ./Run_verobs_all ./Env_exp_example 2>&1 | tee logfile

```

     The result should look like this [https://hirlam.org/portal/smhi/HARMONIE_MONITOR/monitor_2016_example]

     * Play with different forecast lengths, areas parameters
     * Add a new area, define a polygon
     * Remove the quality control, fix the quality control
     * Plot some single stations
     * Blacklist stations
     * Create new contingency tables
     * Create monthly averages for several months
     * Change the time window for time series
     * Try some conditional verification

 === WebgraF ===

   * Download the WebgraF code

```bash
        svn co https://svn.hirlam.org/trunk/harmonie/util/monitor/WebgraF
        cd WebgraF
        export WEBGRAF_BASE=$PWD/WebgraF
        WebgraF/bin/WebgraF
```
     
     Open WebgraF/index.html in your browser

   * Present data through WebgraF
     * Extract the definition file from a page
     * Create a new project/entry
     * Add info links

[Learn about the page definition file](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/WebgraF/src/input.html)

     * Change colors titles and texts
     * Turn on all do_* flags
     * Create a dynamic date axis
     * Create a page with links to external plots 
     * Export a page
     * Transport a page

## HARP
  
     * Download [Harp](https://hirlam.org/trac/attachment/wiki/HARP/Harp_20161213.tar.gz)
     * Install Harp

  === EPS ===

     * Get observations for 1 May - 31 August 2015 and 2016
     * Choose an experiment from /scratch/ms/no/fa1m/vfld
     * Make a HARPenv.<experimentName> file using eps/conf/HARPenv.default as your starting point
     * Extract the vfld files to sqlite format using eps/scr/run_harp_fc2sqlite.ksh for T2m (Hint: the domain is called MetCoOp)
     * Run the verification for T2m using eps/scr/run_harp_verif.ksh
     * View the output in shiny
     * Repeat for other parameters / experiments
     * Change or set a defualt colour for your experiments
     * Play with observation tolerances and check log files for differences in rejected stations

### Spatial

     * Get model grib [here](https://hirlam.org/trac/browser/Harp_sample/data/fc/harm) (only grib) and radar observations [here](https://hirlam.org/trac/browser#Harp_sample/data/radar/eur_15m)
     * Starting from Harp/conf/conf_default.R create a config-file for this (your own) experiment. Don't forget to add domains in the conf_defaul.R file.
     * Copy domains_extra.R in /conf/gallery to /conf: Domain of Grib is HARMSA, radar data is on domain RADEUR (choose one of them for common_domain)
     * Pay attention on variable "OB_datapath" and how to find out the path to observations in hdf5 file
     * Run verification for this experiment
     * Run shiny-server and ...
     * ... view the output in shiny (you will wind it in custom experiment)
     * You will realize, you can't go back to the date of your experiment -> look up in file /shiny/settings/set_dates.R
     * Try with you own data



[ Back to the main page of the HARMONIE system training 2012 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2011)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)
