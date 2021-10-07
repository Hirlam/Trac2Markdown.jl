```@meta
EditURL="https://hirlam.org/trac//wiki//Harmonie-local-njord-exp3?action=edit"
```

## met.no Harmonie setup
# HM04_oper_make_ec with cy36h1.3 and makeup on ECMWF

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

For users that would like to experiment on ECMWF, try out the tutorial [here](./Harmonie-mSMS.md) now that you know the differences between ECMWF and njord. Here we repeat the setup for HM04 with 3DVAR and cycle 36h1.3 on ECMWF. In this experiment we will use ECMWF boundaries with the strategy operational which is the future met.no strategy. Login on ecgate is best done with the nx client because the graphical mXCDP window works best that way.

If you cut and paste, take care as the lines might wrap!

```bash
   bash                                                               # Syntax here is for bash shell
   alias Harmonie='~nhz/harmonie_release/36h1.3/config-sh/Harmonie'   # Save us from typing full path to the Harmonie script
   mkdir -p $HOME/hm_home/HM04_oper_make_ec                           # -p also creates hm_home if not existing
   cd $HOME/hm_home/HM04_oper_make_ec                                 # Enter our experiment
   Harmonie setup -r ~nhz/harmonie_release/36h1.3 -c ALARO            # Setup for cy36h1.3 and configuration ALARO. -h is not needed at ECMWF
```

We must check out the following files:
```bash
   Harmonie co scr/Makegrib
   Harmonie co scr/Verify_harmonie
   Harmonie co scr/Makeup_sync
   Harmonie co scr/include.ass
   Harmonie co scr/Fetch_assim_data
   Harmonie co scr/RunMinim
```

First let us configure the experiment in sms/config_exp.h:
```bash
   DOMAIN=NORWAY_4KM
   DYNAMICS=nh
   ANAATMO=3DVAR
   MAKEGRIB=yes
   VERIFY=yes
   OBSEXTR=bufr
```

For this run we want data assimilation for upper air so we modify the data assimilation settings in scr/include.ass
```bash
   # Together with the other if tests we must add the name of our structure functions. For example after:
   # elif [ "$DOMAIN" = NORWAY_5.5 ]; then
   #   JBDIR=${JBDIR-"ec:/snh/HARMONIE/const/jbdata"}
   #   f_JBCV=stabfiltn_NORWAY55_128.cv
   #   f_JBBAL=stabfiltn_NORWAY55_128.bal

   elif [  "$DOMAIN" = NORWAY_4KM ]; then
     JBDIR=ec:/sbt/harmonie/Const/ALR_60L_HIRL
     f_JBCV=stabfiltn_NORWAY4KM_168.cv
     f_JBBAL=stabfiltn_NORWAY4KM_168.bal
```

  
In the Makegrib script we must also here set specific met.no settings for post-processing in scr/Makegrib:
```bash
   # Insert in both naminterp namelist blocks (sufex and Upper air)
   rmisval = 1.0e+20,

   # Replace the PPPKEY's in the naminterp block for Upper air
   PPPKEY(1:42)%ppp =   1,  1,  6,  11, 11, 11, 11, 11, 33, 33, 33, 34, 34, 34, 51, 51, 52, 61, 62, 63, 66, 71, 71, 73, 74, 75, 78, 79, 81, 86, 86, 87,111,112,115,117,121,122,124,193,193,243
   PPPKEY(1:42)%ttt = 103,105,105,105,105,105,109,109,105,109,109,105,109,109,109,109,105,105,105,105,105,105,109,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105,105
   PPPKEY(1:42)%lll =   0,  0,  0,999,  0,  2,$N1,$NL, 10,$N1,$NL, 10,$N1,$NL,$N1,$NL,  2,  0,  0,  0,  0,  0,$NL,  0,  0,  0,  0,  0,  0,999,  0,  0,  0,  0,  0,  0,  0,  0,  0,999,  0,  0,
   lwrite_pponly=.TRUE.,
```

We would like to also generate an export version of the verification tar file in scr/Verify_harmonie:
```bash
   # Insert this line after ./Run_verobs_temp    Env_exp || exit
   ./Transport_ver      Env_exp || exit
```

to avoid unnecessary configuration time with makeup, we modify scr/Makeup_sync
```bash
   # replace
   # rsync -aui $RSYNC_EXCLUDE --exclude=gmkpack --exclude=monitor/bin $HM_LIB/util . >> $HM_DATA/.makeup_changes || exit
   # by
   rsync -aui $RSYNC_EXCLUDE --exclude=gmkpack --exclude=monitor/bin --exclude=monitor/scr $HM_LIB/util . >> $HM_DATA/.makeup_changes || exit
```

Roger has stored his structure-functions without zipping them. That means we need a few modifications in Fetch_assim_data and RunMinim. First scr/Fetch_assim_data:
```bash
   # Remove the .gz in this line: Access_lpfs -from $JBDIR/$F.gz ${HM_LIB}/const/jb_data/.
   Access_lpfs -from $JBDIR/$F ${HM_LIB}/const/jb_data/.
```

In the minimization scr/RunMinim:
```bash
   #Comment out these lines:
   # gunzip -c ${HM_LIB}/const/jb_data/$f_JBCV.gz > stabal96.cv || \
   #{ echo "Sorry, no covariances file!" ; exit 1 ; }
   #gunzip -c ${HM_LIB}/const/jb_data/$f_JBBAL.gz > stabal96.bal || \
   #    { echo "Sorry, no balance coeffs file!" ; exit 1 ; }
   # And insert this:
   cp ${HM_LIB}/const/jb_data/$f_JBCV stabal96.cv || { echo "Sorry, no covariances file!" ; exit 1 ; }
   cp  ${HM_LIB}/const/jb_data/$f_JBBAL stabal96.bal || { echo "Sorry, no balance coeffs file!" ; exit 1 ; }
```

Now we are finished with the modifications and we can start the experiment.
```bash
  cd ~/hm_home/HM04_oper_make_ec
  Harmonie start DTG=2007120218 DTGEND=2007120400
```

The structure of the output on ECMWF is described [here](./Harmonie-mSMS.md).

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


[Back to the njord page](./Harmonie-local-njord.md)
