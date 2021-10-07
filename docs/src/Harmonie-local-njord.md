```@meta
EditURL="https://hirlam.org/trac//wiki//Harmonie-local-njord?action=edit"
```

## met.no Harmonie setup
# Running Harmonie on njord

## Introduction

This page was originally setup as a tutorial for co-workers at met.no, who were new to the system. It is meant as a tutorial in how to use the Harmonie script system and a more detailed description of the differences from the reference script system at ECMWF when running Harmonie on our local platform.

In theory, everything that you have to do to make an experiment is inside your experiment directory to run "Harmonie setup" and "Harmonie start". Sounds easy, doesn't it? In practice you will need a couple of options for those commands and the extra thing on njord is that you also will need to run "Harmonie start" from a loadleveller job.

## Special remarks for njord
Contrary to ECMWF, njord is a single host setup. That means that the local experiment setup and the results ($HM_DATA) are found on the same computer. The experiments should in /home/ntnu/$USER/hm_home/my_exp and the results are default in /work/$USER/HM_mSMS/my_exp.

Both njord and c1[a,b] are IBM with AIX as the operating system. Njord is an IBM Power 5 with about 155 nodes available for met.no originally with 32GB memory available on each node. Njord is a shared computer for whole Norway and for met.no to be able to have operational runs, a suspend-resume system setup is used such that the forecast queue can suspend all other jobs when submitted. The draw-back is that this implementation on njord makes only half of the memory on each node available to all the users, as the other half is needed to preserve the suspended jobs. In addition system processes need memory so a total of 13.125 GB is available for every user (including forecast).   

