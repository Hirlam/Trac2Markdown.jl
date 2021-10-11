```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/Setup38?action=edit"
```


# Set-up for running HarmonEPS experiments - cycle 38

## Create your exp
alias Harmonie38='/perm/ms/spsehlam/hlam/harmonie_release/branches/harmonie-38h1.1/config-sh/Harmonie'

Harmonie38 setup -r /perm/ms/spsehlam/hlam/harmonie_release/branches/harmonEPS-38h1.1 -h ecgb

## config_exp.h: differences from default in branch

For the four times a day boundary data that has different expver for 00/12 and 06/18:
```bash
MARS_EXPVER=g37o                # expver for 00 and 12 UTC
MARS_EXPVER2=g38r               # expver for 06 and 18 UTC 
```

Extended writeuptimes:
```bash
WRITUPTIMES="00 03 06 09 12 15 18 21 24 27 30 33 36"
SWRITUPTIMES="00 03 06 09 12 15 18 21 24 27 30 33 36"
```
```bash
MAKEGRIB=yes 
FCINT=06 # for exp four times a day, FCINT=12 when members are run two times a day (cntrl can still be run four times a day, set in msms/harmonie.pm)
LL=${LL-36} # when running full ensembles four times a day. LL=${LL-12} when running ensemble two times a day
ENSMSEL=0-21 # set to the number you want
```

## Boundary_strategy.pl
Harmonie38 co scr/Boundary_strategy.pl

For the exp with full HarmonEPS four times a day set to use six hours old bnd for all forecast starting times (to mimic what would be possible in operations):
```bash
} elsif ( $strategy eq 'eps_ec' ) { 
      $hh_offset = 6;
   } ;
```
## MARS_get_bd
Harmonie38 co scr/MARS_get_bd:

For HarmonEPS four times a day with different expver for 00/12 ans 06/18:
```bash
 elif [ $BDSTRATEGY == "eps_ec" ] ; then    
    if [ $HH -eq 06 -o $HH -eq 18 ] ; then
     EXPVER=${MARS_EXPVER2-frld}
    else
     EXPVER=${MARS_EXPVER-frld}
    fi
```

## 06 and 18 as main hours
If using 06 and 18 as your main hours you need to change in [scr/submission.db](https://hirlam.org/trac/browser/trunk/harmonie/scr/submission.db):

change
```bash
if ( $HH % 12 ) { $LL = $llshort; } else { $LL = $ENV{LLMAIN}; } 
to
if ( $HH % 12 == 0 ) { $LL = $llshort; } else { $LL = $ENV{LLMAIN}; } 
```

You also need to do the same in [scr/Boundary_strategy.pl](https://hirlam.org/trac/browser/trunk/harmonie/scr/Boundary_strategy.pl)
No need to chang when running full ensemble four times a day.

## Start your exp
Example start:
Harmonie38 start DTG=2014040206 DTGEND=2014040212  (LLMAIN if not set in config file)

## Storage of results
Everybody needs to make sure that they store their output-files from fullpos (the files ending with _fp) in a safe place. Ecfs could be such a place.

## Remaining
* Set the wanted output parameters, change in Select_postp.pl and Makegrib
* Need to define area for EC test period 2013
* Need to run spin-up for EC test period May 2013




