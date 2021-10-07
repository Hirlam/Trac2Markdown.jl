```@meta
EditURL="https://hirlam.org/trac//wiki//DataAssimilation4DVAR?action=edit"
```


# Harmonie 4D-Var (under development)

## General
An option for doing assimilation with
4D-Var has been included in the HARMONIE mini-SMS system (in branch harmonie-35h1, which is called 35h1branch at ecgb). The 4D-Var tasks are invoked only if ANAATMO is set to 4DVAR in config_exp.h. It implies that a number of extra steps are carried out in the !MakeCycleInput loop of mini-SMS. Climate fields and lateral boundaries at low resolution are genenerated, in addition to the corresponding 
fields at high resolution. These fields are needed in the 4D-Var tasks under the Date loop of Harmonie. Also the generation of observations 
in ODB through BATOR is slightly modified in case of 4D-Var. The 4D-Var tasks carry out the data assimilation. At present it is working only for one outer loop and 6 hour centered data assimilation time window. It has been tested only on domain SCANDINAVIA and at the ECMWF computer platform. 4DVAR consists of the following steps (rather closely following the ARPEGE 4D-Var structure):

  1. 4DVprolog - converting high res. first guess to low res.
  1. 4DVscreen - 4D-Var screening of observations
  1. fph2l - (not used presently, but when multiple outer loops)
  1. 4DVminim - 4D-Var minimization at low res producing low res analysis (at the beginning of assimilation time window)
  1. fpl2h_fg - converting low res. first guess to high res. using FULLPOS
  1. blend_an - Merge surface fields from low res. first guess to low res. analysis by applying BLENDSUR
  1. fpl2h_an - converting low res. analysis (updated with first guess surface fields) to high res. analysis with FULLPOS
  1. 4DVtraj - trajectory run propagating analysis 3 hours forward in time to the center of the assimilation time window 

As a first step, we have chosen to apply the CANARI surface data assimilation after the trajectory run has been carried out (with 3D-Var the CANARI surface data assimilation is carried out before the minimization). The 4D-Var analysis at the center of the assimilation time window is used as first guess for CANARI and the output of CANARI is used as initial state for the forecast model.

Note that if the HARMONIE mini-SMS system is run with 4D-Var, for the first assimilation time cycle only a forecast is carried out, no data assimilation. The reason is that 4D-Var requires a first guess from the previous assimilation time cycle and we have chosen not to use an interpolated lateral boundary condition file as first guess for the first assimilation cycle. 


## Try to run HARMONIE 4D-Var on ecgb/cca?

  1. Login to ecgb and create your experiment har4d under $HOME/hm_home and thereafter go to $HOME/hm_home/har4d
  1. Place in $HOME/hm_home/har4d setup your experiment by typing: ~nhz/Harmonie setup -r ~nhz/harmonie_release/35h1branch
  1. Do some modifications in $HOME/hm_home/har4d/ecf/config_exp.h : ANAATMO=4DVAR, BUILD_ROOTPACK=${BUILD_ROOTPACK-yes},DFI="fdfi" 
  1. Go to directory $HOME/hm_home/har4d and start 12 h forecast by typing: ~nhz/Harmonie start DTG=2009021012 LL=12
  1. When the forecast has finnished, start 4dvar by typing: ~nhz/Harmonie prod LL=12





 

----