The queuing setup on njord is structured different form ECMWF and previously the machine was much used and jobs needed to wait long to become active. To reduce this burden the default setup for normal users on njord is to submit the mini-SMS scheduled as a loadleveller jobs and run as much as possible as background processes on the nodes allocated by the master job. However, some tasks are at the moment not well adapted to run as a background process when the master job is started with MPI and several nodes allocated. A sample script for job submissions could be like this running on 4 nodes (a total of 64 CPU's) for a job called HM04_oper:

```bash

#!/bin/bash
#@ account_no = mip000
#@ shell = /usr/bin/sh
#@ job_type = parallel
#@ output   = HM04_oper.log
#@ error    = HM04_oper.log
#@ job_name = HM04_oper
#@ class = large
#@ node = 4
#@ tasks_per_node = 16
#@ network.MPI = sn_all,,us
#@ environment = OMP_NUM_THREADS = 1
#@ resources = ConsumableCpus(1) ConsumableMemory(830mb)
#@ wall_clock_limit = 200:00:00
#@ cpu_limit = 200:00:00
#@ notification = never
#@ queue
#

export EXP=HM04_oper    # Your experiment name. When exported this is also "visible" for "Harmonie start"
export mSMS_WAIT=yes    # Make the Harmonie start command wait in this script until it finishes, aborts or mSMS dies
export mSMS_WEBPORT=2   # Make you able to connect with Harmonie mon when experiments start
export mXCdp=DISABLE    # This will also be done automatically as no display variable is known when the job is sent to loadleveller. Instead re-connect with Harmonie mon

cd $HOME/hm_home/$EXP || exit   # This is where you created your experiment. It is safest to start from here, If EXP is not exported the experiment name will be taken from directory you are in
/home/ntnu/forecast/bin//Harmonie start DTG=2007120200 DTGEND=2007123112 LLMAIN=36
# /home/ntnu/forecast/bin//Harmonie should be a sym-link to latest Harmonie release installed. Maybe you should make an alias for it in $HOME/.bashrc?

```
The account should be set to an account that you have access to. mip000 is the account for operational testing.

This method of submitting "Harmonie start" in a loadleveler job, sometimes creates strange problems that normally needs to be fixed in the master job or the setup for njord submissions in [Env_submit](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/submit.njord). More on this in the next section. HARMONIE's jobflow is determined by the [mini-SMS scheduler](./Harmonie-mSMS.md), in which the triggering is taylor-made for the ECMWF setup where all jobs are submitted as seperate loadleveler jobs. When running most of the jobs on a specific number of nodes as bakground processes on the same nodes, this causes a very variable memory consumption. It can occur that the job is killed because it is exceeding the available memory. One way we can control the work-flow in mini-SMS better is to start each cycle from the loadleveler job script instead of using Harmonis built-in DTGEND functionality. The examples here will use this philosophy.  


[Introduction from NTNU on how to use njord](http://docs.notur.no/ntnu/njord-ibm-power-5/introduction-to-using-njord)

## The heart of the model
Contrary to how ALADIN is run, HARMONIE comes shipped with a reference script system. More information on these scripts can be found in [wiki:HarmonieSystemDocumentation/Scripts].

Basically, the following three files defines the behaviour of the model:

 * [sms/config_exp.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/config_exp.h): The place to set script variables to decide what you wil run   

 * [Env_system](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/config.njord): The general system variable for our platform njord

 * [Env_submit](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/submit.njord): The file defining how the different tasks in mini-SMS will be submitted

In Env_submit there are generally three ways of submitting a job:

 * As a job recommending several cpu's and mpi called parallell

 * As a job recommending only one cpu called scalar

 * As a process on the machine mini-SMS in running called background

The first two methods imply that we need to send the job with loadleveller to the queue-system and on c1a scalar is the default method. This is trivial for the forecast user, but a non-prioritized user will have to wait until free capacity. Therefore, is an extra way called scalar_background set up as deault for non-forecast (or metnotst) users, which combines the methods 2 and 3. This way, the jobs will run in the background on the nodes you allocated in the job script, but at the same time have some script settings it gets from scalar. Unfortunately some jobs (like climate file generation, bator and canari) are not able to run as a backround process in an environment with many mpi tasks and CPU's available, and will need to be submitted as a pure scalar job. Depending on the queue capacity this could slow down the progress.

If you are running an experiment with data assimilation an important configuration file is also:
  
 * [include.ass](https://hirlam.org/trac/browser/trunk/harmonie/scr/include.ass): The file defining which observations to use etc

## Build HARMONIE from the HARMONIE repository

There are two ways of building HARMONIE, gmkpack or makeup, but in either way you should probably use a pre-compiled binary compiled by the forecast user to save time. The compilation of the full code is massive but if you still would like to compile the full code, please read the instructions below, and take a look at the basic install [instructions](./Installation.md).

 * gmkpack
The original meteo-france developed building system. Set MAKEUP=no in Env_system to use gmkpack. It is not recommended to build a rootpack as a normal user (and should also not be necessary), but if you do you should make sure to re-define the ROOTPACK variables in Env_system as they default on njord points to ~forecast/HARMONIE/rootpack. The operational experiment for this tutorial is built with gmkpack and the rootpack for cycle 36h1.1.

 * makeup
Makeup is going to be the new build system. It is written by Sami Saarinen and uses a normal gmake functionality. Set MAKEUP=yes in Env_system if you would like to use makeup. If you compile with makeup you should make sure that BUILD_ROOTPACK=no as this would generate a pre-compiled binary and this is only applicable for Harmonie system administrator with forecast rights. If you would like to use a pre-compiled binary set PRECOMPILED in Env_system to point to the pre-compiled binary. If PRECOMPILED is not set or is not pointing to a defined pre-compiled binary you will get a full build of your code. From cycle 36h1.3 makeup is default build system, and to use this release you should set the precompiled to point to PRECOMPILED=/home/ntnu/forecast/HARMONIE/precompiled/36h1.3/

These are anyway the the default settings for njord when you setup HARMONIE with cy36h1.3.

### Visualization of results

More info on how to process the grib files created from the task Makegrib (gl -p) on our local wiki https://dokit.met.no/fou/nm/harmonie/harmonie_visualisering in Diana and https://dokit.met.no/fou/nm/harmonie/harmonie_visualisering_r in R.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Examples

 * [Setting up an experiment similar to the operational HM04 with cy36h1.1 and gmkpack](./Harmonie-local-njord-exp1.md)
 * [HM04_oper_make with cy36h1.3 and makeup](./Harmonie-local-njord-exp2.md)
 * [HM04_oper_make_ec with cy36h1.3 and makeup on ECMWF](./Harmonie-local-njord-exp3.md)

A remark on njord is that if you have mXCDP connected after the job has started the mini-SMS scheduler does not die immidiatly and the nodes can be active without doing anything if the run chrashes. Thus make sure to close the mXCDP window when leaving the experiment for long periods!

## Rerun of an example
If the experiment chrash (often it does:-)), then do the following for an experiment assumed to be called HM04_oper on njord
```bash
cd ~/hm_home/HM04_oper
Harmonie mon
# You should get a box that mini-SMS is not running. Close the mXCP window. 
# If mini-SMS is running you have either started it your self manually (which you shouldn't:-)) or it was never aborted

# If this file exist, delete it. When mini-SMS is killed because of memory usage, it often dies too fast so that it is never registered by the mini-SMS process.
rm /work/$USER/HM_mSMS/HM04_oper/mSMS.pid

# Make sure that the DTG here: 
more progress.log
# and DTGPP here:
more progressPP.log
# matches. Open the files with a text editor and set them to the correct DTG. 
# The DTG in progress.log is the DTG for the cycle that you want HARMONIE to start on when you type Harmonie prod 

```

If you would like to start the experiment from the beginning (DTGEB_USER) when using the provided job scripts you have two options. 
  
  1. Either delete progress files so that cold-start is assumed
```bash
rm ~/hm_home/HM04_oper/progress.log
rm ~/hm_home/HM04_oper/progressPP.log
```
  2. or make sure the DTG in ~/hm_home/HM04_oper/progress.log and DTGPP in ~/hm_home/HM04_oper/progressPP.log are the same as DTGBEG_USER

If you would like to clean up everyting, the reccomended method is:
```bash
cd ~/hm_home/HM04_oper
Harmonie CleanUp -ALL -go
```


## Directory structure of your experiments on njord

You can follow the progress of the runs under $HM_DATA. The examples here are for the experiment HM04_oper. For a normal user this would be under /work/$USER/HM_mSMS/HM04_oper. Operational runs running under forecast will be under e.g. /home/ntnu/forecast/HM_mSMS/HM04. Under $HM_DATA you will find:

   * Results post-processed by gl and message files will be in /work/$USER/runHM04_oper (Other files in the archive. The example script cleans the archive during the runs)
   * Extracts for verification in archive/extracts
   * All binaries under **bin**
   * Libraries, object files and source code under **gmkpack_build**
   * Scripts, config files, sms and msms definitions under **lib/**
   * Utilities such as gmkpack, gl and verification under **lib/util**
   * Climate files under **climate**
   * Archived files under **archive**
       * A **YYYYMMDDHH** structure for per cycle data
       * verification input data under **extract**
   * Working directory for the current cycle under **YYYYMMDD_HH**
   * Verification working directory on **$HM_DATA/archive/extract/WebgraF**
       * The tar file with verification if done is found in $HM_DATA/lib/util/monitor/scr/HM04_oper_export.tar
       * De-tar this file and look on the index.html with firefox to see the verification plots
   * Log files per task can be found under $HM_DATA/my_exp. If an experiment fails it is usefull to check the IFS log file, NODE.001_01, in the working directory of the current cycle ( $HM_DATA/YYYYMMDD_HH ). The failed job will be in a directory called something like Failed_this_job. All logfiles are also gathered in html files named like e.g. HM_data_YYYYMMDDHH.html.

## When things go wrong
There are several log files that might be interesting.

 1. On njord you should check if your loadleveller job is running in the queue (llq -xu $USER) and the output of the logfile of this job (What you named it in the job header (#@ output and #@ error ).
 2. Check $HM_DATA/mSMS.log to see if mini-sms reported errors

 2.1 If you see error check also $HM_DATA/harmonie.def to see the results of the parsing of harmonie.tdf
 3. Check $HM_DATA/harmonie.log to see if or which tasks that were aborted
 4. Check the log file of the aborted task in $HM_DATA/$EXP/the_path_that_is_listed_in_harmonie.log_that_was_aborted

Solve the error and continue:-)

The graphical mXCDP interface has several possibilites to re-run single tasks or whole families. A full re-run is not always necessary!

Now you are almost a system expert!
Good luck future system expert!!!


