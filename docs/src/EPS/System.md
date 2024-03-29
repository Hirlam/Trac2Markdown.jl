```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/System?action=edit"
```

# Ensemble mode in the Harmonie script system

## Overview
 * Purpose
 * Prerequisites
 * Option checking
 * EPS in the tdf file

## Purpose

The purpose of this document is to give more details about how ensemble mode works in the Harmonie
script system than can easily be found in other pages.
It is meant for system people and developers who need to understand or extend the functionality of HarmonEPS.
Such extensions could be e.g. implementation of new initial perturbation techniques.

## Prerequisites

Before reading further you should have a basic understanding of the
[wiki:HarmonieSystemTraining2011/Lecture/mSMS Harmonie script system and mini-SMS] (as was given in a training course in 2011).
You should also read [How to run an ensemble experiment](./EPS/Howto.md)
to get acquainted with what is already implemented.

Having read the prerequisite pages you know that an ensemble experiment is not very different
from a deterministic one, you only need to set a few ensemble related variables ENSMSEL, ENSINIPERT,
etc. in [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) and then make some member specific
exceptions in the perl "module" [harmonie.pm](https://hirlam.org/trac/browser/Harmonie/msms/harmonie.pm). But there is more
going on behind the scenes.

First of all, the ENSMSEL member selection variable exists for convenience, what is used in 
[harmonie.tdf](https://hirlam.org/trac/browser/Harmonie/msms/harmonie.tdf) and other scripts is an *expanded* version
of it called **ENSMSELX**. In the script [Start](https://hirlam.org/trac/browser/Harmonie/scr/Start)
this expansion is done by invoking script [Ens_util.pl](https://hirlam.org/trac/browser/Harmonie/scr/Ens_util.pl), which is
also used to set a couple of other convenience variables:
```bash
# Compute derived EPS quantities, needed in harmonie.tdf
export ENSSIZE ENSMFIRST ENSMLAST
ENSSIZE=`perl -S Ens_util.pl ENSSIZE`
ENSMFIRST=`perl -S Ens_util.pl ENSMFIRST`
ENSMLAST=`perl -S Ens_util.pl ENSMLAST`
ENSCTL=`perl -S Ens_util.pl ENSCTL $ENSCTL`
```
For example, if **ENSMSEL=0-8:2**, then **ENSMSELX=000:002:004:006:008**, i.e., a colon-separated list of 3-digit numbers.
In the same example, we will have **ENSMFIRST=000** and **ENSMLAST=008**. **ENSSIZE** will be 5.

## Option checking

As explained in the prerequisite documents, variables normally set in ecf/config_exp.h  can be
overridden for specific ensemble members in msms/harmonie.pm. But how is it verified that the
chosen combinations make sense for each member?

The main script that checks for a sensible combination of options in Harmonie is
[scr/CheckOptions.pl](https://hirlam.org/trac/browser/Harmonie/scr/CheckOptions.pl). This script runs
already from the Start script before mini-SMS is launched in order to catch problems
as early as possible. !CheckOptions.pl reads ecf/config_exp.h  and creates a new file
**sms/config_updated.h** (but under "merged" repository directory $HM_LIB rather than your 
experiment directory $HM_WD). In config_updated.h you will find some environment variables
that are derived from others, e.g., a lot of domain specific variables (NLON,NLAT,TSTEP etc.)
are derived from $DOMAIN. Every SMS task in the system includes first config_exp.h
and then config_updated.h. At the very bottom of config_updated.h we find:
```bash
if [ ${ENSMBR--1} -ge 0]; then
  if [ -s $HM_LIB/sms/config_mbr$ENSMBR.h]; then
. $HM_LIB/sms/config_mbr$ENSMBR.h
  fi
fi
```
That is, in ensemble mode, if sms/config_mbr$ENSMBR.h exists, it will also be
sourced by every script. And finally, the way these member specific config files
are created can be seen from this passage in the Start script:
```bash
# Check options for individual ensemble members if relevant
if [ $ENSSIZE -gt 0]; then
   perl -S CheckMemberOptions.pl || exit
fi
```
[CheckMemberOptions.pl](https://hirlam.org/trac/browser/Harmonie/scr/CheckMemberOptions.pl) includes the
member specific harmonie.pm of course, and then it loops over all the selected members
in turn, running !CheckOptions.pl with the particular environment settings for
the member in question. If a member ($ENSMBR) passes the tests, the file mentioned
above, $HM_LIB/sms/config_mbr$ENSMBR.h is created. It will contain settings for those
environment variables mentioned in harmonie.pm that differs from the default settings
in config_exp.h. This makes the correct variables available to every script, without
those scripts having to repeat the perl &Env checking in harmonie.pm.

## EPS in the tdf file

In harmonie.tdf we have many loop constructs like the following example
from the !MakeCycleInput family:
```bash
      family Cycle
         task Prepare_cycle
loop(EEE,$ENV{ENSMFIRST},$ENV{ENSMLAST})
  if( $ENV{ENSMSELX} =~ /@EEE@\b/ and '@EEE@' ne '-1' )
         family Mbr@EEE@
            trigger ( Prepare_cycle == complete )
            complete ( (../../Hour:HH + 24 - $ENV{BeginHour}) % &Env('FCINT','@EEE@') )
            edit ENSMBR @EEE@
            task Prepare_cycle
         endfamily
  endif
endloop
...
```
As can be seen, all the loops over ensemble members go from the smallest number found in ENSMSEL (ENSMFIRST)
to the highest number found (ENSMLAST), with steps of 1, but only if the actual number (@EEE@) is present
in the expanded list ENSMSELX is anything put to harmonie.def for this potential member. The perl operator
**=~** is the pattern match operator and **\b** means a word boundary (**:** or end of string in our case).

Note also how every member has its own family Mbr@EEE@ (which will expand to Mbr000, Mbr002, etc. in the harmonie.def file).
Another important thing to note is the setting
```bash
edit ENSMBR @EEE@
```
This will first create an SMS variable **%ENSMBR%** with different values for each member, which is also turned
into a shell variable $ENSMBR in sms/sms.h, which is included by all SMS tasks. From sms.h:
```bash
ENSMBR=%ENSMBR%
if [ ${ENSMBR--1} -ge 0]; then
  ENSMBR=`echo %ENSMBR% | awk '{printf "%%3.3d",$1}'`
  CYCLEDIR=%YMD%_${HH}/mbr$ENSMBR
fi
export ENSMBR
```
The end message of this is that to get ensemble member number in a script you should use **$ENSMBR**.
In non-ensemble runs ENSMBR will have the value -1.

The statement
```bash
complete ( (../../Hour:HH + 24 - $ENV{BeginHour}) % &Env('FCINT','@EEE@') )
```
deserves more explanation. It is present to account for the fact that not all members
need to have the same "forecast interval" FCINT. The Hour families in the tdf now look
like this:
```bash
      family Hour
         repeat integer HH &Env('FirstHour','min') 23 &Env('FCINT','min')
```
i.e., the loop steps with the minimum FCINT value found among the members.
Thus, if e.g. some members have FCINT=6 and some FCINT=12,
then the statement above sets the family immediately complete
for members with FCINT=12 at those cycles that are not divisible by 12 relative to
the first cycle (!BeginHour). I.e., if the run was started at a 06 or 18 cycle, members with FCINT=12
will be complete (not run) at 00 and 12 cycles, but if the run was started
at a 00 or 12 cycle, then members with FCINT=12 will not run at 06 and 18 cycles.
This behaviour has confused many users and should perhaps be changed.

## Make member specific namelist changes

In Harmonie most namelists are created on the fly from the namelist [dictionary](./Namelists.md). This allows us to make member specific changes to the namelists used in e.g. the forecast. In the following we will describe two ways of doing this.

### Through harmonie.pm

Assume we would like to change on parameter in the physcis. First we change the variable in the namelist to be dependent of an environment variable in [source:Harmonie/nam/harmonie_namelists.pm]

```bash
 NAMPHY0=>{
  'ALMAV' => "$ENV{ALMAV}",
 ...
 },
```

Second we make sure in [source:Harmonie/msms/harmonie.pm] that this environment variable is specified for each member, in this case four.

```bash
   'ALMAV'  => [ '200.','100.','50.','300.'],
```

Finally we have to make sure that the variable is exported in [source:Harmonie/ecf/config_exp.h]

```bash
 export ALMAV
```

### Make changes to the namelist generation

Another way is to specify a set of namelist changes for each member in [source:Harmonie/nam/harmonie_namelists.pm]. We could simply add a definition for e.g. the first member like

```bash
 %member_001 = (
  NAERAD=>{
   'LRRTM' => '.FALSE.,',
  },
  NAMPHY0=>{
   'BEDIFV' => '0.05,',
  },
 ), 
```

To activate the change we also need to change [source:Harmonie/scr/Get_namelist], the script that builds the namelist for us to take the `member_$ENSMBR` change into account.

```bash
 ...
 forecast|dfi|traj4d)
    NAMELIST_CONFIG="$DEFAULT dynamics $DYNAMICS $PHYSICS ${DYNAMICS}_${PHYSICS} $SURFACE $EXTRA_FORECAST_OPTIONS member_$ENSMBR"
 ...
```

Repeat this for all your members with the changes you would like to apply.