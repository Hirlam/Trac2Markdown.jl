```@meta
EditURL="https://hirlam.org/trac//wiki//Harmonie-local-njord-exp1?action=edit"
```

## met.no Harmonie setup
# Example of setting up an experiment similar to the operational HM04 with cy36h1.1 and gmkpack 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Following example shows the steps to launch an Harmonie experiment HM04_oper on njord. The path to the HARMONIE release could be any of the releases found under ~forecast/HL_release. The first example here implicit assumes that you have used the release ~forecast/HL_release/harmonie-36h1.1/, which is the same as the operational HM04 when this tutorial is written. This example will demonstrate how to recreate the operation HM04 with cy36h1.1 and gmkpack:

If you copy and paste, take care as the lines might wrap!

 1. Create an experiment directory under $HOME/hm_home and run the setup. Edit basic configuration files such as [Env_system](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/config.njord) and [sms/config_exp.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/config_exp.h) to configure your experiment scenarios. Modify specifications for model versions (ALADIN, AROME, ALARO), data locations, settings for dynamics, physics, domain, coupling host model etc. You can also use some of the predefined configurations by using `-c CONFIG`. where `CONFIG` is one of the setups defined in [Harmonie_testbed.pl](https://hirlam.org/trac/browser/trunk/harmonie/scr/Harmonie_testbed.pl). If you give `-c` without an argument or a non existing configuration a list of configurations will be printed. If you run harmonie setup without `-c`, this would give you the default setup. The default setup and the different configurations are subjects of changes, and ALARO is for example in cycle 36h1.3 default with surfex. This means that we will need to do some local modifications in the basic configuration files such as [Env_system](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/config.njord) and [sms/config_exp.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/config_exp.h) to configure our experiment scenario. These could be data locations, settings for dynamics, surface model, physics, domain, coupling host model etc. We will not use a pre-defined configuration here to make it simpler to merge with HM04 afterwards

```bash
#!sh
   alias Harmonie='/home/ntnu/forecast/HL_release/harmonie-36h1.1/config-sh/Harmonie'  # Save us from typing full path to the Harmonie script
   mkdir -p $HOME/hm_home/HM04_oper                                                    # -p also creates hm_home if not existing
   cd $HOME/hm_home/HM04_oper                                                          # Enter our experiment
   Harmonie setup -r /home/ntnu/forecast/HL_release/harmonie-36h1.1/ -h njord          # Setup for njord for cy36h1.1
```


 2. Modifications needed from the default configuration to resemble our HM04 experiment

A good tool to check the differences between to experiments is tdiff, installed on the forecast user:
```bash
   /home/ntnu/forecast/bin/tdiff $HOME/hm_home/HM04_oper /home/ntnu/forecast/hm_home/HM04
```

In January 2011, you will find the following files have differences (3 files):
```bash
   Env_submit   # Symlink to config-sh/submit.njord
   Env_system   # Symlink to config-sh/config.njord
   config-sh/config.njord
   config-sh/submit.njord
   sms/config_exp.h
```

and the following are only in HM04:
```bash
   experiment_is_locked         # Created by the system, can be ignored
   nam/harmonie_namelists.pm
   progress.log                 # Created by the system, can be ignored
   progressPP.log               # Created by the system, can be ignored
   scr/Climate
   scr/FetchOBS
   scr/FirstGuess
   scr/Forecast
   scr/Gather_extract
   scr/Makegrib
   scr/Prep_ini_surfex
   scr/RunCanari
   scr/Run_fldver
   scr/Verify_harmonie
   src/surfex/isba/phys/sso_beljaars04.f90
   util/gl/config/config.njord
   util/gl/prg/domain_prop.F90
   util/gl/prg/fldextr.F
   util/gl/prg/gl.F90
   util/gl/prg/xtool.F90
```
 

If you want to use your local modified source or script changes, you need to check it out and modify it accordingly the following way:
```bash
#!sh
   cd $HOME/hm_home/HM04_oper 
   Harmonie co scr/Climate                                         # retrieve default script RunCanari (co: check out functionality)
   vi scr/Climate                                                  # modify the script, alternatively use e.g. emacs
   ~forecast/bin/xxdiff scr/Climate /home/ntnu/forecast/hm_home/HM04/scr/Climate # You will see that differences come for enabling of mean orography instead og envelope
   # Manually merge the differences or choose the right file and save as left.
```

Two short-cuts:
```bash
#!sh
   # Check out all the files unique for HM04:
   for file in nam/harmonie_namelists.pm scr/Climate scr/FetchOBS scr/FirstGuess scr/Forecast scr/Gather_extract scr/Makegrib scr/Prep_ini_surfex scr/RunCanari scr/Run_fldver scr/Verify_harmonie src/surfex/isba/phys/sso_beljaars04.f90 util/gl/config/config.njord util/gl/prg/domain_prop.F90 util/gl/prg/fldextr.F util/gl/prg/gl.F90 util/gl/prg/xtool.F90; do Harmonie co $file; done

   # Run xxdiff on all files:
   for file in sms/config_exp.h Env_submit Env_system nam/harmonie_namelists.pm scr/Climate scr/FetchOBS scr/FirstGuess scr/Forecast scr/Gather_extract scr/Makegrib scr/Prep_ini_surfex scr/RunCanari scr/Run_fldver scr/Verify_harmonie src/surfex/isba/phys/sso_beljaars04.f90 util/gl/config/config.njord util/gl/prg/domain_prop.F90 util/gl/prg/fldextr.F util/gl/prg/gl.F90 util/gl/prg/xtool.F90; do ~forecast/bin/xxdiff $file /home/ntnu/forecast/hm_home/HM04/$file; done
```

Some of you might be used to from HIRLAM to copy the whole directory from a reference when you start new experiments, and this can also be done for HARMONIE, but with one important exception. The file experiment_is_locked must be deleted before you run HARMONIE for you own experiment.

For this test it should mostly be sufficent to merge all data from HM04. However, some files must be changed after merging:

change in Env_submit:
```bash
#!perl
   $nprocx=8;
   $nprocy=16;

   # And replace the task list
   @backg_list  = ('InitRun','Create_exp','Make_gl_ecgate','Verify_harmonie','Make_monitor','Wait4file','Listen');
   if (( $ENV{USER} eq "forecast" ) || ( $ENV{USER} eq "metnotst" )) {
     @scalar_list = ('default','RunBatodb','RunCanari','Prep_ini_surfex');
     @par_list    = ('Dfi','Forecast','Postpp','ifs2aro','hir2aro','ald2aro','ald2ald',
                'FirstGuess','RunScreening','RunMinim','Build_rootpack'); 
   }else{
     # This block is for normal users. Is not working in 36h1.1 default installation for HM04_oper and must be modified to this
     @scalar_list            = ('Climate','RunBatodb','RunCanari','Prepare_pgd','Prep_ini_surfex','OI_main');
     @scalar_background_list = ('default','FirstGuess');
     @par_list    = ('Dfi','Forecast','Postpp','ifs2aro','hir2aro','ald2aro','ald2ald',
                             'RunScreening','RunMinim');
   }
```

change in sms/config_exp.h:
```bash
#!sh
   CREATE_CLIMATE=${CREATE_CLIMATE-yes}   # This enable us to turn off climate generation from the job script
   OPERATIONAL_POSTP=no                   # Makes the post-processing happen after forecast is finished. Avoid messing with our memory usage
   POSTP=no                               # Don't do any post-processing by full-pos. Very demanding!!!
   WRITUPTIMES="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 27 30 33 36 39 42 45 48 51 54 57 60"
```

check out and change in msms/harmonie.tdf:
```bash
                  family LBC@N@
if ( @N@ < 6 )
               trigger ( Boundary_strategy == complete )
else
               trigger ( LBC@N-6@ == complete )
endif
               task ExtractBD

   ...............


if( $ENV{TDF_VERITIMES} =~ /\b@N@\b/ )
            family fldextr@N@
ifeq($ENV{FLDEXTR},no)
               complete 1
endif

if( $ENV{USE_STNLIST} ne 'yes' && $ENV{OBSEXTR} eq 'bufr' )
if ( @N@ > 2 )
               trigger ( fldextr@N-3@ == complete )
else
               trigger ( ../FetchOBS == complete )
endif
else
if ( @N@ > 2 )
               trigger ( fldextr@N-3@ == complete )
endif
endif
               task Run_fldver
            endfamily # fldextr
endif



   ...............



               family Makegrib@N@
if ( @N@ > 2 )
               trigger ( Makegrib@N-3@ == complete )
else
               trigger ( ../Verify_harmonie == complete )
endif
               task Makegrib
            endfamily # Makegrib@N@

```
Remarks: if,else and endif should be first in the line. The hard-coded 2 (and 3) defines how many mini-SMS tasks in parallell. The LBC@N@ family is a part of the Boundaries family. 

check out and change in sms/Archive_log.sms:
```bash
#!sh
    #Add sleep 5 before the line "tar -cvf log_$LOGARCHIVE.tar -X $HM_DATA/log_exclude.$$ $LOGARCHIVE"
    sleep 5
```

insert somewhere in scr/Forecast
```bash
#!sh
    # Prints loadleveller information. Is useful to see which nodes you are running on as the file /var/loadl/epilog,out 
    # on the master node would report if the job was killed because of memory usage
    env | grep LOADL
```

change in scr/Makegrib
```bash
#!sh
    # Replace the line G=${RUNHARFILE}_${HH}+${FFF}.grb             # Atmospheric GRIB file
    # by this test to get the DTG in the output filenames. Otherwise they will be overwritten every day
    if [ "$USER" == "forecast" ]; then
      G=${RUNHARFILE}_${HH}+${FFF}.grb             # Atmospheric GRIB file
    else
      G=${RUNHARFILE}_${DTG}+${FFF}.grb             # Atmospheric GRIB file
    fi
    # Add this line to make sure the directory exists
    [ -d $RUNHAR ] || mkdir $RUNHAR
```

check out and change in scr/submission.db:
```bash
#!sh
    # replace 12 by 24 to only get long forecasts for 00 UTC
    if ( $HH % 24 ) { $LL = $llshort; } else { $LL = $ENV{LLMAIN}; }
```

Now we will run on 128 CPU's (8 nodes) with a 2-D De-composition of the CPU's with 8 by 16.

 3. Launch the experiment by giving start time, DTG, end time, DTGEND, and forecast length, LLMAIN or LL. Since we are on njord, we need to do this from a loadleveller job. The account should be set to an account that you have access to. mip000 is the account for operational testing.

```bash
#!sh
#!/bin/bash
#@ account_no = mip000
#@ shell = /usr/bin/sh
#@ job_type = parallel
#@ output   = HM04_oper.log
#@ error    = HM04_oper.log
#@ job_name = HM04_oper
#@ class = large
#@ node = 8 
#@ tasks_per_node = 16
#@ network.MPI = sn_all,,us
#@ environment = OMP_NUM_THREADS = 1
#@ resources = ConsumableCpus(1) ConsumableMemory(830mb)
#@ wall_clock_limit = 200:00:00
#@ cpu_limit = 200:00:00
#@ notification = never
#@ queue
#

##############################################################################################################
#    Your settings
#
JOBNAME="HM04_oper"     # Same as job_name in the header above. Should be unique for the experiment
DTGBEG_USER=2007120218  # Start of your simulation. Used the first time you run the model. When re-submitting DTGBEG is found in progress.log
DTGEND=2007120400       # End of your simulation. Can be extended. 
LLMAIN=36               # The forecast length on main cycles. For testdata this is only 00 UTC
EXP=HM04_oper           # Your experiment name. When exported this is also "visible" for "Harmonie start"
BUILD=yes               # If you are restarting your experiment and you don't want to re-compile, set this to no
CREATE_CLIMATE=yes      # Could be set to no if already have your climate files for the full period to save some time
EXT_TEST_BDDIR=/home/ntnu/forecast2/TESTDATA/ParRunsWinter/savehirH08  # Set the path for our H08 boundaries
KEEPHOUR=24             # Hours before ARCHIVE is cleaned
##############################################################################################################


############################### You probably don't need to edit below this line ###############################
###############################################################################################################

# Include common local Harmonie shell functions
if [ -f /home/ntnu/forecast/Harmonie_Funcs.sh ]; then
    source /home/ntnu/forecast/Harmonie_Funcs.sh || exit 1
else
   echo "Necessary Harmonie functions are missing"
   exit 1
fi

#
# Finding job information
jobid=`/home/ntnu/forecast/bin/get_job_id.sh $JOBNAME`
echo $jobid | grep '^f[0-9][0-9]n[0-9][0-9]io' > /dev/null 2>&1
if [ "$?" -eq "1" ]; then
  echo "The job id does not have valid name: $jobid"
  echo "Make sure that your job is called the same in the header as the variable jobname"
  exit 1
fi
masternode=`/home/ntnu/forecast/bin/master_node.sh $jobid`
echo
echo "**************************************************** NB! *******************************************************************"
echo "To check if your job is killed because of memory exceeding the amount available, try the following command if the run aborts"
echo "/home/ntnu/forecast/bin/epilog.sh $jobid $masternode"
echo
/home/ntnu/forecast/bin/epilog.sh $jobid $masternode
echo

#
# Go to the experiment
# This is where you created your experiment. 
# It is safest to start from here. 
# If EXP is not exported the experiment name will be taken from directory you are in when typing Harmonie start

cd $HOME/hm_home/$EXP || exit

############################# Check if this is a continuation run and set DTG ##################################

#If warm start get DTG from progress.log
if [ -f progress.log ]; then
  # Source DTG and DTGBEG from progress.log
  source progress.log

  # Test validity
  if [ "$DTGBEG" -ne "$DTGBEG_USER" ]; then
    echo "ERROR: Mismatch in DTGBEG in progress.log and the job script"
    exit 1
  fi
  if [ -f progressPP.log ]; then
    source progressPP.log
    if [ "$DTGPP" -ne "$DTG" ]; then
      echo "ERROR: Mismatch in DTG from progress.log and DTGPP in progresPP.log. Probably the model has previously failed in post-processing."
      echo "Correct the DTG and DTGPP before re-submitting!"
      exit 1
    fi 
  else
    echo "ERROR: Can not do a warmstart if progressPP.log is missing!"
    exit 1
  fi

  # print out result
  if [ "$DTG" -ne "$DTGBEG" ]; then
    echo "Warm-start for $DTG because DTG is not equal DTGBEG"
  else
    echo "Cold-start for $DTG because DTG is equal DTGBEG"
  fi
else
  DTGBEG=$DTGBEG_USER
  DTG=$DTGBEG_USER
  echo "This is a cold-start"
fi

################################### Start Harmonie for each cycle ######################################

# First export some variables for the model
export EXP BUILD EXT_TEST_BDDIR CREATE_CLIMATE
export mSMS_WAIT=yes    # Make the Harmonie start command wait in this script until it finishes, aborts or mSMS dies
export mSMS_WEBPORT=2   # Make you able to connect with Harmonie mon when experiments start
export mXCdp=DISABLE    # This will also be done automatically as no display variable is known when the job is sent to loadleveller. Instead re-connect with Harmonie mon

# Loop over the cycles we want to run
while [ "$DTG" -le "$DTGEND" ]; do
  echo "============ $DTG start ================"
 
  # Prepare observations for this day 
  #
  # Copy all the observations
  obsdir="/home/ntnu/forecast/TESTDATA/ParRuns09-metnoObs"
  # Create directories if not existing
  [ -d /work/$USER/HM_mSMS ] || mkdir /work/$USER/HM_mSMS
  [ -d /work/$USER/HM_mSMS/$EXP ] || mkdir /work/$USER/HM_mSMS/$EXP
  [ -d /work/$USER/HM_mSMS/$EXP/observations ] || mkdir /work/$USER/HM_mSMS/$EXP/observations
  echo "Copying observations found for this day. DTG is $DTG"
  ymd_dtg=`echo $DTG | cut -c1-8`
  # list files for this day. Files are called convHH.bufr_YYYYMMDD for ParRuns09-metnoObs 
  for f in `ls -1 $obsdir/conv*_$ymd_dtg`; do
    ymd=`echo $f | cut -c61-70`
    hh=`echo $f | cut -c53-54`
    obdtg=${ymd}${hh}
    checkDTG $obdtg
    ob="/work/$USER/HM_mSMS/$EXP/observations/ob${obdtg}"
    if [ ! -f $ob ]; then
      echo "Copying $f to $ob"
      cp $f $ob
    else
      echo "$ob already exists"
    fi
  done

  # Start depending of cold or warm start
  if [ "$DTG" -ne "$DTGBEG" ]; then
    # Warm start
    /home/ntnu/forecast/HL_release/harmonie-36h1.1/config-sh/Harmonie prod DTGEND=$DTG LLMAIN=$LLMAIN
    # You will need full path to Harmonie here, or alternatively use /home/ntnu/forecast/bin//Harmonie which should point to the newest release
  else
    # Cold start
    /home/ntnu/forecast/HL_release/harmonie-36h1.1/config-sh/Harmonie start DTG=$DTG LLMAIN=$LLMAIN
    # You will need full path to Harmonie here, or alternatively use /home/ntnu/forecast/bin//Harmonie which should point to the newest release
  fi

  # Check exit status of the run
  if [ "`tail -1 /work/$USER/HM_mSMS/$EXP/harmonie.log`" != "COMPLETE" ]; then
    echo "The job was not complete!!! Exiting job... Check /work/$USER/HM_mSMS/$EXP/harmonie.log"
    exit 1
  fi  

  # Clean up archived old cycles or we might run out of disk space. Save the first cycle because of statistics
  KEEP_DTG_END=`/home/ntnu/forecast/bin/mandtg $DTG + -$KEEPHOUR`
  checkDTG $KEEP_DTG_END
  KEEP_DTG=`/home/ntnu/forecast/bin/mandtg $DTGBEG + 6`
  checkDTG $KEEP_DTG
  echo "KEEP_DTG_END for KEEPHOUR $KEEPHOUR is: $KEEP_DTG_END"
  [ "$KEEP_DTG" -ge "$KEEP_DTG_END" ] && echo "No check for old archived directories done"
  while [ "$KEEP_DTG" -lt "$KEEP_DTG_END" ]; do
    checkDTG $KEEP_DTG      # Produces yy mm dd hh
    # Delete old archives to save disk space 
    if [ -d /work/$USER/HM_mSMS/$EXP/archive/${yy}${mm}${dd}${hh} ]; then
      echo "Deleting /work/$USER/HM_mSMS/$EXP/archive/${yy}${mm}${dd}${hh}"
      rm -r /work/$USER/HM_mSMS/$EXP/archive/${yy}${mm}${dd}${hh} 
    fi
    KEEP_DTG=`/home/ntnu/forecast/bin/mandtg $KEEP_DTG + 6` 
  done 

  # Disable building for the next DTG's to save some time
  BUILD=no

  echo "============ $DTG end ================="
 
  # Get the DTG for the next cycle and check if it is valid
  DTG=`/home/ntnu/forecast/bin/mandtg $DTG + 6`
  checkDTG $DTG
done
echo "Script has finished because DTG $DTG > $DTGEND"
```

Save this as the file $HOME/hm_home/HM04_oper.job and make it executable and submit the job to loadleveller in the following way:

```bash
#!sh
   cd $HOME/hm_home/HM04_oper
   chmod u+x HM04_oper.job
   llsubmit HM04_oper.job
```

This will run long forecasts at 00 UTC and short (6h) at 06/12/18 you specify the longer forecast length as LLMAIN. If you would like all forecast to be long (e.g. 36 hours), set LL=36 instead of LLMAIN. Default behaviour (without our change in scr/submission.db) is that LLMAIN is used for 00 and 12 UTC. Operationally we run with forecast length 60 hours for 00/12 UTC, but we specify the forecast length (LL) each time. 

 Monitor the queue until your job starts:
```bash
#!sh
   llq -xu $USER
```

If successful, mSMS will identify your experiment name, launch mXcdp and start build and run. If not, you need to examine the mSMS log file /work/$USER/HM_mSMS/HM04_oper/mSMS.log. $HM_DATA is defined in your Env_system file and is for this experiment /work/$USER/HM_mSMS/HM04_oper/.

 4. Restart of mXcdp

The graphical window, mXcdp runs independently of the mSMS job and can be closed and restarted again. Since we started our experiment in a loadleveller job, we will anyway need to re-connect to mXcdp manually by

```bash
#!sh
   cd $HOME/hm_home/HM04_oper
   Harmonie mon
```


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[Back to the njord page](./Harmonie-local-njord.md)
