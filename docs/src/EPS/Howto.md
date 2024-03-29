```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/Howto?action=edit"
```


# How to run an ensemble experiment



## Simple configuration
Running an ensemble experiment is not very different from running a deterministic one. The basic instructions about setup
are the same and will not be repeated here, see e.g. [Running Harmonie under (m)SMS](./Harmonie-mSMS.md) or
[wiki:HarmonieSystemTraining2011/RunningExperiment First Time You Run HARMONIE Experiment].

What is different is that in [ecf/config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) one needs to pay attention to this
particular section:
```bash
# *** Ensemble mode general settings. ***
# *** For member specific settings use msms/harmonie.pm ***
ENSMSEL=                                # Ensemble member selection, comma separated list, and/or range(s):
                                        # m1,m2,m3-m4,m5-m6:step    mb-me == mb-me:1 == mb,mb+1,mb+2,...,me
                                        # 0=control. ENSMFIRST, ENSMLAST, ENSSIZE derived automatically from ENSMSEL.
ENSINIPERT=                             # Ensemble perturbation method (bnd). Not yet implemented: etkf, hmsv, slaf.
ENSCTL=                                 # Which member is my control member? Needed for ENSINIPERT=bnd. See harmonie.pm.
ENSBDMBR=                               # Which host member is used for my boundaries? Use harmonie.pm to set.
ENSMFAIL=                               # Failure tolerance for all members. Not yet implemented.
ENSMDAFAIL=                             # Failure tolerance for members doing own DA. Not yet implemented.
```
In addition one should also look at `BDSTRATEGY`, choose *eps_ec* if you want to use EC EPS at the boundaries (this option gets the EC EPS data from the GLAMEPS ECFS archive). If you want to use SLAF see here: [How to use SLAF](./EPS/SLAF.md).

What really triggers EPS mode is having a non-empty ENSMSEL (ensemble member selection). The reason the specification looks a bit complicated is that our ensemble members do
not necessarily have to be numbered consecutively from 0 or 1 and up, but can also be specified with steps. The rationale behind this is that we may want to e.g. downscale a subset
of the 51 ECMWF EPS members, but not necessarily starting from their lowest number or taking them consecutively. ENSMSEL is a heritage from the Hirlam EPS system and has been retained in Harmonie.

In the simplest case of consecutive numbering, say we want a control run (member 0) and 20 perturbed members. We can then put
```bash
ENSMSEL=0-20
```

Now assume that we still have a control and 20 members, but that we want to take only every second pair of the host EPS members, i.e., take 0,1,2, skip 3,4, take 5,6, skip 7,8 and so on.
The following specifications are then equivalent:
```bash
ENSMSEL=0,1,2,5,6,9,10,13,14,17,18,21,22,25,26,29,30,33,34,37,38
ENSMSEL=0,1-37:4,2-38:4
```
In the second version we use the step option, so our list is 0, 1 to 37 in steps of 4 and 2 to 38 in steps of 4. The system will take care of transforming this into an ascending list for easier handling within the script system, but we don't have to worry about that.

The ENSMSEL selection is still not totally flexible. It would not be possible to have more than one of our members having boundaries from the same member of the host model. This might be relevant in the case of multiple physics, and multiple control members. For this reason the variable `ENSBDMBR` has also been added (in [10953]). The usage of this variable is explained in the next section (advanced configuration).

