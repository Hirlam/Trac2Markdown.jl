```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2019/Practicals?action=edit"
```

# Practicals
 * Binaries: cca:/perm/ms/spsehlam/hlam/daTraining/bin_cy43h2
 * Data: cca:/perm/ms/spsehlam/hlam/daTraining/data or ecgate:/hpc/perm/ms/spsehlam/hlam/daTraining/data

## Environment

**Every time you log in to ecgate**:
```bash
#
# on ecgate: add DA Training PATH, environment variables and modules
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
```

## ECMWF Quotas
Check your EMWF disk quotas (https://confluence.ecmwf.int/display/UDOC/File+systems) with the following:
 * ecgate ($HOME, $PERM, $SCRATCH)
```bash
ecquota
```
 * cca/ccb ($HOME, $PERM, $SCRATCH -- [https://confluence.ecmwf.int/display/UDOC/HPCF+user+filesystems](https://confluence.ecmwf.int/display/UDOC/HPCF+user+filesystems))
```bash
quota -s
```

You may wish to run some experiments in $SCRATCH (transient) instead of $PERM (permanent).

## Default ecFlow Server settings
 * Name: your userid:
```bash
whoami
```
 * Host: ecgb11
 * Port: uid+1500
```bash
expr `id -u $USER` + 1500
```

## Day 1
### BUFR Observations
Reference material:
 * [ecCodes](https://confluence.ecmwf.int/display/ECC/)
 * [GTS headers](http://www.wmo.int/pages/prog/www/ois/Operational_Information/Publications/WMO_386/AHLsymbols/AHLsymbols_en.html)
   * [T1 for T1T2A1A2ii definitions](http://www.wmo.int/pages/prog/www/ois/Operational_Information/Publications/WMO_386/AHLsymbols/TableA.html)
   * [CCCC location indicators](http://www.wmo.int/pages/prog/www/ois/Operational_Information/VolumeC1/CCCC_en.pdf)
 * [BUFR headers](https://confluence.ecmwf.int/display/ECC/BUFR+headers) (ecCodes)
 * [ECMWF BUFR data categories](https://apps.ecmwf.int/odbgov/bufrtype/)
 * [ECMWF BUFR local data sub-categories](https://apps.ecmwf.int/odbgov/bufrtype/)
 * [WMO BUFR data categories](http://www.wmo.int/pages/prog/www/WMOCodes/WMO306_vI2/LatestVERSION/WMO306_vI2_CommonTable_en.pdf) (Code table C-13)

**Practical: [BUFR Observations](eoinWhelan_Obs_Practical_NoSolutions.pdf:wiki:HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019)**

**Plotting:**
```bash
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
plotWmoObsConv -h       ## Plot WMO conventional BUFR
plotEcmObsConv -h       ## Plot ECMWF conventional BUFR
plotEumObsConv -h       ## Plot EUMETSAT satellite BUFR
plotOdbStatus  -h       ## Plot ODB status (report_status|datum_status)
plotOdbVals    -h       ## Plot ODB values (obsvalue|fg_depar|an_depar)
```

### Bator and ODB
Reference material:
 * [ECMWF ODB governance database](https://apps.ecmwf.int/odbgov)
 * [ODB](https://confluence.ecmwf.int/display/ODBAPI): ECMWF documentation and software
 * [ODB (MF)](http://www.umr-cnrm.fr/aladin/meshtml/DOC_odb/odb.php): List of useful links provided by Météo France
 * [GmapDoc: Observations](http://www.umr-cnrm.fr/gmapdoc/spip.php?rubrique33): ARPEGE/ALADIN/AROME (Météo France) documentation

**Practical:**
 * Produce some ODBs from ECMWF BUFR
```bash
#
#    BUFR --> ODB suite
#    Can cycle for 2018081900 --> 2018081921
#    One cycle uses about 720 MB in $PERM on cca
#
# on ecgate
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
mkdir -p $HOME/hm_home/daBufr2odb
cd $HOME/hm_home/daBufr2odb
HarmonieDA setup
#sed -i 's/\.perm\./.scratch./g' config-sh/config.ecgb-cca # Use $SCRATCH instead of $PERM
HarmonieDA start DTG=2018081900 PLAYFILE=bufr2odb
```

 * Produce ODBs from (OBSOUL and GTS BUFR) with stand-alone BATOR
```bash
#
# on cca/ccb
#
cd $PERM
tar xvf /perm/ms/spsehlam/hlam/daTraining/Day_1/sample_bator.tar
# follow exercises & guidelines
vi sample_bator/README

```


## Day 2
 * More about the exercises can be found [ here](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Screening_Monitoring_exercises.pdf)
 * Run Screening only
```bash
#
#    Screening suite
#    Can cycle for 2018081900 --> 2018081921
#    One cycle uses about 1.5 G B in $PERM on cca
#
# on ecgate
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
mkdir -p $HOME/hm_home/daScreening
cd $HOME/hm_home/daScreening
HarmonieDA setup
#sed -i 's/\.perm\./.scratch./g' config-sh/config.ecgb-cca # Use $SCRATCH instead of $PERM
HarmonieDA start DTG=2018081900 PLAYFILE=screening
```

 * Obsmon
```bash

# on cca/ccb
mkdir $TEMP/training
cd $TEMP/training
qsub /perm/ms/no/sbu/training/exercises/obsmon_training.job

# Results end up in $TEMP/training/obsmon/archive

# Visualize ODB with Shiny

# Extra
# Make a local copy of:
# /perm/ms/no/sbu/training/exercises/obsmon_training.job
# /perm/ms/no/sbu/training/exercises/include.ass-training

cp /perm/ms/no/sbu/training/exercises/obsmon_training.job  $TEMP/training/.
cp /perm/ms/no/sbu/training/exercises/include.ass-training $TEMP/training/.

# Modifiy the variable config in $TEMP/training/obsmon_training.job to $TEMP/training/include.ass-training

# Modify $TEMP/training/include.ass-training to only monitor e.g. AIRCRAFT

# Move $TEMP/training/obsmon/ if you want to keep it
mv $TEMP/training/obsmon $TEMP/training/obsmon-orig

# Submit modified job script
qsub $TEMP/training/obsmon_training.job


```

 * Local installation of obsmon
```bash
1. Get obsmon from hirlam.org:

  git clone https://git.hirlam.org/Obsmon obsmon

2. Install obsmon:

  cd obsmon

  ./install --local-install

3. Set up a valid config.toml file.
  This file tells obsmon where to find the experiments. Please take a look at
  the example file "config.toml.example" included with obsmon.

4. Finally, run obsmon:

  ./obsmon --launch
```

## Day 3

  * Reminder **Every time you log in to ecgate**:
```bash
#
# on ecgate: add DA Training PATH, environment variables and modules
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
```


 * Run Screening plus 3D-Var minimization single obs experiment (TEMP radiosonde observation at 500 hPa 1K warmer than the background)
```bash
#
#    Minim suite
#    Can cycle for 2018081900 --> 2018081921
#    One cycle uses about 2.8 GB in $PERM on cca
#
# on ecgate
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
mkdir -p $HOME/hm_home/daSingleObs
cd $HOME/hm_home/daSingleObs
HarmonieDA setup
#sed -i 's/\.perm\./.scratch./g' config-sh/config.ecgb-cca # Use $SCRATCH instead of $PERM
sed -i 's/USEOBSOUL=0/USEOBSOUL=1/g' scr/include.ass
sed -i 's/SINGLEOBS=no/SINGLEOBS=yes/g' sms/config_exp.h
HarmonieDA start DTG=2018081900 PLAYFILE=singleobs
```

 * Run Screening plus 3D-Var minimization
```bash
#
#    Minim suite
#    Can cycle for 2018081900 --> 2018081921
#    One cycle uses about 2.8 GB in $PERM on cca
#
# on ecgate
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
mkdir -p $HOME/hm_home/daMinim
cd $HOME/hm_home/daMinim
HarmonieDA setup
#sed -i 's/\.perm\./.scratch./g' config-sh/config.ecgb-cca # Use $SCRATCH instead of $PERM
HarmonieDA start DTG=2018081900 PLAYFILE=minim
```

## Day 4

 * Run Surface DA (CANARI + SURFEX OI)
```bash
#
#    Surf suite
#    Can cycle for 2018081900 --> 2018081921
#    One cycle uses about 1.9 GB in $PERM on cca
#
# on ecgate
#
. /home/ms/spsehlam/hlam/daTraining/user_env.sh
mkdir -p $HOME/hm_home/daSurf
cd $HOME/hm_home/daSurf
HarmonieDA setup
#sed -i 's/\.perm\./.scratch./g' config-sh/config.ecgb-cca # Use $SCRATCH instead of $PERM
HarmonieDA start DTG=2018081900 PLAYFILE=surf

# Now turn off your screen level and snow analysis. (see presentation)

nam/harmonie_namelists.pm:

NACTEX=>{
'LAET2M' => '.FALSE.,',
'LAEH2M' => '.FALSE.,',
'LAESNM' => '.FALSE.,',

# Re-run your experiment
HarmonieDA start DTG=2018081900 PLAYFILE=surf

```

 * Run SODA for TEST_11 DOMAIN with FA files as input
```bash
#
# On cca/ccb
#

mkdir -p $TEMP/training/
cd $TEMP/training/
/perm/ms/no/sbu/training/exercises/prepare_exp.sh TEST_11 FA

# Do modifications if wanted inside $TEMP/training/TEST_11_FA
# Submit batch job
qsub /perm/ms/no/sbu/training/exercises/TEST_11_FA.job

# You will get an outputfile in
$TEMP/training/TEST_11_FA/SURFOUT.fa

# This file should be the input to 3D-VAR/initialization/forecast as ICMCHANAL+0000.sfx

# The standard output is found in $TEMP/training/TEST_11_FA.job.o*
# The output from the IO node is in $TEMP/training/TEST_11_FA/LISTING_SODA0.txt

```

* Run SODA for TEST_11 DOMAIN with NetCDF files as input and on several CPUs
```bash
#
# On cca/ccb
#

mkdir -p $TEMP/training/
cd $TEMP/training/
/perm/ms/no/sbu/training/exercises/prepare_exp.sh TEST_11 NC

# Do modifications if wanted inside $TEMP/training/TEST_11_NC
# Submit batch job
cd $TEMP/training/
qsub /perm/ms/no/sbu/training/exercises/TEST_11_NC.job

# You will get an outputfile in
$TEMP/training/TEST_11_NC/SURFOUT.nc

# You will also get NetCDF files for prognostic and diagnostic variables

# This file should be the input to e.g. other offline runs
# These files are convenient for offline runs, but the diagnostic does not 
# make sense for the assimilation (no time step is performed)

# The standard output is found in $TEMP/training/TEST_11_NC.job.o*
# The output from the IO node is in $TEMP/training/TEST_11_NC/LISTING_SODA0.txt
# Have a look on increments in: $TEMP/training/TEST_11_NC/LISTING_SODA0.txt

#
# Calculate increments from the files:
#
# Load modules (if needed)
module load nco
module load ncview

# Enter working directory
cd $TEMP/training/TEST_11_NC

# Calculate difference with nco
ncdiff -O SURFOUT.nc PREP.nc ANINC.nc

# Look at the increments 
ncview ANINC.nc 


############# START OF NEW EXP #########################
# Now let us play with some settings
# First take a copy of your previous experiment. Here it is called TEST_11_NC-MY-PREVIOUS-EXP-DESCRIPTION

mv $TEMP/training/TEST_11_NC $TEMP/training/TEST_11_NC-MY-PREVIOUS-EXP-DESCRIPTION

# Re-do the above steps as listed here:
#
cd $TEMP/training/
/perm/ms/no/sbu/training/exercises/prepare_exp.sh TEST_11 NC

# Do modifications inside $TEMP/training/TEST_11_NC
# See exercises below. Modify OPTIONS.nam !!!!

# Submit batch job
cd $TEMP/training/
qsub /perm/ms/no/sbu/training/exercises/TEST_11_NC.job

# The standard output is found in $TEMP/training/TEST_11_NC.job.o*
# The output from the IO node is in $TEMP/training/TEST_11_NC/LISTING_SODA0.txt

#
# Calculate increments from the files:
#
# Load modules (if needed)
module load nco
module load ncview

# Enter working directory
cd $TEMP/training/TEST_11_NC

# Calculate difference with nco
ncdiff -O SURFOUT.nc PREP.nc ANINC.nc

# Look at the increments 
ncview ANINC.nc 

# Compare the experiments

######### END OF NEW EXP ################

Exercise 1)

Turn off all observation increments
&NAM_OBS
....
  NOBSTYPE  = 0,
  NNCO      = 0,0,0,0,0
/

Turn off snow update:
&NAM_ASSIM
  LAESNM              = .FALSE.


Did you get any increments for soil moisture and soil temperature? Why, or why not?

Exercise 2)

.......

```

## Day 5
 - Instructions and exercises: [Diagnostic tools](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/diagnostics_in_DA_exercises.pdf)

* Diagnosis of spinup (ECHKEVO): exercise 1
```bash
  on cca: cd $SCRATCH or $TEMP
  cp /perm/ms/spsehlam/hlam/daTraining/Day_5/sample_echkevo .
```

* Perturbation of observations and Degrees of Freedom for Signal (DFS): exercises 2-4
```bash
  on cca: cd $SCRATCH or $TEMP
  cp /perm/ms/spsehlam/hlam/daTraining/Day_5/sample_dfs .
```

* Diagnosis of B and R using Obstool: exercise 5
```bash
  on cca: cd $SCRATCH or $TEMP
  cp /perm/ms/spsehlam/hlam/daTraining/Day_5/sample_obstool .
```












