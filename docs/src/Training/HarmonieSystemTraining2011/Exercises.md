```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Exercises?action=edit"
```

# Hands On Practice

## Test data and preparations

* Testbed data
 *ECMWF data, observations and climate files for DOMAIN=TEST_11 [Testbed data](https://hirlam.org/portal/download/system_training_2011/testbed_data.tar)
* Verification data
 * vobs files, vfld files for C11, AO_SCAND55_SFX for 201109. [Monitor data](https://hirlam.org/portal/download/system_training_2011/monitor_test_data.tar.gz)
 * More data for verification can be found on ` ecgate:/scratch/ms/dk/nhz/oprint/ `
* Ubuntu specific
 * Ubuntu uses /bin/dash as default shell. This does not work with many of the Harmonie scripts, but the script [sh2bash.sh](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2011/Exercises/sh2bash.sh) is a script to do convert /bin/sh to /bin/bash for you. Save the script and run it by:
```bash
./sh2bash.sh path-to-your-harmonie-check-out
```

### Tools & Graphics

 * [Output formats] (../../HarmonieSystemDocumentation/FileFormats.md)
 * [gl commands] (../../HarmonieSystemDocumentation/PostPP/gl.md)

 * [MetgraF](http://netfam.fmi.fi/Museo/Riga/MetgraF/metg2.htm)
  * on ecgate
```bash

cd $SCRATCH
rsync -vaux /scratch/ms/spsehlam/hlam/metgraf . 

```
  A set of example scripts are available under the plot directory. Change `Plot` to get e.g. the following pictures.
      
  * elsewhere, you also need emoslib installed
```bash

svn co https://svn.hirlam.org/trunk/contrib/metgraf
gmake COMPILER=gfortran

```
 * Grads
 * Metview
 * Python (pygrib)

## General

## Installation of HARMONIE model on LinuxPC?

== Running HARMONIE 36h1.4 on ECMWF hpc or Linux PC

 * Select from a list of proposed configuration options to configure an experiment
 * run 1 to 2 experiment cycles
 * examine and diagnose results
   * monitoring ongoing runs via mXCDp interface.
     * Halt, resume, kill, resubmit a task.
   * find input and output data
   * study run logs
      * resource consumptions, profiling informaiton...

## Post-processing

 ### Fullpos

 * Post-processing with fullpos, exercise: Try out the different post processing types
```bash
PPTYPE=""                               # Postprocessing type, space separated list
                                        # pp = pressure levels
                                        # md = model level diagnostics
                                        # zz = height levels
                                        # sat = satellite radiances (AROME)
```

 ### Xtool

[learn to use GL/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)
  * Run a difference between to files and print the result on the screen
  * Compare the orography between to files with SAL. Change the thresholds
  * Make a analysis increment file for a month of RCR data

 ### gl

 
[learn to use GL/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)

   * use basic GL functionalities
     * Convert from FA/LFI to GRIB
     * Convert a subset of fields
     * Interpolate to a new domain
     * Extract gridpoints
     * Postprocess to pressure levels
     * Add missing FA/LFI to GRIB translations
   * use fldextr to extract model data for obs verification
     * Find what is wrong with the TD calculation for ALADIN
   * use obsextr to extract observation data for obs verification
     * Run with and without station list
   * use xtool to manipulate fields
     * Print difference between to fields on the screen
     * Create accumulated differences 
     * Create a monthly average
     * Use SAL to compare different fields from different resolutions

## Dynamics

## Physics

Possible tasks in HARMONIE physics  [(phystask.pdf)](http://netfam.fmi.fi/harmonietrain/phystask.pdf). Background info in the lecture [(harphys_LR.pdf)](http://netfam.fmi.fi/harmonietrain/harphys_LR.pdf)

## Monitoring

 ### Verification

     * Download the trunk to your laptop and try the [testdata](https://hirlam.org/portal/download/system_training_2011/monitor_test_data.tar.gz) set.

```bash
        svn co https://svn.hirlam.org/trunk/harmonie/util/monitor 
        cd monitor
        gmake ARCH=linuxgfortran
        wget https://hirlam.org/portal/download/system_training_2011/monitor_test_data.tar.gz --no-check-certificate
        gunzip monitor_test_data.tar.gz
        tar xvf monitor_test_data.tar
        cd scr
        ./Run_verobs_all ../monitor_test_data/Env_test_data
        firefox ../WebgraF/index.html
```

     The result should look like this [https://hirlam.org/portal/smhi/WebgraF_test_data/]

     * use verobs to inter-compare different experiments to obs.
     * Play with different forecast lengths, areas parameters
     * Add a new area, change the map view, define a polygon
     * Remove the quality control, fix the quality control
     * Plot some single stations
     * Blacklist stations
     * Create new contingency tables
     * Create monthly averages for several months
     * Change the time window for time series
     * Play with the quality control

 ### WebgraF


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


## Data assimilation

### # Upper Air assimilation



     * Interpolate background error statistics from one area to another by using jbconv
     * Diagnose the background error statistics of one particular domain using jbdiagnose
     * Carry out a data assimilation experiment with your newly interpolated statistics
     * Carry out a single observation impact study and plot data assimilation increments and check sensitivity ro REDNMC
     * Carry out full scale data assimilation experiment and check sensitivity to REDNMC,REDZONE 
     * Carry out full scale data assimilation experiment. Put AMDAR observations passive and check sensitivity to the use of AMDAR data
     * Plot the evolution of the cost function, Jb, and Jo, for a full scale data assimilation experiment. Check sensitivity to REDNMC.
     * Blacklist NOAA 19 AMSU-A channel 7 and run data assimilation with AMSU data (except ch 7).  
     * Start to derive structure functions for a new or existing domain utilizing downscaling of ECMWF ensemble data assimilation analyses (extensive, to bring home).

Useful guidance can be found in [and [https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/SingleObs](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/Structurefunctions]) and in presentations from data assimilation part of System Traning week.

### # Surface assimilation

* 1.) OI_MAIN: Try giving the observations more/less weight and see the impact

The namelist for OI_MAIN is found here:
[The namelist for OI_MAIN](https://hirlam.org/trac/browser/tags/harmonie-36h1.4/nam/OI_MAIN.nam)

If you tune the default values below of sigmas for the observation of RH2M and T2M you will get very different results. Try it out!
```bash
  SIGH2MO     = 0.10,
  SIGT2MO     = 1.0,
```
[oi_cacsts is the routine performing the real anaylsis](https://hirlam.org/trac/browser/tags/harmonie-36h1.4/src/surfex/offlin/assim/oi_cacsts.f90)

* 2.) EKF_MAIN

In cycle 37, EKF is introduced in a more stable resarch mode. In EKF you perturb the control variables and run with an offline version of SURFEX. The binaries are available in cycle 37, but a test setup is prepared here to be run on c1a.

```bash
# Log in to c1a and go to TEMP and create an experiment
cd $TEMP
mkdir offline_exp
cd offline_exp

# Get binaries, and some default namelist and forcing files from Trygve's account by running this script:
/ws/scratch/ms/no/sbu/offline/prep.sh

# Now you have the data needed two sample job scripts
# First you can generate your forcings by running the script create_forcing.job
llsubmit create_forcing.job

# At this stage you have everyting needed for offline surfex. 
# If you want to play around more, this is the place where you can modify your namelist OPTIONS.nam.
llsubmit offline.job

# Voila!
# The output file is converted to grib and is called: SURFOUT.20110815_18h00.grib

# EXERCISE 0: Perform all the steps above

# Repeat last step with other namelist variables.
# EXERCISE 1: Decreaste the surface time step XSTEP_SURF
# EXERCISE 2: Write out tile information. Define in OPTIONS.nam the namelist block below: 
```
```bash
&NAM DIAG SURF ATMn
  LFRAC=.TRUE.
/
```

[ Back to the main page of the HARMONIE system training 2011 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2011)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)