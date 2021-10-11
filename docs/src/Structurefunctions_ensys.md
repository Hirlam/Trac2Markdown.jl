```@meta
EditURL="https://hirlam.org/trac//wiki//Structurefunctions_ensys?action=edit"
```


# Derivation of Structure Functions 

## General
For each new model domain, in order to carry out upper air data assimilation (3DVAR or 4DVAR) one needs to generate background error covariances (generally referred to as structure functions). 
Within the HARMONIE community the derivation has been based on data generated with ensemble HARMONIE forecasts which downscale from ECMWF EPS runs. To alleviate spin-up issues the HARMONIE 
forecasts are run up to 6 hours. Using the ECMWF LBC data, 6h HARMONIE ensemble forecasts are initiated from ECMWF 6h forecasts daily from 00 UTC and 12 UTC, with ECMWF forecasts as initial 
and lateral boundary conditions. To obtain stable statistics, it seems appropriate to run 4 ensembles for the chosen episode (s). Ideally the episodes should sample different seasons. 
Therefore it is recommended to run for one winter month and one summer month, for example June 2016 and January 2017. These periods are chosen so as to benefit from the latest upgrade to ECMWF's EDA syste,. Thereby we sample both seasonal (January, July)  and daily (00 UTC and 12 UTC) 
variations. After running of the ensembles the archived results (6h forecasts) are processed to generate structure functions by running a program called 'festat'. 

This documentation describes a new environment for generating structure functions and was introduced in cy38h1.2. The main changes in the new environment as compared with the old environment are: (1) the ensemble forecasts are all run under on single experiment within the HARMONIE mini-sms system, (2) a software 'FEMARS' is run to generate GRIB files of forecasts differences after each cycle have completed in HARMONIE mini-sms and (3) a parallel version of the 'festat' is run as a last step of the single mini-sms experiment, after that the forecast difference files have been generated for the entire period. For earlier versions the old procedure for generating structure functions should be used (wiki:HarmonieSystemDocumentation/Structurefunctions). 

