```@meta
EditURL="https://hirlam.org/trac//wiki//Structurefunctions?action=edit"
```


# Derivation of Structure Functions 


**This is the old deprecated method for generating structure functions. For the supported method read on [here](./Structurefunctions_ensys.md).**


## General
For each new model domain, in order to carry out upper air data assimilation (3DVAR or 4DVAR) one needs to generate background error covariances (generally referred to as structure functions). Within the HARMONIE community the derivation has been based on data generated with ensemble HARMONIE forecasts which downscale from ECMWF EPS runs.
Two kinds of ECMWF ensemble forecast data have so far been tried. With BDSTRATEGY=jb_ensemble as specified in ecf/config_exp.h , the HARMONIE ensemble forecast can be launched for the period of 20060920 to 20061031. Using the ECMWF LBC data, 6h HARMONIE ensemble forecasts are initiated from ECMWF 6h forecasts daily from 00 UTC, with ECMWF forecasts as initial and lateral boundary conditions. To obtain stable statistics, it seems appropriate to run 4 ensembles for each day of the episode. Alternatively, one can choose to use BDSTRATEGY=enda to use operational ECMWF EPS forecasts as initial and boundary conditions in the downscale ensemble runs. The 'enda' data from ECMWF are available for the recent few years, it may be more suitable to use if one is interested to derive structure function that reflect model characteristics of different seasons.
After generation of HARMONIE ensemble forecast at downscaling mode, the archived results (6h forecasts) can be processed to generate structure functions by method described below.

Note that in the HIRLAM VAR implementation it has been possible technically to run 3/4DVAR using structure functions derived from other HIRLAM runs on different domain. This is not entirely the case in the current HARMONIE data assimilation unless ones model domain is embedded in the original domain from which structure function has been derived, and with same vertical coordinate Thus the derivation of structure function is usually the first step to go before any VAR experiment can be done. There is a program developed for converting structure functions from one area to another but it is recommended to be used for technical tests only. The procedure below has been tested on HARMONIE cy36h1.4, from which version it is applicable. For earlier versions the [ old procedure for generating structure functions](./36h1.4/Structurefunctionsold.md) should be used, which is slightly different. The example procedure for generating structure functions from an ensemble of forecasts is described below for a AROME setup with 2.5 km horizontal resolution,  65 vertical levels and located over FINLAND. The actual generation of structure functions take place in the 'Produce ensemble of forecasts' and 'Generate forecast difference files' and 'Calculation of background error statistics files' sections described below. The other sections deals with how to diagnose the structure functions and how to interface the newly generated structure functions into the data assimilation. There is also a tool for interpolating background error statistics from one domain to another. This procedure is described in the section 'Interpolation of background error statistics between different domains for technical data assimilation tests' and it is only itended for technical assimilation tests. Finally something about recent and ongoing work and future development plans.  
  
## Example on ecgb/cca, for area FINLAND
### Produce ensemble of forecasts
  1. Prepare experiments for running the 4 downscaled HARMONIE 6h ensemble forecasts at 00 UTC. Create 36h14e1 to 36h14e4 directories as described below for 36h14e1. 36h14e2 to 36h14e4 procedure is exactly the same, except for that you do include 'export ENS_MEMBER=2' etc, instead of 'export ENS_MEMBER=1' at the bottom of config_exp.h.
     1. On ecgb $HOME directory create hm_home/36h14e1 directory. Then cd $HOME/hm_home/36h14e1.
     1. create experiment by typing '~hlam/Harmonie setup' (or '~hlam/Harmonie setup -r /home/ms/spsehlam/hlam/harmonie_release/tags/harmonie-36h1.4').
     1. edit ecf/config_exp.h  as follows
       * set DOMAIN=FINLAND, 
       * set FCINT=24,
       * set BDSTRATEGY=jb_ensemble
         * if you choose newer period than 20060920-20061031, select BDSTRATEGY=enda
       * set OUTINT=6,  
       * set ANAATMO=none
       * set ANASURF=none
       * I have also set ECFSLOC=ec, instead of default ectmp, but that is not crucial. In case of ECFSLOC=ec the forecasts will be archived at ec:/$uid/harmonie/$EXP/$YYYY/$MM/$DD/$HH.
       * include the following line at the bottom of config_exp.h: export ENS_MEMBER=1 **(note: this variable was previously called JB_ENS_MEMBER. Remember to set this right when using versions 36h1.4.bf1 and later!!!)**
      1. If you are using HARMONIE cy36h1.4 or later you need to copy some source code files resulting in an updated executable 'domain_prop', needed at a later stage. This by achieved by placed in $HOME/hm_home/36h14e1 typing 'ecp ec:/smx/Jb_wiki_ml/util.tar .', followed by tar -xvf util.tar'. This will results in three updated source code files in subdirectories of directory 'util'. 
     1. From $HOME/hm_home/36h14e1 to $HOME/hm_home/36h14e4 on ecgb, launch the experiments by typing
