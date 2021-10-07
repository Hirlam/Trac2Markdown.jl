```@meta
EditURL="https://hirlam.org/trac//wiki//CompileHarmonie?action=edit"
```


# Install Harmonie 31h1 on an independent platform

## Build HARMONIE from the HARMONIE repository
The following assumes you have a working GNU/Linux system with gfortran and gcc (version >= 4.3.0) in your PATH. You can obtain [binaries here](http://gcc.gnu.org/wiki/GFortranBinaries). Note also that the description below is valid for HARMONIE system around cycle 31h1. Please consult relevant updates in [wiki:HarmonieSystemDocumentation HARMONIE documentation for later cycles]
### Preparation
First you need some auxiliary libraries (attached to this page), provided by ECMWF and Meteo France. Create a directory $HOME/auxlibs and put the following files there:
```bash
-rw-r--r--  1 harmonie harmonie   873979 2007-05-28 11:39 auxlibs_ecmwf.0.2.tgz            ECMWF's sources
-rw-r--r--  1 harmonie harmonie   156049 2007-05-28 11:40 auxlibs_meteo-france.0.2.tgz     Meteo France's sources
```

Note that auxlibs_ecmwf.0.2/bufrdc_000240/bufrdc/buevar.F contains a superfluous "EXTERNAL GETENV".  Surround this by "#ifndef linux" and "#endif" before make-ing.

Unpack both gzipped tar files.  Until we fix this in the online copy, in auxlibs_ecmwf.0.2/, add the flag -DINTEGER_IS_INT to each CFLAGS, FASTCFLAGS variable in the various config.linux*_gnu* files.

In each of the auxlibs_ecmwf.0.2 / auxlibs_meteo_france.0.2 directory, build the libraries by running the script
```bash
        ./make_everything
```
If your GNU/Linux system doesn't have the libraries BLAS and LAPACK installed (see ls -l /usr/lib/*blas* /usr/lib/*lapack*), get them from http://netlib.org and build them.  Install them as libblas.a and liblapack.a in $HOME/auxlibs.
### Get the source and build
Now check out HARMONIE from the repository at the host hirlam.org:
```bash
        svn export https://svn.hirlam.org/trunk/harmonie                              # for the latest trunk version
        svn export https://svn.hirlam.org/tags/harmonie-31h1 harmonie                 # for the tagged version 31h1
        svn export https://svn.hirlam.org/branches/harmonie-31h1 harmonie             # for the stable branch 31h1
```
[ If you can't reach hirlam.org from the machine you want to build HARMONIE on, you'll have to do this on another machine and tar the result and copy it to the build machine]

Get the GMKPACK utilities from the HARMONIE source code repository, i.e., in $HOME, perform the following:
```bash
        cp -R <harmonie-repository-root>/harmonie/util/gmkpack .
```
Export the following environment variables or add them to ~/.bash_profile:
```bash
        export GMKROOT=$HOME/gmkpack
        export ROOTPACK=$HOME/HARMONIE
        export HOMEPACK=$ROOTPACK
        export HOMEBIN=$HOMEPACK
        export GMKFILE=GFORTRAN.LINUX
        export GMKTMP=/tmp
        export PATH=$GMKROOT/util:$PATH
        export MANPATH=$MANPATH:$GMKROOT/man
```
Then run build_gmkpack in directory gmkpack.

Create the directory for the new pack:
```bash
        mkdir $ROOTPACK
```
Then run gmkpack in that directory:
```bash
        cd $ROOTPACK
        gmkpack -r 31h1 -a -p arome                  # 31h1 here refers to the source code cycle number 
```
This creates the subdirectory 31h1_main.01.420.

Go to directory 31h1_main.01.420./src/local and copy the HARMONIE sources to it.
```bash
        cp -R <harmonie-repository-root>/harmonie/src/. .
```
Then run the compile script from the 31h1_main.01.420. directory:
```bash
        ./ics_arome
```
If the version of flex installed on your system is newer than 2.5.4, the build will abort because of a bug in flex.

Go to directory sys/odb98 and change lex.yy.c so that the defines
```bash
        #define INITIAL 0
        #define LEX_NORMAL 1
        #define LEX_INCLUDE 2
        #define LEX_SET 3
        #define LEX_TYPE 4
        #define LEX_TABLE 5
        #define LEX_VIEW 6
        #define LEX_FROM 7
        #define LEX_ORDERBY 8
        #define LEX_EXCLUDED_BY_IFDEF 9
```
precede their uses.

Re-compile the lex.yy.c file:
```bash
        gcc -g -c -I. -I../../src/local/odb/compiler lex.yy.c
```
This is a bug, confirmed by the flex maintainers (http://flex.sourceforge.net).

There are two violations of the Fortran Standard in the sources:

        src/local/mpa/micro/internals/ini_rain_ice.mnh

and

        src/local/mpa/micro/internals/budget.mnh

in both cases, comment out the declaration of integer variable ILUOUT0.

Recompile by by running the compile script from the 31h1_main.01.420. directory:
```bash
        ./ics_arome
```
This completes the build of the main 31h1 cycle.

### Derived pack and make local changes

Now create a derived pack so that you can add local updates:

Start by creating a separate directory in your home directory (here chosen to be "ARO"):
```bash
         mkdir AROME
         cd AROME
```
Then, reflect this derived pack in your exported environment variables:
```bash
         export HOMEPACK=$HOME/AROME
         export HOMEBIN=$HOMEPACK
```
Enter the HOMEPACK directory:
```bash
         cd $HOMEPACK
```
and create the derived pack (identified by the string "EXP"):
```bash
         gmkpack -r 31h1 -u EXP -p arome
```
Go to this derived pack's directory:
```bash
         cd $HOMEPACK/EXP
```
and copy the HARMONIE scripts:
```bash
         cp -R <harmonie-repository-root>/harmonie/scr .
```

### Additional local changes for cycle 31h1

For code in cycle 31h1, we have to update a few source files because they lead to Segmentation Violations (two because of errors in the source code, one because of a compiler error):
```bash
          cp ~/HARMONIE/31h1_main.01.420./src/local/arp/utility/echien.F90 ./src/local/arp/utility/
          cp ~/HARMONIE/31h1_main.01.420./src/local/arp/pp_obs/openfpfa.F90 ./src/local/arp/pp_obs/
```
In those files, add a logical variable LDGARDS, set it to .FALSE. and change the last argument to subroutine FACIES to LDGARDS.

The following is filed as a [bug report](http://gcc.gnu.org/PR33298). As the report indicates, this has been fixed as of 2007/09/06.  If your compiler is of this date or later (see gfortran -v), you don't have to perform this update:

In the following file:
```bash
          cp ~/HARMONIE/31h1_main.01.420./src/local/mse/internals/soil_albedo_1d_patch.mnh ./src/local/mse/internals/
```
change the following lines:
```bash
CASE ('DRY ')
  PALBVIS_SOIL(:,:) = SPREAD(PALBVIS_DRY(:),2,IPATCH)
  PALBNIR_SOIL(:,:) = SPREAD(PALBNIR_DRY(:),2,IPATCH)
  PALBUV_SOIL (:,:) = SPREAD(PALBUV_DRY (:),2,IPATCH)
```
into:
```bash
CASE ('DRY ')
  DO JPATCH = 1, IPATCH
     PALBVIS_SOIL(:,JPATCH) = PALBVIS_DRY(:)
     PALBNIR_SOIL(:,JPATCH) = PALBNIR_DRY(:)
     PALBUV_SOIL (:,JPATCH) = PALBUV_DRY (:)
  ENDDO
```
Filed as a [bug report](http://gcc.gnu.org/PR33298). As the report indicates, this has been fixed as of 2007/09/06.

Go back to the derived pack's directory and build the derived AROME executable.
```bash
          ./ics_arome
```
You will see the three updated routines being recompiled and added to their respective libraries.

### Prepare scripts

Now change two scripts you definitely have to change (Env_expdesc, because it describes your experiment and Climate and ExtractBD, because the original scripts assumes the original (non-interpolated) climate data and boundary files reside on ECFS at ECMWF [change ecp to cp]):

[ This assumes you have accumulated all HARMONIE climate data residing at ec:/rmt/clim_database in a equal tree of plain files.]
```bash
          cd scr
          edit Env_expdesc Climate ExtractBD
```
In Env_expdesc, at least change the following:
```bash
TSTEP=60                                # Time step
MODEL=AROME                             # Forecast model to execute
                                        # ALADIN,AROME,ALDODB,AROMODB

FLAG="arome"                            # Model/NH flag for finding right namelist etc
HOST_MODEL="hir"                        # Host model, could be hir,ifs,ald
TRGT_MODEL="aro"                        # Target model, could be ald,aro
```
and set the domain of your choice.

Now unpack your climate data so that it resides under the directory indicated in Env_expdesc (environment variable CLIMDATA) (we can actually not use it yet, because some steps in the climate file generation currently have to be executed at ECMWF).

### Build additional utilities

Prepare the source for the HARMONIE conversion utilities:
```bash
          mkdir util
          cd util
          cp -R <harmonie-repository-root>/harmonie/util/gl  .
```
and build them:
```bash
          cd ../util/gl
```
Change the ARCH variable in the Makefile to linuxgfortran.

Then repair this error:
```bash
.../prg/gl.F90:75: undefined reference to `iargc_'
.../prg/gl.F90:84: undefined reference to `getarg_'
```
iargc and getarg are *not* external functions, they are (non-standard) intrinsics (remove their declarations).

And this one
```bash
.../prg/dumpfld.f90:52/3/4: Error: Nonnegative width required in format string at (1)
```
by changing the format specification to fmt=*.

Then issue the make command:
```bash
          make
```
[ You can clean up if something goes wrong by typing "make clean".]

## Install namelists

Subsequently, we copy the namelists from the HARMONIE repository to $HOMEPACK:
```bash
          cp -R <harmonie-repository-root>/harmonie/nam .
```
Now, unfortunately, the run scripts assume that the experiment name (environment variable MYLIB) is test_31h1.  Therefore, in the $HOMEPACK directory we make a soft link:
```bash
          ln -s EXP test_31h1
```
This is also the reason why you have to make soft links for all namelists in the nam directory with "31t1" in it to use "31h1", e.g.
```bash
          ln -s namelist_31t1_ald2ald_nh_default namelist_31h1_ald2ald_nh_default
          ...
```
and change LMPOFF to .TRUE. in namelist_31h1_fcstarome_default [don't you love negative logic].

## Climate Files

Now create the climate files for the intermediate and final model domain on ECMWF.  A good choice for the intermediate grid is to use the same center as the high resolution grid and a resolution 4 times as coarse and with 1/3rd the number of grid points in the X and Y directory.  In this way you will be sure that the high resolution domain is completely contained in the intermediate one.  Of course you also have to ensure that the intermediate grid is completely contained inside the HIRLAM domain you derive the boundaries from.

## Prepare the input data 

First, make a scratch directory, for instance in the $HOME directory, and let the environment variable $TEMP point to it:
```bash
          mkdir $HOME/scratch
          export TEMP=$HOME/scratch
```
Make a directory for the intermediate climate files and copy them there:
```bash
          mkdir -p $TEMP/HARMONIE/RCRa/climate
          for m in 01 02 03 04 05 06 07 08 09 10 11 12
          do
             cp <intermediate-climate-dir>/m$m $TEMP/HARMONIE/RCRa/climate
          done
```
Make a directory for the high resolution climate files and copy them there:
```bash
          mkdir -p $TEMP/HARMONIE/test_31h1/climate
          for m in 01 02 03 04 05 06 07 08 09 10 11 12
          do
             cp <highres-climate-dir>/m$m $TEMP/HARMONIE/test_31h1/climate
          done
          cp <highres-climate-dir>/PGD.lfi $TEMP/HARMONIE/test_31h1/climate
```
Make a directory for the HIRLAM history files to use as boundaries for your HARMONIE run:
```bash
          mkdir -p $TEMP/HARMONIE/RCRa/archive
          for fp in 000 003 006 009 012 015 018 021 024
          do
             cp fcYYYYMMDD_HH+$fp $TEMP/HARMONIE/RCRa/archive
          done
```
[ Note that this assumes that you have changed ExtractBD ($HOST_MODEL=hir) to copy them from there, instead of ecp -o them from ECFS:
```bash
          ...
          cp $TEMP/HARMONIE/RCRa/archive/$FILE .
          ...
```
]

## Get the binaries in place

Go to $HOMEPACK/EXP/scr.

Copy the AROME binary to the scratch tree:
```bash
          mkdir -p $TEMP/HARMONIE/test_31h1/bin
          cp ../bin/AROME $TEMP/HARMONIE/test_31h1/bin
```
Also copy the gl utilities over there:
```bash
          cp ../util/gl/bin/* $TEMP/HARMONIE/test_31h1/bin
```
Finally, steal a mandtg from a HIRLAM repository you have lying around:
```bash
          cp <HIRLAM-repository>/scripts/mandtg $TEMP/HARMONIE/test_31h1/bin
```

## Running the created AROME

Set the start and end date for which you have input data in the script Start_harmonie and run it:
```bash
          ./Start_harmonie
```



----