Note that under certain circumstances there is a method to technically run 3/4DVAR using structure functions derived from another HARMONIE model domain. That requires that your HARMONIE model domain is embedded in the original domain from which structure function has been derived, and with same vertical coordinate. Thus the derivation of structure function is usually the first step to go before any VAR experiment can be done. There is a program developed for converting structure functions from one area to another but it is recommended to be used for technical tests only. This procedure is described in the section [#Interpolationtests] and it is only intended for technical assimilation tests.

The procedure for generating structure functions from an ensemble of forecasts is described below for a AROME setup with 2.5 km horizontal resolution, 65 vertical level and a domain covering Denmark. The experiment is run for a winter-period of 10 days followed by a summer-period of 10 days on the ECMWF ecgb/cca computing system. Forecasts are run twice a day. In the section below detailed instructions on how to generate the structure functions are give..The other sections deals with how to diagnose the structure functions and how to interface the newly generated structure functions into the data assimilation. Finally something about recent and ongoing work and future development plans.

## Generating background error statistics (using 40h1)
The following instructions are valid for trunk and any 40h1.2 tags that have been created. These instructions will only work at ECMWF on ecgate and cca.
### New domain setup
If you are creating structure functions for a new (or you are not sure):
 1. Create a new experiment on ecgate:
```bash
mkdir -p $HOME/hm_home/newDomJb
cd $HOME/hm_home/newDomJb
~hlam/Harmonie setup -c AROME_JB -r /home/ms/spsehlam/hlam/harmonie_release/git/develop
~hlam/Harmonie co scr/Harmonie_domains.pm
```
 1. Edit scr/Harmonie_domains.pm and add your new domain definition. New domain creation is described in [HarmonieSystemDocumentation/ModelDomain] which links to the useful *Domain Creation Tool* here [https://www.hirlam.org/nwptools/domain.html](https://www.hirlam.org/nwptools/domain.html)(./ModelDomain.md)
 1. The ensemble that will be used to generate the structure functions needs to be defined in msms/harmonie.pm. An edited ensemble configuration file should define a four member ensemble that only varies the boundary memeber input (ENSBDMBR) as follows:
```bash
%env = (
#   'ANAATMO'  => { 0 => '3DVAR' },
#   'HWRITUPTIMES' => { 0 => '00-21:3,24-60:6' },
#   'SWRITUPTIMES' => { 0 => '00-06:3' },
#   'HH_LIST' => { 0 => '00-21:3' },
#   'LL_LIST' => { 0 => '36,3' },
#   'LSMIXBC'  => { 0 => 'yes' },
#   'ANASURF'  => { 0 => 'CANARI_OI_MAIN' },
   'ENSCTL'   => [ '001', '002', '003', '004'],
#   'OBSMONITOR' => [ 'obstat'],
# SLAFLAG: Forecast length to pick your perturbation end point from
# SLAFDIFF: Hours difference to pick your perturbation start point from
# SLAFLAG=24, SLAFDIFF=6 will use +24 - +18
# SLAFDIFF=SLAFLAG will retain the original SLAF construction
# SLAFK should be tuned so that all members have the same perturbation size
   'ENSBDMBR' => [ 1,2,3,4],
#   'SLAFLAG'  => [    0,    6,     6,    12,    12,  18,     18,   24,    24,    30,    30],
#   'SLAFDIFF' => [    0,    6,     6,     6,     6,    6,     6,    6,     6,     6,     6],
#   'SLAFK'    => ['0.0','1.75','-1.75','1.5','-1.5','1.2','-1.2','1.0','-1.0','0.9','-0.9'],
# When using ECMWF ENS the members should be defined
#   # 'ENSBDMBR' => [ 0, 1..10],

### Normally NO NEED to change the settings below
```
 1. Run for two one-month (30 day) periods:
```bash
cd $HOME/hm_home/newDomJb
~hlam/Harmonie start DTG=2016060100 DTGEND=2016070100
#
#~hlam/Harmonie start DTG=2017010100 DTGEND=2017013100
```
 1. Generate the statistics using festat offline:
 * Copy [Festat_offline](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Structurefunctions_ensys/Festat_offline) to cca
 * Edit the script to reflect your user and experiment details
 * Submit job with:
```bash
qsub Festat_offline
```
### Existing domain setup
 1. Create a new experiment on ecgate:
```bash
mkdir -p $HOME/hm_home/newDomJb
cd $HOME/hm_home/newDomJb
~hlam/Harmonie setup -c AROME_JB -r /home/ms/spsehlam/hlam/harmonie_release/trunk -d DOMAIN # where domain is the name of your domain
```
 1. The ensemble that will be used to generate the structure functions needs to be defined in msms/harmonie.pm. An edited ensemble configuration file should define a four member ensemble that only varies the boundary memeber input (ENSBDMBR) as follows:
```bash
%env = (
#   'ANAATMO'  => { 0 => '3DVAR' },
#   'HWRITUPTIMES' => { 0 => '00-21:3,24-60:6' },
#   'SWRITUPTIMES' => { 0 => '00-06:3' },
#   'HH_LIST' => { 0 => '00-21:3' },
#   'LL_LIST' => { 0 => '36,3' },
#   'LSMIXBC'  => { 0 => 'yes' },
#   'ANASURF'  => { 0 => 'CANARI_OI_MAIN' },
   'ENSCTL'   => [ '001', '002', '003', '004'],
#   'OBSMONITOR' => [ 'obstat'],
# SLAFLAG: Forecast length to pick your perturbation end point from
# SLAFDIFF: Hours difference to pick your perturbation start point from
# SLAFLAG=24, SLAFDIFF=6 will use +24 - +18
# SLAFDIFF=SLAFLAG will retain the original SLAF construction
# SLAFK should be tuned so that all members have the same perturbation size
   'ENSBDMBR' => [ 1,2,3,4],
#   'SLAFLAG'  => [    0,    6,     6,    12,    12,  18,     18,   24,    24,    30,    30],
#   'SLAFDIFF' => [    0,    6,     6,     6,     6,    6,     6,    6,     6,     6,     6],
#   'SLAFK'    => ['0.0','1.75','-1.75','1.5','-1.5','1.2','-1.2','1.0','-1.0','0.9','-0.9'],
# When using ECMWF ENS the members should be defined
#   # 'ENSBDMBR' => [ 0, 1..10],

### Normally NO NEED to change the settings below
```
 1. Run for two one-month (30 day) periods:
```bash
cd $HOME/hm_home/newDomJb
~hlam/Harmonie start DTG=2016060100 DTGEND=2016070100
#
#~hlam/Harmonie start DTG=2017010100 DTGEND=2017013100
```
 1. Generate the statistics using festat offline:
 * Copy [Festat_offline](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Structurefunctions_ensys/Festat_offline) to cca
 * Edit the script to reflect your user and experiment details
 * Submit job with:
```bash
qsub Festat_offline
```

## Generating background error statistics with EDA cycling (using 38h1)
  1. Preparation of one mini-sms ensemble experiment for running 8 EDA member 6h forecast cycling with 3DVAR 
     1. On ecgb $HOME directory create ~/hm_home/your_exp directory. Then cd $HOME/hm_home/your_exp.
     1. Create experiment by typing '~hlam/Harmonie setup -r ~hlam/harmonie_release/tags/harmonie-38h1.2' if you e.g. run harmonie-38h1.2.
     1. edit ecf/config_exp.h  as follows:
       * set LSMIXBC=no
       * set FCINT=6
       * set BDSTRATEGY=enda
       * set BDINT=3 
       * set FESTAT=yes
       * set ENSMSEL=1,2,3,4,5,6,7,8
       * add export ENSSIZE=8 
       * set PERTATMO=CCMA
       * set PERTSURF="yes" 
      1. Edit the msms/harmonie.pm file as follows: 
       * set 'LSMIXBC'  => { 0 => 'no', 1 => 'no' },
       * set 'ENSBDMBR' => [ 1, 2, 3, 4, 5, 6, 7, 8],
       * set 'PHYSICS'  => [ 'arome','arome','arome','arome','arome','arome','arome','arome'],
       * set 'ENSCTL'   => [ '001',  '002',  '003',  '004','005','006','007','008'],
       * set 'TSTEP'    => [  '75',  '75',  '75',  '75','75',  '75',  '75',  '75'],
      1. in $HOME/hm_home/your_exp, edit 'Env_submit'. Edit this file
       * set $nproc_festat=320=NPD*ND*NMB; where NPD is number of runs per day (4) x ND is number of days (10) x NMB is number of members (8).
  1. Launch of mini-sms ensemble experiment
```bash
   ~hlam/Harmonie start DTG=2013081500 DTGEND=2013082418 LL=6
```
  1. After the EDA runs have finished, the resulting background error statistics (structure functions) will be found on cca:$SCRATCH/hm_home/your_exp/archive/extract/. The name of the files are stab_your_exp_2013081500_320.bal.gz, stab_your_exp_2013081500_320.cv.gz and stab_your_exp_2013081500_320.cvt.gz. 


## Background error statistics on cca with EDA cycling for big areas

If you want to compute the B-matrix (structure functions) for a big integration domain using FESTAT program you need to adjust the resources in *Env_submit* and in the script *Festat*
 
    1. It is recommended to set the number of tasks to the actual number of  cases (integrations)
    2. In order to set the resources apart from defining the PBS variables it is necessary to set this trough the command line that it is how the resources are actually passed to the FESTAT program
    3. Example settings for a big area (1152x864) and 240 cases:

```bash
#PBS -l EC_total_tasks=240
#PBS -l EC_tasks_per_node=12
#PBS -l EC_threads_per_task=1
#PBS -l EC_hyperthreads=1
#PBS -l EC_memory_per_task=5000MB


MPPEXEC="aprun -N 12 -n 240 -d 1 -j 1"

```

     4. It is also possible to run FESTAT offline once the integrations have ended

 * [Festat_offline](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Structurefunctions_ensys/Festat_offline), 

## Diagnosis of background error statistics
   1. Diagnosis of background error statistics is a rather complicated task. To get an idea of what the correlations and covariances should look like take a look in the article: Berre, L., 2000: Estimation of synoptic and meso scale forecast error covariances in a limited area model. Mon. Wea. Rev., 128, 644-667. Software for investigating and graphically illustrate different aspects of the background error statistics has been developed and statistics generated for different domains has been investigated (see attached report below by Nils Gustafsson). With this software you can also compare your newly generated background error statistics with the one generated for other HARMONIE domains. This will give you and idea if your statistics seems reasonable. For diagnosing the newly derived background error statistics follow these instructions:

 1. Get the code and scripts:
```bash
# on ecgate
cd $SCRATCH
ecp ec:/smx/Jb_wiki_ml/jbdiagconv_ensys.tar .
tar -xvf jbdiagconv_ensys.tar # produces $SCRATCH/jbdiagconv
cd jbdiagconv 
```
 1. In jbdiagconv you will find:
   * **data** (containing background error statistics for different domains
   * **diagXXarome** directories containing output-statistics for different domains (for example 'diagDKarome' and  'diagFIarome')
   * two .f90 files - jbconv.f90  jbdiagnose.f90
   * three scripts for diagnostics - jbconv.sh, jbdiagnose.sh and ???
 1. Compile the fortran programs (with gfortran):
```bash
cd $SCRATCH/jbdiagconv
./Compile
```
    The *Compile* script should produce two executables, jbdiagnose.x and  jbconv.x. 
 1. Next, fetch your background error statistics files:
```bash
cd $SCRATCH/jbdiagconv/data
ecp ec:/$uid/jbdata/stab_your_exp_2012070106_240* .
gunzip stab_your_exp_2012070106_240.*.gz
```
 1. Run Jb diagnostics script:
```bash
mkdir ${SCRATCH}/jbdiaconv/diag # for output
### edit 'jbdiagnose.ksh' to read your data and adjust namelist to your domain settings (horizontal resolution and vertical levels). 
### Finally generate statistics 
./jbdiagnose.ksh'
### A lot of statistics files appears in directory ${SCRATCH}/jbdiagconv/diag
cp -r ${SCRATCH}/jbdiagconv/diag ${SCRATCH}/jbdiagconv/diagEXP
```
 1. Placed in ${SCRATCH}/jbdiagconv plot statistics of your newly derived background error statistics with './plotbaloper_arome.sh', 'plotspdens_arome.sh' and 'plotvercor.sh'. This will generate a lot of postscript files in directory ${SCRATCH}/jbdiagconv. The statistics is for newly generated structure functions (named EXP) as well as for structure functions of other domains, plotted together. The meaning of these can be found in attached document by Gustafsson (missing?). Note that the plot scripts can be adjusted to plot different vertical levels instead of the currently chosen level.
 1. Another way to diagnose the background error statistics is to investigate the analysis increments of various types of data assimilation experiments. For carrying out such experiments we however first need to introduce our newly generated background error statistics into a data assimilation experiment. That procedure is describe below for a full scale data assimilation experiment (utilizing in this example the domain placed over Denmark (named DKCOEXP), for which the statistics was derived).

## Test 3DVAR with the new background error statistics
      1. create hm_home/38h12_assim directory. Then cd $HOME/hm_home/38h12_assim.
      1. create experiment by typing '~hlam/Harmonie setup -r ~hlam/harmonie_release/tags/harmonie-38h1.2 -h ecgb-cca'.
      1. Check out the file include.ass by typing '~hlam/Harmonie co scr/include.ass' 
      1. In include.ass set JBDIR=ec:/$uid/jbdata (uid being your userid, in this example 'ec:/smx/jbdata') and  f_JBCV='name of your .cv file in ec:/$uid/jbdata' (without .gz) and f_JBBAL is 'name of your .bal file in ec:/$uid/jbdata'  (without .gz)  (in this example ,f_JBCV=stab_your_exp_2012070106_160.cv, stab_your_exp_2012070106_160.bal).  Add these three lines instead of the three lines in include.ass that follows right after the elif statement:'elif [ "$DOMAIN" = DKCOEXP]; then'. If domain is other than 'DKCOEXP' one has to look for the alternative name of the domain. 
      1. From $HOME/hm_home/38h12_assim launch experiment by typing
```bash
   ~hlam/Harmonie start DTG=2012061003 DTGEND=2012061006 LL=03
```
      1. The resulting analysis file be found on c2a (ssh c2a) under $SCRATCH/hm_home/38h12_assim/archive/2012/06/10/06 and it will be called 'MXMIN1999+0000' and on and ectmp:/smx/harmonie/38h12_assim/YYYY/MM/DD/06. To diagnose the 3D-VAR analysis increments of the 38h12_sinob-experiment, copy the files MXMIN1999+0000 (analysis) and ICMSHHARM+0003 (fg) to $SCRATCH. The first guess (background) file can be found on $SCRATCH/hm_home/38h12_assim/archive/2012/06/10/03 and ectmp:/smx/harmonie/38h12_assim/YYYY/MM/DD/03.  Convert from FA-file format to GRIB with the gl-software ($SCRATCH/hm_home/38h12_assim/bin/gl) by typing './gl -p MXMIN1999+0000' and './gl -p ICMSHANAL+0000'. Then plot the difference between files file with your favourite software. Plot horizontal and vertical cross-sections of temperature and other variables using your favourite software (MetgraF or cross for example).
      1. Now you have managed to insert the newly generated background error statistics to the assimilation system and managed to carry out a full scale data assimilation system and plot the analysis increments. The next natural step to further diagnose the background error statistics is to carry out a [single observation impact experiment](./SingleObs_ensys.md), utilizing your newly generated background error statistics. Note the variables REDNMC and REDZONE in include.ass. REDNMC is the scaling factor for the background error statistics (default value 0.6/0.9 
for DKCOEXP/NEW_DOMAIN. REDZONE described how far from the lateral boundaries (in km) the observations need to be located to be assimilated (default value 150/100) for DKCOEXP/NEW_DOMAIN.

## Interpolation tests
Interpolation of background error statistics between different domains for technical data assimilation tests:
   1. A tool has been developed to interpolate background error statistics derived for one domain, to another domain. The purpose is to make it easier to get started and to carry out technical data assimilation tests for new domains. The functionality of the tool 'jbconv' is documented in detail in an attached report by Nils Gustafsson. One constraint worth mentioning is that the number of vertical levels of the two domains should be the same. In addition, wave number 1 in the spectral representation of errors should be larger for the input domain than for the output. In practice this mean that the length (in km) of the longest side of the domain should be longer for the input domin than for the output domain. By doing some settings in the HARMONIE system background error statistics can automatically be interpolated from one area to another in HARMONIE data assimilation experiments. This procedure is described below and it has been tested on HARMONIE cy38b1.1.beta1, from which version it is applicable. In the illustrative example background error statistics are automatically generated for the MEDITERRANEAN domain from the DENMARK domain in a HARMONIE assimilation experiment carried out over the  MEDITERRANEAN domain.

      1. create hm_home/38h12_jbint directory. Then cd $HOME/hm_home/38h12_jbint.
      1. create experiment by typing '~hlam/Harmonie setup -r ~hlam/harmonie_release/tags/harmonie-38h1.2.beta.1 -h ecgb-cca'.
      1. Edit ecf/config_exp.h  as follows:
        * set DOMAIN=MEDITERRANEAN,
        * set JB_INTERPOL=yes,
      1. Check out the file jbconv.sh by typing '~hlam/Harmonie co scr/jbconv.sh'.
      1. Replace the file jbconv.sh with the corrected one attached at the bottom of this page. 
      1. Check out the file domain_prop.F90 by typing '~hlam/Harmonie co util/gl/prg/domain_prop.F90'.
      1. Replace the file domain_prop.F90 with the corrected one attached at the bottom of this page.
      1. Launch the single observation impact experiment by standing in hm_home/38h12_jbint typing:
```bash
   ~hlam/Harmonie start DTG=2012061003 DTGEND=2012061006 LL=03
```
      1. The resulting analysis file be found on cca (ssh cca) under $SCRATCH/hm_home/38h12_jbint/archive/2012/06/10/06 and it will be called 'MXMIN1999+0000' and on and ectmp:/smx/harmonie/38h12_jbint/YYYY/MM/DD/06. To diagnose the 3D-VAR analysis increments of the 38h12_sinob-experiment, copy the files MXMIN1999+0000 (analysis) and ICMSHHARM+0003 (fg) to $SCRATCH. The first guess (background) file can be found on $SCRATCH/hm_home/38h12_jbint/archive/2012/06/10/03 and ectmp:/smx/harmonie/38h12_jbint/YYYY/MM/DD/03.  Convert from FA-file format to GRIB with the gl-software ($SCRATCH/hm_home/38h12_jbint/bin/gl) by typing './gl -p MXMIN1999+0000' and './gl -p ICMSHHARM+0003'. Then plot the difference between files file with your favourite software. Plot horizontal and vertical cross-sections of temperature and other variables using your favourite software (MetgraF or cross for example). The interpolated background error statistics for the MEDITERRANEAN domain will appear on cca in $SCRATCH/hm_home/38h12_jbint/lib/const/jb_data as stabfiltn_MEDITERRANEAN_65_jbconv.cv and stabfiltn_MEDITERRANEAN_65_jbconv.bal.

Note that you can change the area you want to interpolate the structure functions from by editing in the script jbconv.sh.

## Recent work & future developments
Recent and on-going work as well as plans for future developments:
   * Present work regarding structure functions concerns investigations of spin-up effects related with downscaling of ECMWF Ensemble Data Assimilation (EDA) forecasts with the HARMONIE system. There is also work on introduction and testing of ensemble data assimilation in the HARMONIE system itself. Longer term research is towards flow dependent background error statistics and close link between the data assimilation and the ensemble forecasting system.

## References

 * [Festat guide](https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/Structurefunctions_ensys/festat_guidelines.pdf), Ryad El Katib, Meteo France, 2014