```bash
   ~hlam/Harmonie start DTG=2006092000 DTGEND=2006103100 LLMAIN=06
```
### Generate forecast difference files
  1. Generate executable for calculating differences between forecasts stored in FA files  
         1. On ecgb, copy your experiment $HOME/hm_home/36h14e1 to $HOME/hm_home/36h14_df (using cp -r).
         1. In $HOME/hm_home/36h14_df, remove the file 'experiment_is_locked'
         1. Now you need to copy some source code files needed for creating executable for making forecast differences. In case of AROME this is achieved by placed in $HOME/hm_home/36h14_df type 'ecp ec:/smx/Jb_wiki_ml/src_arome.tar .', followed by 'tar -xvf src_arome.tar'.  In case of ALARO or ALADIN this is achieved by placed in $HOME/hm_home/36h14_df type 'ecp ec:/smx/Jb_wiki_ml/src_aldalr.tar' ., followed by 'tar -xvf src_aldalr.tar'. This will results in three updated source code files in subdirectories of directory 'src'. 
         1. Launch an experiment in $HOME/hm_home/ 36h14_df by '~hlam/Harmonie start DTG=2006092000'. 
         1. When the build (compilation) step is finished you can stop mini-SMS.  You will on c1a find $TEMP/hm_home/36h14_df/bin/MASTERODB. That will be needed in the next step. 
  1. Produce difference files from 6 h forecasts (for forecasts valid at the same time) in a format suitable for background error statistics program
       1. Log in to c1a (rlogin c1a). 
       1. Go to $TEMP, followed by 'ecp  ec:/smx/Jb_wiki_ml/Jb_dir.tar ., followed by tar -xvf Jb_dir.tar'. You will get a number of subdirectories under your 'Jb_dir'
       1. In scripts (cd scripts) you find the script 'makediff'. Take a look at it and modify $uid 'smx' to your own uid and set paths to find your data and executables (MASTERODB should be taken from the directory $TEMP/hm_home/36h14_df/bin/MASTERODB and forecast files from your ensemble experiments, as stored on ecfs). Modify start and end dates to match the ones of your experiment.
       1. In case of running AROME make sure makediff is using $TEMP/Jb_dir/nam/difarm.36h14.nml. In the case of running ALADIN or ALARO  modify makediff to use $TEMP/Jb_dir/nam/difaldalr.36h14.nml). Add LFEMARSD=.true.in the namelist under the NAMVAR section.  
       1.  When finished with the editing, launch makediff (positioned in scripts directory) with 'llsubmit ./makediff'. 
       1. check if you are running by typing llq -u $uid'. Out directory will be on $TEMP/Jb_dir. Note three sub-directories 'Diff2 Stat Work'. 'Work' is where the calculations take place and 'Diff2' where the output difference files appear in a format suitable for coming structure function calculation (names like nmcstat2006092000_1_2_gribdiff). 

