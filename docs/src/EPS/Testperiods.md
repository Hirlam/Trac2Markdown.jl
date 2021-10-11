```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/Testperiods?action=edit"
```

# NOW EC EPS ml-data are available for any period after ~ 2014 

From cy40 EC EPS data on model levels can be accessed from the GLAMEPS ECFS archive so we are no longer dependent on the 
test periods described below. Access by putting BDSTRATEGY=eps_ec in config_exp.h. 

Another option is to use SLAF, which is set to default see: [How to use SLAF](./EPS/SLAF.md).

If you want to use the older test periods, this is what is available:

# Available test periods for HarmonEPS
## for which there are model level data from IFS ENS


## IFS ENS initialized at 00 and 12 UTC
• Period 26.12.2011 - 8.1.2012

  
• Period 23.10.2011 - 7.11.2011

  
• Period 10.06.2012 - 28.06.2012


Two different configurations

• Exp: R,   Resolution: T639,       Ensemble size: 20+1,      FC range (d):  7

• Exp: H,   Resolution: T1279,      Ensemble size: 20+1,      FC range (d):  7

Use class=rd, expver=fsht for exp H, expver=frld for exp R.
Model level data is archived 1-hourly until a lead time of 48 h, and 3-hourly afterwards. IFS model
cycle 38R1. In order to keep the data volume manageable, model level data is archived regionally on
reduced Gaussian grids.


## IFS ENS initialized four times a day
• Period 10.05.2013 - 31.05.2013
NB: Data now deleted from disk at ECMWF. A subset is stored in ecfs

00 and 12 UTC: class=rd, expver=g3y2

06 and 18 UTC: class=rd, expver=g3y3

Data can be found here: ec:/hirlam/bnd/g3y2/ and ec:/hirlam/bnd/g3y3/

For each date every ensemble member is stored, which included all time steps and parameters:  eceps_YYYYMMDDHH_ens_NNN.mars

To use this data in your experiment (included in harmonEPS-38h1.1 and cy40 trunk) you need to set MARS_EXPVER=g3y2 and MARS_EXPVER2=g3y3 in config_exp.h. 

In MARS_get_bd: 
   elif [ $BDSTRATEGY == "eps_ec"] ; then
    if [ $HH -eq 06 -o $HH -eq 18] ; then
     EXPVER=${MARS_EXPVER2-frld}
    else
     EXPVER=${MARS_EXPVER-frld}
    fi

You also need to set in scr/Boundary_strategy.pl: EXT_ACCESS => 'ECFS_bd', (instead of EXT_ACCESS => 'MARS_umbrella',) 

and in msms/harmonie.tdf you need to do the following:

Comment out:
1)
```bash
#          task MARS_stage_bd 
#          edit SMSTRIES 2 
#          complete [ $ENV{COMPCENTRE} ne 'ECMWF' or $ENV{HOST_MODEL} =~ /^a/ or $ENV{HOST_MODEL} eq 'hir'] 
```

2)
```bash
#          task MARS_prefetch_bd
#          trigger ( ../../MARS/MARS_stage_bd == complete and \
#                       Prepare_cycle == complete )
#          complete [ $ENV{COMPCENTRE} ne 'ECMWF' or $ENV{HOST_MODEL} =~ /^a/ or $ENV{HOST_MODEL} eq 'hir']
```

3)
```bash
# remove dependence on MARS_prefetch_bd:
         family Boundaries
            trigger ( Climate          == complete )

(so delete:
\ and
MARS_prefetch_bd == complete )
```



Configuration:

As operational ENS (model cycle 40r1) except for:

• run on Cray, therefore not bit-identical with operations (0001)

• 20+1 members instead of 50+1 members

• steps 0/to/48 every 3 hours

• Area is 30 to 85 deg N, and 30W to 60E.

• the 06 and 18 UTC runs use STREAM=scda analyses for the centre of the ensemble distribution and EDA perturbations based on 12-hour forecasts (instead of 6-hour forecasts)

