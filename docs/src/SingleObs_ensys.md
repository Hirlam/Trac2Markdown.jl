
==
#  Single observation impact experiment 

## **General**
The results of single observation impact experiment provide useful information of the observation operator and error statistics. Among others, it is a useful tool for diagnosing background error statistics. The procedure decribed below is the recommended one and it has been tested on HARMONIE cy38b1.1.beta1, from which version it is applicable. It is intended to replace [the older and more complicated procedure for carrying out single observation impact experiments](HarmonieSystemDocumentation/SingleObs). The illustration below with the new system is for a AROME domain covering Denmark (DKCOEXP). One single temperature observation 1K warmer than the corresponding background value and with and observation error standard deviation of 1 K is placed in the center of the domain.

## **Illustrative example of single observation impact experiment on ecgb/cca, for area DKCOEXP**
      1. create hm_home/38h12_sinob directory. Then cd $HOME/hm_home/38h12_sinob.
      1. create experiment by typing '~hlam/Harmonie setup -r ~hlam/harmonie_release/tags/harmonie-38h1.2.beta.1 -h ecgb-cca'.
      1. Edit ecf/config_exp.h  as follows:
        * set DOMAIN=DKCOEXP,
        * set ANASURF=none,
        * set SINGLEOBS=yes,
      1. Check out the file Create_single_obs by typing '~hlam/Harmonie co scr/Create_single_obs (not needed only for your understanding how obs is created)'. 
      1. Check out the file domain_prop.F90 by typing '~hlam/Harmonie co util/gl/prg/domain_prop.F90'.
      1. Replace the file domain_prop.F90 with the corrected one attached at the bottom of this page.
      1. Launch the single observation impact experiment by standing in hm_home/38h12_sinob typing:
```bash
   ~hlam/Harmonie start DTG=2012061003 DTGEND=2012061006 LL=03
```
      1. The resulting analysis file be found on c2a (ssh c2a) under $TEMP/hm_home/38h12_sinob/archive/2012/06/10/06 and it will be called 'MXMIN1999+0000' and on and ectmp:/smx/harmonie/38h12_sinob/YYYY/MM/DD/06. To diagnose the 3D-VAR analysis increments of the 38h12_sinob-experiment, copy the files MXMIN1999+0000 (analysis) and ICMSHHARM+0003 (fg) to $TEMP. The first guess (background) file can be found on $TEMP/hm_home/38h12_sinob/archive/2012/06/10/03 and ectmp:/smx/harmonie/38h12_sinob/YYYY/MM/DD/03.  Convert from FA-file format to GRIB with the gl-software ($TEMP/hm_home/38h12_sinob/bin/gl) by typing './gl -p MXMIN1999+0000' and './gl -p ICMSHANAL+0000'. Then plot the difference between files file with your favourite software. Plot horizontal and vertical cross-sections of temperature and other variables using your favourite software (MetgraF or cross for example). 

Note that you can change position of observation, observation error, variabe to be observed etc. Investigate these options by taking a closer look at the script Create_single_obs.

Read more about radiance single observation experiments [here](http://cimss.ssec.wisc.edu/itwg/itsc/itsc17/posters/7.22_randriamampianina.pdf).
In ec:/smx/sinob_wiki_ml you will also find OBSOUL_amsua7, a file for generating a satellati radiance amsu a channel 7 single observation impact experiment.




----


 