### Calculation of background error statistics files
   1. On c1a $TEMP/Jb_dir/scripts you find 'linkdiff' script. Take a look at it. It creates symbolic links between the difference files  '$TEMP/Jb_dir/Diff/nmcstat2006092000_1_2_gribdiff' etc and  '$TEMP/Jb_dir/Stat/ensdiff1' (2 for the next file and so forth), needed for the next step. Modify paths and dates and run by typing (placed in $TEMP/Jb_wiki/scripts) ./linkdiff (the outcome will be the links in '$TEMP/Jb_dir/Stat'.
   1. Time to compile festat program. Go to $TEMP/Jb_dir/src_festat (cd $TEMP/Jb_dir/src_festat) and type 'make'. You will soon notice an executable 'festat.x'. Now go to  $TEMP/Jb_dir/scripts (cd $TEMP/Jb_dir/scripts). There edit script 'runfestat'. Here you will find roughly 25 different namelist parameters to set, related to dates and number of cases you have, as well as model geometry for your domain and vertical levels. Edit these parameters. The meaning of the parameters are described in $TEMP/Jb_dir/scripts/README.festat. All information for the namelist settings can be found by fetching the executable domain_prop from $TEMP/hm_home/36h14_df/bin ('cp -r $TEMP/hm_home/36h14_df/bin/domain_prop .'). Then fetch a forecast file in FA format from your experiment, in this case for example ec:/smx/harmonie/36h14e1/2006/09/20/00/ICMSHHARM+0006 by typing 'ecp ec:/smx/harmonie/36h14e1/2006/09/20/00/ICMSHHARM+0006 .'.for example ec:/smx/harmonie/smx/36h14e1/YYY/MM/DD/HH/  Then the geometrical information you need will be written to the screen if you type './domain_prop -f ICMSHHARM+0006 -4JB'. 
   1. Now  it is time for running on c1a by utilizing the script 'runfestat' in $TEMP/Jb_dir/scripts. Modify paths (/ms_perm/alas to $TEMP and smx to your uid), make sure 'runfestat' is using your newly compiled festat.x, and run by (placed in script directory) typing 'llsubmit ./runfestat'. The structure function program $TEMP/src_festat/festat.x will run at $TEMP/Jb_dir/Stat and the structure function output will be three files starting with 'stabfiltn'. There will also be a lot of diagnostics files with names starting on 'cov' and 'cor' as well as a log file (these files are worth saving). The two files 'stabfiltn*.cv' and 'stabfiltn*.bal' will be needed by the assimilation later on. gzip them and copy to ecfs (emkdir ec:/$uid/jbdata followed by: 'ecp stabfiltn*.cv.gz ec:/$uid/jbdata.' and 'stabfiltn*.bal.gz ec:/$uid/jbdata/.'). From these two files also diagnostical information about the background error statistics will be derived. In this example the name of the generated files were stabfiltn_FINLAND_20060920_168.bal and stabfiltn_FINLAND_20060920_168.cv. These were renamed (with mv) as stabfiltn_FINEXP_168.bal and stabfiltn_FINEXP_168.cv and thereafter gziped and transfered to  ec:/smx/jbdata/ (placed in $TEMP/jb_dir/Stat 'gzip stabfiltn_FINEXP_168.bal', followed by 'ecp stabfiltn_FINEXP_168.bal.gz ec:/smx/jbdata/.' and similar for stabfiltn_FINEXP_168.cv).

### Diagnosis of background error statistics
   1. Diagnosis of background error statistics is a rather complicated task. To get an idea of what the correlations and covariances should look like take a look in the article: Berre, L., 2000: Estimation of synoptic and meso scale forecast error covariances in a limited area model. Mon. Wea. Rev., 128, 644-667. A software for investigating and graphically illustrate different aspects of the background error statistics has been developed and statistics generated for different domains has been investigated (see attached report below by Nils Gustafsson). With this software you can also compare your newly generated background error statistics with the one generated for other HARMONIE domains. This will give you and idea if your statistics seems reasonable. For diagnosing the newly derived background error statistics follow these instructions:
       1. Go to $SCRATCH on ecgb
       1. ecp ec:/smx/Jb_wiki_ml/jbdiagconv.tar .
       1. tar -xvf jbdiagconv.tar will give directory $SCRATCH/jbdiagconv
       1. Go to $SCRATCH/jbdiagconv where you find subdirectories data (containing background error statistics for different domains and directories containing output-statistics for different domains (for example 'diagDKarome' and  'diagFIarome'). You will also find two .f90 files and three scripts for diagnostics.
       1.Placed in $SCRATCH/jbdiagconv compile jbdiagnose.f90 and jbconv.f90 by typing './Complile'. That will generate jbdiagnose.x and  jbconv.x. Thereafter fetch your background error statistics files from  ec:/$uid/jbdata and gunzip then and place them in $SCRATCH/jbdiagconv/data (in this example statabfiltn_FINEXP_168.cv and stabfiltn_FINEXP_168.bal). Create a directory ${SCRATCH}/jbdiaconv/diagEXP for output (mkdir ${SCRATCH}/jbdiagconv/diagEXP). Then edit 'jbdiagnose.ksh' to read your data and adjust namelist to your domain settings (horizontal resolution and vertical levels). Finally generate statistics by place in ${SCRATCH}/jbdiagconv typing './jbdiagnose.ksh'. A lot of statistics files appears in directory ${SCRATCH}/jbdiagconv/diagEXP.
       1. Placed in ${SCRATCH}/jbdiagconv plot statistics of your newly derived background error statistics with './plotbaloper_arome.sh', 'plotspdens_arome.sh' and 'plotvercor.sh'. This will generate a lot of postscript files in directory ${SCRATCH}/jbdiagconv. The statistics is for newly generated structure functions (named EXP) as well as for structure functions of other domains, plotted together. The meaning of these can be found in attached document by Gustafsson. Note that the plot scripts can be adjusted to plot different vertical levels instead of the currently chosen level.
   1. Another way to diagnose the background error statistics is to investigate the analysis increments of various types of data assimilation experiments. [Single observation impact experiments](./SingleObs.md) as well as full scale data assimilation experiments. For carrying out such experiments we however first need to introduce our newly generated background error statistics into a data assimilation experiment. That procedure is describe below for a full scale data assimilation experiment (utilizing in this example the FINLAND domain, for which the statistics was derived).

### Test 3DVAR with the new background error statistics
      1. create hm_home/36h14as directory. Then cd $HOME/hm_home/36h14as.
      1. create experiment by typing '~hlam/Harmonie setup' (or '~hlam/Harmonie setup -r /home/ms/spsehlam/hlam/harmonie_release/tags/harmonie-36h1.4').
      1. edit ecf/config_exp.h  as follows
       * set DOMAIN=FINLAND, 
       * I have also set ECFSLOC=ec, instead of default ectmp, but that is not crucial. In case of ECFSLOC=ec the forecasts will be archived at ec:/$uid/harmonie/$EXP/$YYYY/$MM/$DD/$HH.
      1. If you are using HARMONIE cy36h1.4 you need to copy some source code files resulting in an updated executable 'domain_prop', needed at a later stage. This by achieved by placed in $HOME/hm_home/36h14e1 typing 'ecp ec:/smx/Jb_wiki_ml/util.tar .', followed by 'tar -cvf util.tar'.
      1. Check out the file include.ass by typing  '~hlam/Harmonie co include.ass' (include.ass will appear in the directory $HOME/hm_home/36h14as/scr). 
      1. In include.ass set JBDIR=ec:/$uid/jbdata (uid being your userid, in this example 'ec:/smx/jbdata') and  f_JBCV='name of your .cv file in ec:/$uid/jbdata' (without .gz) and f_JBBAL is 'name of your .bal file in ec:/$uid/jbdata'  (without .gz)  (in this example ,f_JBCV=stabfiltn_FINEXP_168.cv, f_JBBAL=stabfiltn_FINEXP_168.bal).  Add these three lines just before the line in include.ass that is as follows:'# NAMELISTS'.
      1. From $HOME/hm_home/36h14as launch experiment by typing
```bash
   ~hlam/Harmonie start DTG=2010010306 DTGEND=2010010312 LLMAIN=06
```
      1. The resulting analysis file will be called 'MXMIN1999+0000'. Results will appear on $TEMP/hm_home/36h14as' and ec:/smx/harmonie/36h14_as/YYYY/MM/DD/HH. To diagnose the 3D-VAR analysis increments of the 36h14as-experiment, copy the files MXMIN1999+0000 (analysis) and ICMSHANAL+0000 (fg, with surface analysis applied) to $TEMP. Convert from FA-file format to GRIB with the gl-software ($TEMP/hm_home/36h14as/bin/gl) by typing './gl -p MXMIN1999+0000' and gl -p ICMSHANAL+0000'. Then plot the difference file with your favourite software.
      1. Now you have managed to couple the newly generated background error statistics to the assimilation system and managed to carry out a full scale data assimilation system and plot the analysis increments. The next natural step to further diagnose the background error statistics is to carry out a [single observation impact experiments](./SingleObs.md), utilizing your newly generated background error statistics.   

### Interpolation tests
Interpolation of background error statistics between different domains for technical data assimilation tests:
   1. A tool has been developed to interpolate background error statistics derived for one domain, to another domain. The purpose is to make it easier to get started and to carry out technical data assimilation tests for new domains. The functionality of the tool 'jbconv' is documented in detail in an attached report by Nils Gustafsson. One constraint worth mentioning is that the number of vertical levels of the two domains should be the same. In addition, wave number 1 in the spectral representation of errors should be larger for the input domain than for the output. In practice this mean that the length (in km) of the longest side of the domain should be longer for the input domin than for the output domain. See below detailed instructions for interpolation of background error statistics, for the example of deriving background error statistics for the NETHERLANDS arome domain (2.5 km hor. res. and 65 vertical levels) from the DENMARK arome domain 2.5 km hor. res. and 65 vertical levels). This conversions satisfies teh constraints on vertical levels and wave number 1 mentioned above and the interpolation procedure is as follows:
     1. Prepare experiments in forecast mode only to get forecast file, containg domain properties for input (DENMARK in this case) and output (NETHERLANDS in this case) domain properties. Create 36h14dk and 36h14nl directories as described below for 36h14dk. The procedure for 36h14nl is exactly the same, except for that you set DOMAIN=NETHERLANDS instead of DOMAIN=DENMARK in config_exp.h.
       1. On ecgb $HOME directory create hm_home/36h14dk directory. Then cd $HOME/hm_home/36h14dk.
       1. create experiment by typing '~hlam/Harmonie setup' (or '~hlam/Harmonie setup -r /home/ms/spsehlam/hlam/harmonie_release/tags/harmonie-36h1.4').
       1. edit ecf/config_exp.h  as follows
         * set DOMAIN=DENMARK, 
         * set ANAATMO=none
         * set ANASURF=none
       1. If you are using HARMONIE cy36h1.4 you need to copy some source code files resulting in an updated executable 'domain_prop', needed at a later. This by achieved by placed in $HOME/hm_home/36h14dk typing 'ecp ec:/smx/Jb_wiki_ml/util.tar .', followed by tar -cvf util.tar'. This will results in three updated source code files in subdirectories of directory 'util'. 
       1. From $HOME/hm_home/36h14dk and $HOME/hm_home/36h14nl on ecgb, launch the experiments by typing
```bash
   ~hlam/Harmonie start DTG=2010010300 LLMAIN=06
```
       1. Wait until experiments have finished.
       1. Log in to c1a (rlogin c1a) and go to $TEMP. There fetch forecast from the two domains by typing ('ecp ec:/$uid/harmonie/36h14dk/$YYYY/$MM/$DD/$HH/ICMSHHARM+0006 ICMSHHARM+0006_dk' and 'ecp ec:/$uid/harmonie/36h14nl/$YYYY/$MM/$DD/$HH/ICMSHHARM+0006 ICMSHHARM+0006_nl', respectively. Then fetch domain_prop by typing 'cp $TEMP/hm_home/36h14dk/bin/domain_prop .'
       1. Placed on $TEMP derive domain properties of the two domains by typing './domain_prop -f ICMSHHARM+0006_dk -4JB' and './domain_prop -f ICMSHHARM+0006_nl -4JB', respectively.
     1. Edit and run background error interpolation program
       1. Go to $SCRATCH on ecgb
       1. ecp ec:/smx/Jb_wiki_ml/jbdiagconv.tar . (if not already done in step 'Diagnosis')
       1. tar -xvf jbdiagconv.tar will give directory $SCRATCH/jbdiagconv  (if not already done in step 'Diagnosis')
       1. Placed in $SCRATCH/jbdiagconv compile jbdiagnose.f90 and jbconv.f90 by typing './Complile'. That will generate jbdiagnose.x and  jbconv.x. (if not already done in step 'Diagnosis')
       1. Edit namelist for geometrical domain definitions in script jbconv.sh, as well as links to input background error statistics (.cv and .bal files in data directory). The present settings corresponds to input domain definition and links to DENMARK AROME domain and output to NETHERLANDS AROME domain. The geometrical namelist settings were obtained with domain_prop, as just run on c1a $TEMP, complemented with geometrical information on domains contained in $HOME/hm_home/36h14dk/smx/config_exp.h and $HOME/hm_home/36h14nl/smx/config_exp.h on ecgb. 
       1. Placed in $SCRATCH/jbdiagconv run by typing ./jbconv.sh' 
       1. Very soon background error statistics files for output domain will appear on $SCRATCH/jbdiagconv as stabal96_out.cv and stabal96_out.bal.

### Recent work & future developments
Recent and on-going work as well as plans for future developments:
   * Present work regarding structure functions concerns investigating and introudcing the seasonal dependence of the background error statistics as well as investigating and introducing background error statistics derived from ensemble data assimilation  in the HARMONIE system. A software for converting background error statistics between different domains (aimed for technical tests) has recently been developed and a decription of how to use it is given in the report by Gustafsson attached below. The source code and scripts are included in ec:/smx/Jb_wiki_ml/jbdiagconv.tar, to be copied to $SCRATCH on ecgb and un'tared before use. In a somewhat longer perspective the aim is to also introduce a air-mass dependence of background error statistics.

## Example on ecgb/cca, 38h trunk, for DKA domain
### Produce ensemble of forecasts
      1. Prepare  experiments for running 4 downscaled HARMONIE 6h ensemble forecasts at 00 UTC or other time you want (e.g. at 06, 12, 18UTC).

            a. Create 4 directories for 4 experiments. For instance,

               $ mkdir jb_dka_h38trunk_01

                ……

               $ mkdir jb_dka_h38trunk_04


            b. Set up 4 experiments respectively. For example:

               $ cd dka_h38trunk_01

               $ Harmonie setup –r /home/ms/spsehlam/hlam/harmonie_release/trunk/


      2. Edit and modify the parameters in the configure file ecf/config_exp.h . Here’s the example for dka_h38trunk_01:

            ECFSLOC=ec

            DOMIAN=DKA

            ANAATMO=none

            ANASURF=none

            FCINT=06

            BDSTRATRTEGY=enda

            Important: Remember to add a new line at the bottom of config_exp.h:

            export ENS_MEMBER=1    (for dka_h38trunk_01)

            Also important: don’t forget to change the number for the other experiments, for instance,

            export ENS_MEMBER=2    (for dka_h38trunk_02)

            and so forth.

      3.  Launch experiments respectively, for instance,

             $ cd dka_h38trunk_01

             $ Harmonie start DTG=2012010100 DTGEND=2012013118 LLMAIN=06 BUILD=yes


### Generate structure functions

      4.  Generate forecast difference files. The below are the procedures:

          •  Log in to c2a : 

             $ rsh c2a

          •  Go to $TEMP

             $ cd $TEMP

          •  Copy a sample tar file from ECFS

             $ ecp ec:/mib/B_statistics/Jb_DKA_38trunk.tar

          •  Untar the file and you will get a directory named Jb_DKA_38trunk in which 7 subdirectories are included . You can change the directory name as whatever you want.

             $ tar xvf Jb_DKA_38trunk.tar

          •  Go to /Jb_DKA_38trunk/scripts, edit the script file “makediff” and modify the following setups so that they can adapt to your  requirements.  

             EXP1=jb_dka_h38trunk_01
              ……

             EXP4=jb_dka_h38trunk_04

             d_JB=${TEMP}/Jb_DKA_38trunk

             d_IN=”yours ECFS archive directory, such as ”ec:/mib/harmonie”

             DTG_START=start time of your experiment

             DTG_END=end time of your experiment


          •  In /Jb_DKA_38trunk/scripts, launch makediff job

             $llsubmit makediff


          •  Note: The executable “MASTERODB” for calculating differences between forecasts stored in FA files is generated from previous version and is placed in Jb_DKA_38trunk/bin. 


      5.  Calculation of structure functions (background error statistics)

          •  Create symbolic links between the difference files

             Edit and modify the file ”linkdiff”, specify the suitable time for your experiments and submit the job as below:

             $ ./linkdiff

             The symbolic sampled difference files are stored in Jb_DKA_38trunk/Stat

          •  Generate executable “fest.x” for statistic calculations

             Go to Jb_DKA_38trunk/src_festat

             $ gmake clean

             $ gmake

          •  Modify the setup in the script file “runfestat’ and run

             First, some geometrical information for your model domain is needed. 

             Go to Jb_DKA_38trunk/bin, and fetch a forecast file in FA format from your experiment. For example,

             $ cd Jb_DKA_38trunk/bin

             $ ecp ec:/mib/harmonie/jb_dka_h38trunk_01/2012/01/01/00/ICMSHHARM+0006

             $ ./domain_prop –f ICMSHHARM+0006 -4JB >geo_info

             Then the geometrical information of your model domain can be found in the file “geo_info”. 

             Second, remember using these information to replace the corresponding parameters in the script file “Jb_DKA_38trunk/scripts/runfestat”. Besides, some modifications for setup on time and location are also needed.  
  
             Finally, run the script

             $ cd Jb_DKA_38trunk/scripts

             $ llsubmit runfestat



## Derivation for IRELAND25/L65 - 37h1 on ecgb/cca
### Ensemble of forecasts
An ensemble of forecasts were generated with Harmonie 37h1.1 as per ecgb/cca FINLAND example on c1a above
### Forecast difference files
The changes to the 36h1.4 code included in ec:/smx/Jb_wiki_ml/src_arome.tar were ported to Harmonie 37h1.2 and the following steps were taken:
 * On **ecgb** build a 37h1.2 experiment set of executables:
```bash
cd $HOME/hm_home
mkdir irl25_37h1p2_DF
cd irl25_37h1p2_DF
~hlam/Harmonie setup -r /perm/ms/spsehlam/hlam/harmonie_release/tags/harmonie-37h1.2
ecp ec:/dui/Jb_wiki_ew/src_arome_37h1p2.tar .
tar -xvf src_arome_37h1p2.tar
~hlam/Harmonie Install
```
 * On **c2a** we will generate forecast file differences based on the ensemble of forecasts
```bash
cd $TEMP
ecp ec:/smx/Jb_wiki_ml/Jb_dir.tar .
tar -xvf Jb_dir.tar
cd Jb_dir
```
 * On **c2a** a new *difarm* namelist file, difarm.37h12.nml was created (based on an old Forecast namelist file). Have a look at */home/ms/ie/dui/difarm.37h12.nml* on *c2a*.
```bash
cp /home/ms/ie/dui/difarm.37h12.nml nam/
```
 * On **c2a** the *scripts/makediff* script was edited to change user and experiment details as follows:
```bash
cca182{/scratch/ms/ie/dui/Jb_dir/scripts}:241$ diff makediff makediff_ori 
42,43c42
< nmcarch="ec:/dui/harmonie/" 
< nmcexpt="37h1p2IRELAND25L65_ENS" 
---
> nmcarch="ec:/smx/harmonie/" 
49c48
< d_IN="ec:/dui/harmonie/" # ECFS archive dir (FA files)
---
> d_IN="ec:/smx/harmonie/" # ECFS archive dir (FA files)
53,54c52
< f_NAM=difarm.37h12.nml                # Namelist AROME
< #f_NAM=difarm.36h14.nml               # Namelist AROME
---
> f_NAM=difarm.36h14.nml                # Namelist AROME
63c61
< PROC_PATH=${TEMP}/hm_home/irl25_37h1p2_DF/bin/
---
> PROC_PATH=${TEMP}/hm_home/36h14_df/bin/
114,117c112,115
< ecp -o ${d_IN}/${nmcexpt}1/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC000
< ecp -o ${d_IN}/${nmcexpt}2/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC001 
< ecp -o ${d_IN}/${nmcexpt}3/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC002
< ecp -o ${d_IN}/${nmcexpt}4/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC003
---
> ecp -o ${d_IN}/36h14ee1/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC000
> ecp -o ${d_IN}/36h14ee2/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC001 
> ecp -o ${d_IN}/36h14ee3/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC002
> ecp -o ${d_IN}/36h14ee4/${yyy}/${mmm}/${ddd}/${hh}/$INFILE ELSCFSTATALBC003
```
 * Run *makediff* on c2a:
```bash
cd $TEMP/Jb_dir/scripts
llsubmit ./makediff                  
## logfiles: scripts/makediff.$$.log, Work/out.001, Work/err.001, Work/NODE.001_01
## output: Diff2/nmcstat${DTG}.${ENS}
```
### Generate background error statistics
 * On c2a background error statistic files will be produced by *festat.x* program. Here's how to build it:
```bash
cd $TEMP/Jb_dir/scripts
./linkdiff                                # create soft links for use by festat.x
cd $TEMP/Jb_dir/src_festat                # go to festat source code directory
gmake clean                               # clean up any old builds
rm -f festat.x                            # remove old festat.x executable
gmake                                     # compile code
ls -ltr                                   # check festat.x has been produced
```
 * Get domain information for *festat.x*
```bash
cd $TEMP/Jb_dir
cp $TEMP/hm_home/irl25_37h1p2_DF/bin/domain_prop .
ecp ec:/dui/harmonie/37h1p1IRELAND25L65_ENS1/2006/09/20/00/ICMSHHARM+0006 .
./domain_prop -f -4JB ICMSHHARM+0006
```
 * Use domain information in the *runfestat* script
```bash
cca182{/scratch/ms/ie/dui/Jb_dir/scripts}:71$ diff runfestat runfestat_ori
21,23c21,23
< FILA=stabfiltn_IRELAND25L65_${FIRST}_${NUMCASE}.bal
< FILB=stabfiltn_IRELAND25L65_${FIRST}_${NUMCASE}.cvt
< FILC=stabfiltn_IRELAND25L65_${FIRST}_${NUMCASE}.cv
---
> FILA=stabfiltn_FINLAND_${FIRST}_${NUMCASE}.bal
> FILB=stabfiltn_FINLAND_${FIRST}_${NUMCASE}.cvt
> FILC=stabfiltn_FINLAND_${FIRST}_${NUMCASE}.cv
32,42c32,42
<   PPL=1250.000,
<   ELON1=-14.6094361512635942,
<   ELAT1=46.8335162100850937,
<   ELON2=2.12791881434311625,
<   ELAT2=59.5945364731695975,
<   ELON0=5.00000014895278699,
<   ELAT0=53.5000015937948206,
<   NDGL=500,
<   NDLON=540,
<   NDGUX=529,
<   NDLUX=489,
---
>   PPL=1500.000,
>   ELON1=17.130104452966155,
>   ELAT1=57.865402981341838,
>   ELON2=38.207327400536130,
>   ELAT2=69.397587824994659,
>   ELON0=13.000000000000000,
>   ELAT0=64.000000000000000,
>   NDGL=600,
>   NDLON=300,
>   NDGUX=289,
>   NDLUX=589,
50,51c50,51
<   NSMAX=249,
<   NMSMAX=269,
---
>   NSMAX=299,
>   NMSMAX=149,
```
 * Execute *runfestat*
```bash
cd $TEMP/Jb_dir/scripts
./runfestat
## logfile: Stat/festat.out
## output: Stat/stabfiltn*.cv, Stat/stabfiltn*.bal
```

 * More to follow ...



----


 
