```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2011/Lecture/Installation/LogFiles?action=edit"
```
# Where does the output go (log file)
During a run, $HM_DATA looks like this:
```bash
$ ls -l
total 312
drwxr-xr-x 10 harmonie harmonie   4096 Sep 16 10:53 20100114_00
drwxr-x--x  5 harmonie harmonie   4096 Sep 16 10:53 36h14
drwxr-xr-x  4 harmonie harmonie   4096 Sep 16 08:47 archive
drwxr-xr-x  2 harmonie harmonie   4096 Sep 16 10:52 bin
lrwxrwxrwx  1 harmonie harmonie     25 Sep 12 11:57 boundaries -> /home/harmonie/boundaries
drwxr-xr-x  2 harmonie harmonie   4096 Sep 16 08:49 climate
-rw-r--r--  1 harmonie harmonie   6180 Sep 16 10:54 harmonie.check
-rw-r--r--  1 harmonie harmonie  25212 Sep 16 10:50 harmonie.def
-rw-r--r--  1 harmonie harmonie  31493 Sep 16 10:50 harmonie.html
-rw-r--r--  1 harmonie harmonie  48122 Sep 16 10:54 harmonie.log
-rw-r--r--  1 harmonie harmonie  21037 Sep 16 10:50 harmonie.tdfinc
-rw-r--r--  1 harmonie harmonie 126874 Sep 16 10:23 HM_Postprocessing_2010011400.html
drwxr-xr-x 12 harmonie harmonie   4096 Sep 16 08:36 lib
-rw-r--r--  1 harmonie harmonie   8806 Sep 16 10:50 _mSMS_env
-rw-r--r--  1 harmonie harmonie   5555 Sep 16 10:54 mSMS.log
lrwxrwxrwx  1 harmonie harmonie     28 Sep 12 11:58 observations -> /home/harmonie/observations/
```
$HM_DATA on the c1a is $TEMP/hm_home/$EXP.

The textual output of all job steps go to files ending in '.1' under the directory with the experiment name (in this case 36h14):
```bash
$ find 36h14 -name '*.1'
36h14/Build/Utilities/Make_gl_grib_api.1
36h14/Build/Makeup_sync.1
36h14/Build/Makeup_configure.1
36h14/Build/Makeup.1
36h14/InitRun.1
36h14/MakeCycleInput/Hour/Prepare_cycle.1
36h14/MakeCycleInput/Hour/CollectLogs.1
36h14/MakeCycleInput/Hour/Climate/PGD/Prepare_pgd_fa.1
36h14/MakeCycleInput/Hour/Climate/PGD/Prepare_pgd_lfi.1
36h14/MakeCycleInput/Hour/Climate/Climate.1
36h14/MakeCycleInput/Hour/Boundaries/LBC3/ExtractBD.1
36h14/MakeCycleInput/Hour/Boundaries/LBC3/gl_bd.1
36h14/MakeCycleInput/Hour/Boundaries/Boundary_strategy.1
36h14/MakeCycleInput/Hour/Boundaries/LBC6/ExtractBD.1
36h14/MakeCycleInput/Hour/Boundaries/LBC6/gl_bd.1
36h14/MakeCycleInput/Hour/Boundaries/LBC0/ExtractBD.1
36h14/MakeCycleInput/Hour/Boundaries/LBC0/gl_bd.1
36h14/MakeCycleInput/Hour/Boundaries/Prep_ini_surfex.1
36h14/MakeCycleInput/Hour/Observations/RunBatodb.1
36h14/MakeCycleInput/Hour/Observations/RunInit.1
36h14/Date/Hour/Cycle/Analysis/AnSFC/RunCanari.1
36h14/Date/Hour/Cycle/Analysis/Addsurf.1
36h14/Date/Hour/Cycle/StartData/FirstGuess.1
```
On the c1a, this directory is /perm/ms/<country>/<username>/HARMONIE/$EXP.

The textual output of the runs of MASTERODB go to the directory with the name of the DTG (in this case 20100114_00), in a subdirectory named <hostname><pid>, with <hostname> the name of the machine the executable is running on and <pid> the process identification of the process that started it (in this case super17268):
```bash
$ ls -l super17268/
...
-rw-r--r-- 1 harmonie harmonie    7167 Sep 17 14:21 fort.4
...
-rw-r--r-- 1 harmonie harmonie    3333 Sep 17 14:29 ifs.stat
-rw-r--r-- 1 harmonie harmonie  213379 Sep 17 14:29 NODE.001_01
...
```
I retained only the names of the most important text files:
* fort.4 is the expanded namelist that governs the choices in the execution of the executable MASTERODB.
* ifs.stat gives a one line summary per time step.
* NODE.001_01 gives a more extensive summary per time step, like this:
```bash
 GPNORM HUMI.SPECIFI         AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.135265491587807E-02 0.119514310314242E-07 0.499117940489191E-02
 GPNORM LIQUID_WATER         AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.694470575859737E-05 -.338813178901720E-20 0.648113783893282E-03
 GPNORM SOLID_WATER          AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.143360917569503E-05 -.677626357803440E-20 0.170187712951283E-03
 GPNORM SNOW                 AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.571405743597527E-05 -.847032947254300E-21 0.291543468216362E-03
 GPNORM RAIN                 AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.838283188158673E-07 -.136584062744756E-19 0.556926372206092E-04
 GPNORM GRAUPEL              AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.215151566955265E-06 -.169406589450860E-20 0.140690799434056E-03
 GPNORM TKE                  AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.326003505419444E-01 0.999999999999265E-06 0.284994123942444E+01
 GPNORM CLOUD_FRACTION       AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.117364043181018E+00 0.000000000000000E+00 0.100000000000000E+01
 GPNORM SRC                  AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.305009499234427E-05 0.000000000000000E+00 0.105833404623172E-03
 GPNORM EZDIAG01             AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.000000000000000E+00 0.000000000000000E+00 0.000000000000000E+00
 GPNORM EZDIAG02             AVERAGE               MINIMUM               MAXIMUM        
         AVE   0.000000000000000E+00 0.000000000000000E+00 0.000000000000000E+00
 NSTEP =    52 STEPO   0AAA00AAA
 14:35:29 STEP   52 H=   0:52 +CPU= 13.069
```