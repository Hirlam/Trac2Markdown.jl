```@meta
EditURL="https://hirlam.org/trac//wiki//MTEN?action=edit"
```
# Moist Total Energy Norm (MTEN) diagnostic

MTEN shows the sensitivity of the forecast model to different observations withdrawn from the full analysis system. 
There are two ways of computing the MTEN diagnostic:
  - A special branch was created in CY40 (see below) where the MTEN diagnostic can be requested. This approach uses Harmonie ensemble system to perform series of observation denial independent runs. This means that the following settings are used in msms/harmonie.pm
```bash
    'ENSBDMBR' => [ 0 ],
    'ENSCTL'   => [ '000',  '001',  '002',  '003', '004', '005', '006', '007' ],
    'AIRCRAFT_OBS' => [ 0, 1, 1, 1, 1, 1, 1, 1],
    'BUOY_OBS'     => [ 1, 0, 1, 1, 1, 1, 1, 1],
    'AMSUA_OBS'    => [ 1, 1, 0, 1, 1, 1, 1, 1],
    'AMSUB_OBS'    => [ 1, 1, 1, 0, 1, 1, 1, 1],
    'POL_OBS'      => [ 1, 1, 1, 1, 0, 1, 1, 1],
    'HRW_OBS'      => [ 1, 1, 1, 1, 1, 0, 1, 1],
    'TEMP_OBS'     => [ 1, 1, 1, 1, 1, 1, 0, 1],
    'IASI_OBS'     => [ 1, 1, 1, 1, 1, 1, 1, 0],
```

In this particular example, we are interested in the impact of aircraft, Buoy, amsu-a, amsu-b/mhs, polar winds, high-resolution geowinds, radiosonde, and iasi observations. This setting is activated in config.exp with the following choice:
```bash
export  REFEXP DOMTEN
export SYNOP_OBS=1             # All synop
export AIRCRAFT_OBS=1          # AMDAR, AIREP, ACARS
export BUOY_OBS=1              # Buoy
export POL_OBS=1               # Satob polar winds
export GEO_OBS=0               # Satob geo winds
export HRW_OBS=1               # Satob HRWind
export TEMP_OBS=1              # TEMP, TEMPSHIP
export PILOT_OBS=1             # Pilot, Europrofiler
export SEVIRI_OBS=0            # Seviri radiances
export AMSUA_OBS=1             # AMSU-A
export AMSUB_OBS=1             # AMSU-B, MHS
export IASI_OBS=1              # IASI
export PAOB_OBS=0              # PAOB not defined everywhere
export SCATT_OBS=0             # Scatterometer data not defined everywhere
export LIMB_OBS=0              # LIMB observations, GPS Radio Occultations
export RADAR_OBS=0             # Radar
export GNSS_OBS=0              # GNSS
```

Where REFEXP is the reference experiment (see below), and DOMTEN (yes,no) is activate the MTEN choice when fetching the First-guess and the VarBC files for the MTEN computation, as follows:
in /scr/Fetch_assim_data:
```bash
        if [ ${DOMTEN} = "yes" ]; then
         HM_REFEXP=/sbt/harmonie/$REFEXP
         adir=${ECFSLOC}:${HM_REFEXP}/$YY/$MM/$DD/$HH
        else
         adir=$( ArchDir $HM_EXP $YY $MM $DD $HH )
        fi
```

in scr/FirstGuess
(be careful this happens twice in the script)
```bash
     if [ ${DOMTEN} = "yes" ]; then
       HM_REFEXP=/sbt/harmonie/$REFEXP
       adir=${ECFSLOC}:${HM_REFEXP}/$FGYY/$FGMM/$FGDD/$FGHH
     else
       adir=$( ArchDir $HM_EXP $FGYY $FGMM $FGDD $FGHH )
     fi
```

  - The MTEN can be also computed using a deterministic system. In this case, you need to take care of the First-guess and the VraBC files, which should come from the reference experiment. You need to carefully set the choice of the observations to be tested in scr/include.ass. In this case, you need to adapt the above Fetch_assim_data and FirstGuess scripts accordingly.

The MTEN diagnostic, similarly to DFS, is case sensitive, so it's better to male the computation with times and dates enough distant (by 5 days or more).

The MTEN can be computed the example below:
```bash
  for EXP in EXP1 EXP2;
    for RANGE in 06 12 18 24 30 36 42 48;
    do

       YY=`echo $DTG | cut -c 1-4`
       mm=`echo $DTG | cut -c 5-6`
       dd=`echo $DTG | cut -c 7-8`
       hh=`echo $DTG | cut -c 9-10`
       # -- Get the FA files
       # ===================
       ecp ec:/$USER/harmonie/$REFEXP/$YY/$mm/$dd/$hh/ICMSHHARM+00$RANGE ./FAREF$RANGE
       ecp ec:/$USER/harmonie/${EXP}/$YY/$mm/$dd/$hh/ICMSHHARM+00$RANGE ./${EXP}$RANGE
       $MTEN_BIN/MTEN ./FAREF$RANGE ./${EXP}$RANGE

    done
  done

```

See [Storto & Randriamampianina, 2010](http://onlinelibrary.wiley.com/doi/10.1002/asl.257/full) ([pdf](https://hirlam.org/trac/attachment/wiki/HarmonieWorkingWeek/UseObs201605/Relative_Impact_AS_RR_2010.pdf)) for more details.


The harmonie-40h1_DA branch can be used to calculate MTEN values for selected (40h1.2/trunk) forecasts by using the ensemble functionality to carry multiple observation withdrawal experiments. Follow these instructions:
 * Check out the DA branch:
```bash
mkdir -p $SCRATCH/harmonie_releases/branches
cd $SCRATCH/harmonie_releases/branches
svn co https://svn.hirlam.org/branches/harmonie-40h1_DA
```

 * Set up your (MTEN) experiment:
```bash
mkdir -p $HOME/hm_home/mtenEXP
cd $HOME/hm_home/mtenEXP
$SCRATCH/harmonie_releases/branches/harmonie-40h1_DA/config-sh/Harmonie setup -r $SCRATCH/harmonie_releases/branches/harmonie-40h1_DA
```

 * You will need to edit the ecf/config_exp.h  file and msms/harmonie.pm file to produce the required observation withdrawal experiments.

... More to follow ...
