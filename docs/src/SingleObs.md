```@meta
EditURL="https://hirlam.org/trac//wiki//SingleObs?action=edit"
```


# Single observation impact experiment 


**This is the old deprecated method for single obs experiments. For the supported method read on [here](./SingleObs_ensys.md).**




## General
The results of single observation impact experiment provide useful information of the observation operator and error statistics. Among others, it is a useful tool for diagnosing background error statistics. Unfortunately it has earlier been rather cumbersome to carry out single observation impact experiments with HARMONIE, due to the previous problems of HARMONIE data assimilation when the number of observations was less than the number of processors used when running the data assimilation. This problem has been solved by Sami Saarinen (some problems wih empty pools in surface data assimilation remains though) in HARMONIE cy36h14, so for that HARMONIE version the instructions below are intended. They are made in the form of an illustrative example, 
where an observation 1 K warmer than the corresponding background value, for the date 20100103 12 UTC was placed at 500 hpa and at the center of the FINLAND APOME domain, utilizing 65 vertical levels.


## Illustrative example of single observation impact experiment on ecgb/cca, for area FINLAND
 * Create experiment, prepare for future reading of single observation and launch forecast to be used as background state.
     1. On ecgb $HOME directory create hm_home/36h14_sinob directory. Then cd $HOME/hm_home/36h14_sinob
     1. create experiment by typing '~hlam/Harmonie setup' (or '~hlam/Harmonie setup -r /home/ms/spsehlam/hlam/harmonie_release/tags/harmonie-36h1.4').
     1. edit ecf/config_exp.h  to set 'DOMAIN=FINLAND' and 'ANASURF=none'
     1. Check out scr/RunBatodb by typing ('~hlam/Harmonie co scr/RunBatodb'). Then hm_home/36h14_sinob/scr/RunBatodb will appear. 
     1. In scr/RunBatodb modify replace the 2 lines containing 'ln -sf $OBSOUL ./OBSOUL.conv' with 'ecp -o ec:/$uid/OBSOUL.sinob ./OBSOUL.conv'. (note that if you want to utilize newly derived background error statistics you need also to check out and modify include.ass to utilize your statistics, as is described in the  [instructions about derivation of structure functions](./Structurefunctions.md). Note in this case $uid (user id) is smx.
     1. Produce 6h forecast to be used as background state by typing (first cycle is always by default without data assimilation):
```bash
   ~hlam/Harmonie start DTG=2010010306 LLMAIN=06
```
     1. When the experiment is finished the 6 h forecast to be used as background state appears at at ectmp:/$uid/harmonie/36h14_sinob/2010/01/03/06/MXMIN1999+0000

 * Prepare single observation input file 
     1. login on c1a and go to $TEMP
     1. Copy the tar-file placed on ec:/smx/sinob_wki_ml/sinob.tar ('ecp ec:/smx/sinob_wiki_ml/sinob.tar' .) and un-tar it ('tar -xvf sinob.tar'). You will find the files naminterp.dat and OBSOUL.ref.
     1. Copy gl from $TEMP/hm_home/36h14_sinob/bin/gl to $TEMP
     1. Copy background field to $TEMP by typing 'ecp ectmp:/$uid/harmonie/36h14_sinob/2010/01/03/06/ICMSHHARM+0006 .'
     1. Find Approximate latitude and longitude of center of domain (latc,lonc)  by typing './gl -l ICMSHHARM+0006 | grep -i Latc'
     1. Find background temperature value at lat, lon found in previous step by editing GPLAT, GPLON in naminterp.dat. Then type './gl -n naminterp.dat ICMSHHARM+0006 -l' A file gp2010010306+006 will appear. At the last lone the background value of the temperature in the given lat, lon at 500 hPa is written. Use that value increased by 1 Kelvin as observed value.
     1. Copy OBSOUL.ref to OBSOUL.sinob. Edit OBSOUL.sinob by replacing the LAT, LON and OBVAL in OBSOUL.sinob with the values derived above. Then copy OBSOUL.sinob to ecfs, where uit will bw used for teh single observation impact experiment ('ecp -o OBSOUL.sinob ec:/$uid/OBSOUL.sinob')

 * Run data assimilation
     1. Placed on $HOME/hm_home/36h14_sinob on ecgb start the experiment by typing:
```bash
   ~hlam/Harmonie prod LLMAIN=06
```
     1. When the experiment is finished the analysis appears at ectmp:/$uid/harmonie/36h14_sinob/2010/01/03/12/MXMIN1999+0000

 * Look at analysis increments
     1.  Go to $TEMP on c1a
     1. Copy gl from $TEMP/hm_home/36h14_sinob/bin/gl to $TEMP
     1.  Copy analysis file ('ecp -o ectmp:/$uid/harmonie/36h14_sinob/2010/01/03/12/MXMIN1999+0000 .') and background file ('ecp ectmp:/$uid/harmonie/36h14_sinob/2010/01/03/06/ICMSHHARM+0006 .').
     1. Convert the FA files to GRIB format by typing './gl -c MXMIN1999+0000' and './gl -c ICMSHHARM+0006'. Files MXMIN1999+0000.grib and ICMSHHARM+0006.grib will be generated. The difference between these two files are the analysis increments (in GRIB format)representing the impact caused by teh single temperature observation. Plot horizontal and vertical cross-sections of temperature and other variables using your favourite software (MetgraF or cross for example). 


Read more about radiance single observation experiments [here](http://cimss.ssec.wisc.edu/itwg/itsc/itsc17/posters/7.22_randriamampianina.pdf).
In ec:/smx/sinob_wiki_ml you will also find OBSOUL_amsua7, a file for generating a satellati radiance amsu a channel 7 single observation impact experiment.



----


 