For the rest of the ENS... variables, not everything planned is implemented by the time of this writing. The only valid choice (except empty) for ENSINIPERT
(initial state perturbation method) is "bnd". This option means to take the perturbations of the first (interpolated) boundary file, and add these perturbations to a reference (control) analysis.
This will involve the script [PertAna](https://hirlam.org/trac/browser/Harmonie/scr/PertAna), a section of its header is quoted below:
```bash
#| Different perturbation methods are distinguished by
#| ENSINIPERT. This script implements ENSINIPERT=bnd
#|
#| bnd: boundary data mode
#|      an($ENSMBR) = an(cntrl) + bnd1($ENSMBR) - bnd1(cntrl)
#|           where bnd1 denotes the first boundary file
```
Which member is the control member is specified by the variable ENSCTL.

But how to specify that one (or more) member(s) run assimilation and others do not, or in other words, how to specify member specific values to the variables in **config_exp.h**?
This is the topic of the next section.

## Advanced configuration, member specific settings
It would perhaps have been possible to also have member specific configuration in config_exp.h, but since perl is more flexible with lists than the shell, and since perl is already used extensively in the Harmonie system, it was decided to extend the handling of the template definition files in mini-SMS in such a way that every tdf can now also have an associated perl
module to help in its interpretation. And, since after the changesets [10930] and [10932] there is *no separate tdf* for HarmonEPS anymore (harmonie.tdf is used also for EPS runs), the
file that is used for member specific settings is thus [msms/harmonie.pm](https://hirlam.org/trac/browser/Harmonie/msms/harmonie.pm).

The idea of harmonie.pm is to be able to override some of the environment variables of config_exp.h with new values for selected members of the ensemble. This is achieved by populating
the perl hash **%env** with *key => value* pairs. The keys are names of environment variables, like "ANAATMO", "ANASURF", "PHYSICS" etc. Only names that are present and exported in
config_exp.h should be used as keys. Values can take four different forms:

  * A hash, i.e., a new set of *key => value* pairs. The syntax in this case is ` { m1 => val1, m2 => val2, ... } `. The numbers m1, m2, etc. must be member numbers given in ENSMSEL. Order is irrelevant, and only members with values different from the default need be listed of course.
  * An array, where indices implicitly run from 0 and up. The syntax in this case is ` [ val0, val1, val2, ...] `. Here the array should have as many values as members given in ENSMSEL, but if not, missing values will be recycled from the start of the array (as many times as necessary). Thus, using arrays will give values to all members, and order is important.
  * A scalar (string). This string is subject to variable substitution, i.e., any occurrence of the substring @EEE@ will be replaced by the relevant 3-digit ensemble member number.
  * A subroutine (reference), syntax is typically ` sub { my $mbr = shift; return "something dependent on $mbr"; } `. The arguments given to the subroutine are the "args" of the invoking &Env('SOMEVAR',args) call (see below).

In addition to the hash **%env**, harmonie.pm also contains a subroutine **Env**. In [harmonie.tdf](https://hirlam.org/trac/browser/Harmonie/msms/harmonie.tdf) many earlier occurences of ` $ENV{SOMEVAR} ` have now been replaced by subroutine calls ` &Env('SOMEVAR','@EEE@') `. The '@EEE@' argument will be replaced by the relevant member number before invocation, and **Env** will check the hash **%env** for a member specific setting to possibly return instead of the default value ` $ENV{SOMEVAR} `. There should normally be no need to make changes to the subroutine **Env**, putting entries into the hash **%env** ought to be enough.

Note also that not every occurrence of ` $ENV{...} ` has been replaced by a corresponding ` &Env(...) ` in harmonie.tdf, only those variables that are most likely to have variations among members are changed. If you need variations in e.g. ` $HOST_MODEL `, then harmonie.tdf needs to be updated so that those variations are respected within the ensemble (EEE) loops.

## An example
We will now look at one particular example, in order to (hopefully) make the descriptions above a bit more clear. Our intent is to have an ensemble with a mix of members with AROME and ALARO physics, with one control member and 10 perturbed members for each. The control members will both do their own 3DVAR assimilation, while perturbed members will have `ANAATMO=blending`. But with `ENSINIPERT=bnd`, the control analysis will be used also by the perturbed members. All members will do surface assimilation, but the forecast interval differs. The control members have a forecast interval of 6 hours (because of the 3D-Var), while the perturbed members have `FCINT=12`. To achieve this, we have the following settings in config_exp.h:
```bash
ANAATMO=blending
ANASURF=CANARI_OI_MAIN
FCINT=12
BDSTRATEGY=eps_ec
ENSMSEL=0-21
ENSINIPERT=bnd
ENSCTL=
ENSBDMBR=
```
In harmonie.pm our *%env* looks as follows:
```bash
%env = (
   'ANAATMO' => { 0 => '3DVAR', 1 => '3DVAR' },
   'FCINT'   => { 0 => 6,       1 => 6 },
   'PHYSICS' => [ 'arome','alaro','alaro','arome'],
   'ENSCTL'  => [ '000',  '001',  '001',  '000'],
   'ENSBDMBR' => [ 0, 0, 1..20],

### Normally NO NEED to change the variables below
   'ARCHIVE' => '${ARCHIVE}mbr@EEE@/',
   'CLIMDIR' => '$CLIMDIR/mbr@EEE@',
   'OBDIR' => '$OBDIR/mbr@EEE@',
   'VFLDEXP' => '${EXP}mbr@EEE@',
   'BDDIR' => sub { my $mbr = shift;
                    if ($ENV{COMPCENTRE} eq 'ECMWF') {
                       return '$BDDIR/mbr'.sprintf('%03d',$mbr);
                    } else {
                       return '$BDDIR/mbr'.sprintf('%03d',&Env('ENSBDMBR',$mbr));
                    }
                  },
   'FirstHour' => sub { my $mbr = shift;
                        return $ENV{StartHour} % &Env('FCINT',$mbr);
                      }
    );
```
ANAATMO is straightforward, only the control members need an exception from *blending*, so using a hash is most appropriate. Similarly for FCINT.
For PHYSICS we have used an array and the fact that the array will be recycled. Thus member 0 will be the AROME control, while member 1 will be the ALARO control. The reason why we did not simply put a 2-element array [ 'arome','alaro'] to be repeated is that since the ECMWF perturbations come in +/- pairs, we don't want all the '+' perturbations to be always with the same physics (and the '-' perturbations with the other type). Therefore, we added a second pair with the order reversed, to alternate +/- perturbations between AROME and ALARO members.
ENSCTL follows the same pattern as PHYSICS. Note the need for 3-digit numbers in ENSCTL, at present this is necessary to avoid parsing errors in the preparation step of mini-SMS.

Note also how we have used ENSBDMBR. For both the AROME control (member 0) and ALARO control (member 1), we have used the EC EPS control member 0 to provide boundaries. The syntax
1..20 is a perl shorthand for the list 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20.

Note added after changeset [12537]: The setting of ENSBDMBR created a race condition in the boundary extraction for runs at ECMWF. This is hopefully solved by the new definition for 'BDDIR', which makes use of the possibility of having a subroutine to compute the member specific settings. Another example where a subroutine came out handy was for the setting of '!FirstHour'.

## Further reading

More specific instructions and information about known problems can be found [here](./EPS/Setup.md).


----


