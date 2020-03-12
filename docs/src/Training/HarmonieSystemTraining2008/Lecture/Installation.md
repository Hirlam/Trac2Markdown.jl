```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Lecture/Installation?action=edit"
```

# HARMONIE System Installation

## Rootpack Installation

Gmkpack is the ALADIN utility to compile ARPEGE/IFS

 - Handle dependencies (includes/modules)
 - Handle exceptions
 - Compile the code
 - Build the binaries

A mainpack installs and builds a complete HARMONIE source (ALADIN/HIRALD/ALARO/AROME models). Generate a set of pre-compiled libraries (rootpack) and modules available for USE. 
Each single user buils their own  öocal "target" pack, which synchronise local source modifications with the reference libraries.  

[gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=gmkpack)

[gmkpack vs make] (../../../Gmkpack_vs_Make.md)


gmkpack is intended to be installed and maintained separately. In HARMONIE it is a part of the system and used in Build_gmkpack, Build_rootpack and Build_pack

Available main packs on HPCE, /ms_perm/hirlam/harmonie/pack:

32h2_main.01.XLF91.x/32h3_main.01.XLF91.x/33h0_main.01.XLF91.x/33h1_main.01.XLF91.x/33h1_main.03.XLF91.x/34h0_trunk.01.XLF91.x/35h0_trunk.01.XLF91.x/
ie. CYCLE_BRANCH.VERIONS.COMPILER_VERSION.OPTION

ecgate/hpce:/home/ms/dk/nhz/harmonie_release : 32h3,33h0,33h1,trunk

 * [Supported platforms and compilers](https://hirlam.org/trac/browser/trunk/harmonie/util/gmkpack/arch)
    - IBM power X
    - Intel (g95, gfortran, intel)
    - NEC
    - Fujitsu
    - AMD?


## Configure your system

To start the build create an experiment directory $HOME/hm_home/trunk and run

```bash
   PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST
```

Note the options "-r" and "-h" here are defined differently from those in the script Hirlam for synoptic-scale Hirlam system.

The above command creates the following files/directories under
```bash
   config-sh/hm_rev                         # gives the path to the reference installation, similar to hl_rev in synoptic-Hirlam
   config-sh/Main                           # a script to enable start Harmonie, similar to Start in synoptic-Hirlam
   Env_system -> config-sh/config.YOURHOST  # describing your system, similar to Env_system in synoptic-Hirlam
   Env_submit -> config-sh/submit.YOURHOST  # describing your submit commands, comparable to submission.db in synoptic-Hirlam
   sms/config_exp.h                         # defines your experiment, comparable to Env_expdesc in synoptic-Hirlam
```


In sms/config_exp.h you may identify the options sent to gmkpack

```bash
# ROOTPACK definitions, should fit with hm_rev
BUILD_ROOTPACK=yes                      # Only active for the Install_rootpack playfile, (yes|no)
BUILD=yes                               # Turn on or off the compilation and binary build (yes|no)
REVISION=35h0                           # Revision ( or cycle ) number, has to be set even for the trunk!
BRANCH=trunk                            # Rootpack branch (usually trunk|main)
VERSION=01                              # Version of revision/branch to use
OPTION=x                                # Which gmkpack/arch/SYSTEM.HOST.OPTION file to use

PROGRAM=aromodb                         # Main MODEL Program to compile gmkpack
OTHER_PROGRAMS="pinuts blend odbtools bator ioassign mandalay" # Other things to compile with gmkpack
```

You could run something different than defined in hm_rev, but then there would be a mismatch between your source code and the pre-compiled libraries/modules.


Identify your system in one of the config files in config-sh or write a new config.YOURHOST definition, make sure that some of the important optional settings are defined in this file:
```bash
 COMPCENTRE       # should be something else than ECMWF for non-HPCE platform
 HM_DATA          # where you run your experiments and keep your "local" binaries
 ROOTPACK         # where you refer/put your rootpack installations
 HARMONIE_CONFIG  # identifies your configuration
 AUXLIBS/EMOSLIB  # Path to your external libraries
```

Compare e.g. with [config.ecgate](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/config.ecgate) or [config.dunder](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/config.dunder).

You also have to identify your system for gmkpack in:

```bash
        util/gmkpack/arch/YOURMACHINE.HARMONIE_CONFIG
```


The source code for utilities not compiled with gmkpack you find under util. There should be three config files created/edited.

```bash
        util/gl/config/config.HARMONIE_CONFIG
        util/monitor/config/config.HARMONIE_CONFIG
        util/oulan/config.HARMONIE_CONFIG
```

The makefiles themselves should not have to be edited.


## Submission rules

Next you have to identify your submit file in config-sh or write a new submit.YOURHOST file. This file defines how you submit your jobs in your local batch system. 
The routine get_job is called from [submission.db](https://hirlam.org/trac/browser/trunk/harmonie/scr/submission.db) and should return the appropriate batch header including some environment variables specifying the parallel decomposition. The way the header is constructed could be different on different hosts as long as the appropriate header is returned.

On [ecgate](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/submit.ecgate) three list of jobs are created:
 * backg_list for jobs running as background jobs on ecgate
 * scalar_list single PE jobs on HPCE
 * par_list for parallel jobs on HPCE.

The scalar_list is the default one, meaning that any unspecified job will be run as a single PE job on HPCE. Default values are defined for each list. Special settings for special jobs can be set like:

```bash
 $job_list{'Prep_ini_surfex'}{'RESOURCES'} = $submit_type.'resources = ConsumableCPUs(1) ConsumableMemory(6000 MB)' ;
```



## Running the installation

Start the compilation of the rootpack :
```bash
      PATH_TO_HARMONIE/config-sh/Harmonie install
```

The suite definition file used for the installation is 
[Install_rootpack.tdf](https://hirlam.org/trac/browser/trunk/harmonie/msms/Install_rootpack.tdf). The installation is just like running an experiment.

Where are things happening

- Build_gmkpack 
- Build_rootpack
 - rsync the sources from HM_REV, HM_CMODS, HM_LIB
 - cleanpack
 - compiles the ODB compiler
 - compiles IFS
 - locks the pack

- Build_pack
 - build everything in the OTHER_PROGRAMS list. This is done inside HM_DATA/gmkpack_build
 - build the utilities (gl/verobs/oulan)

When things goes wrong

 - ics_* can be run stand alone from the ROOTPACK. 
   - Turn off the compilation and linking
   - build the libraries by running the ics_* file by hand
   - BUILD_ROOTPACK=no, put the corrections to the failing code in your experiment
   - rerun Harmonie install


**The main task for the installation is to compile the rootpack. The binaries and libraries compiled are never used by any other experiment.**

## [Experiment Configuration] (../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts#smsconfig_exp.h.md)

## [Where to find things] (../../../HarmonieSystemDocumentation/Harmonie-mSMS#Filestructure.md)

## [Hands on practice task] (../../../HarmonieSystemTraining2008/Training/Installation.md)

## *Questions & issues related to the current topics* 
 * "The Harmonie script hard-codes the directory structure in form of $HOME/hm_home/EXP and directory structures such as $SCRATCH appear in different places. This is also reflected in Main script where the experiment name EXP is to be determined. Can the assumed directory structure be made more flexible?"

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)