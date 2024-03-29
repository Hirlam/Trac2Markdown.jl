```@meta
EditURL="https://hirlam.org/trac//wiki//LocalInstall32?action=edit"
```


# Install Harmonie system on an independent platform

## Build HARMONIE from the HARMONIE repository
The following assumes you have a working GNU/Linux system with gfortran and gcc (version >= 4.3.0) in your PATH. You can obtain [binaries here](http://gcc.gnu.org/wiki/GFortranBinaries). Note also that the description below is valid for trunk version of the HARMONIE system around cycle 32t2. Please consult relevant updates in [wiki:HarmonieSystemDocumentation HARMONIE documentation for later cycles]
### Preparation
First you need some auxiliary libraries (attached to [this page](./CompileHarmonie.md)), provided by ECMWF and Meteo France. Create a directory $HOME/auxlibs and put the following files there:
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
        svn export https://svn.hirlam.org/tags/harmonie-32h2 harmonie                 # for the tagged version such as 32h2 (not released yet)
        svn export https://svn.hirlam.org/branches/harmonie-32h2 harmonie             # for the stable branch associated to a tagged verson such as 32h2
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
        gmkpack -r trunk0930 -a -p arome             # if you want to build on a snapshot of trunk version; or 
        gmkpack -r 32h2 -a -p arome                  # 32h2 here refers to the source code cycle number 
```
This creates the subdirectory 0930_main.01.430.x (first case) or 32h2_main.01.430.x (second case).

Go to the subdirectory, e.g., 32h2_main.01.430.x, and, under src/local, copy the HARMONIE sources to it.
```bash
        cp -R <harmonie-repository-root>/harmonie/src/. .
```
Remove two superfluous directories (they are not mentioned in gmkpack's list of "projects"):
```bash
        rm -rf obt scr
```
Then run the compile script from the 32h2_main.01.430.x directory:
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

Recompile by by running the compile script from the 32h2_main.01.430.x directory:
```bash
        ./ics_arome
```

There are two compilation problems:

        src/local/uti/combi/combi.F90

The routine "STAT" should be declared EXTERNAL (otherwise it might refer to the non-
standard "stat" intrinsic supported by many compilers).

and

        src/local/xrd/module/quad_emu.F90

REAL*16 is not supported by gfortran on AMD64.  Obviously, this module is never used
(otherwise, many more problems would have been reported), so we can just remove it.

Recompile by by running the compile script from the 32h2_main.01.430.x directory:
```bash
        ./ics_arome
```
This completes the build of the main HARMONIE system (trunk or 32h2 cycle in the example).

### Derived pack and make local changes

Now create a derived pack so that you can add local updates (identified by the string "localpack"):
```bash
         cd ..
         gmkpack -r 32h2 -u localpack -p arome
```
Here, we first repair an error in .../arp/module/surface_fields.F90 (i.e., copy the file from its location in the main directory to the one in 32h2_localpack.01.430.x/src/local/arp/module and edit):
```bash
Change:
   635    YD%REFVALI(:) = PDEFAULT
to:
   635    YD%REFVALI(:) = PDEFAULT(1:SIZE(YD%REFVALI))
```
This prevents an array bound overrun.

Then, go to this derived pack's directory and build the executable:
```bash
         cd 32h2_localpack.01.430.x
         ./ics_arome
```

### Build additional utilities

Prepare the source for the HARMONIE conversion utilities:
```bash
          mkdir util
          cd util
          cp -R <harmonie-repository-root>/harmonie/util/gl  .
```
and build them after changing the ARCH variable in the Makefile to linuxgfortran.
```bash
          cd gl
          make
```
Then repair these errors:
```bash
.../prg/gl.F90:75: undefined reference to `iargc_'
.../prg/gl.F90:84: undefined reference to `getarg_'
.../prg/get_max_ext.F90:42: undefined reference to `iargc_'
.../prg/get_max_ext.F90:43: undefined reference to `getarg_'
.../prg/get_max_ext.F90:44: undefined reference to `getarg_'
```
iargc and getarg are *not* external functions, they are (non-standard) intrinsics (remove their declarations).

And this one
```bash
.../prg/dumpfld.f90:52/3/4: Error: Nonnegative width required in format string at (1)
```
by changing the format specification '(I)' to fmt=*.

Then re-issue the make command:
```bash
          make
```
[ You can clean up if something goes wrong by typing "make clean".]

### Prepare scripts

Subsequently, copy the HARMONIE scripts to the 32h2_localpack.01.430.x directory:
```bash
         cd ../..
         cp -R <harmonie-repository-root>/harmonie/scr .
```
Now change three scripts you definitely have to change (Env_expdesc, because it describes your experiment and ExtractBD, because the original scripts assumes the original (non-interpolated) climate data and boundary files reside on ECFS at ECMWF [change ecp to cp]):
```bash
          cd scr
          edit Env_expdesc ExtractBD
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

## Install namelists

Subsequently, we copy the namelists from the HARMONIE repository to the 32h2_localpack.01.430.x directory:
```bash
          cd ..
          cp -R <harmonie-repository-root>/harmonie/nam .
```
Change LMPOFF to .TRUE. in the files namelist_fcstarome_default, namelist_ald2arome_0_default and namelist_ald2arome_N_default (namelist NAMPAR0) [don't you love negative logic].

Unfortunately, the run scripts assume that the experiment name (environment variable MYLIB) is test_32h2.  Therefore, in the $HOMEPACK directory we make a soft link:
```bash
          ln -s 32h2_localpack.01.430.x test_32h2
```

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
          mkdir -p $TEMP/HARMONIE/test_32h2/climate
          for m in 01 02 03 04 05 06 07 08 09 10 11 12
          do
             cp <highres-climate-dir>/m$m $TEMP/HARMONIE/test_32h2/climate
          done
          cp <highres-climate-dir>/PGD.lfi $TEMP/HARMONIE/test_32h2/climate
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

Go to $HOMEPACK/test_32h2/scr.

Copy the AROME binary to the scratch tree:
```bash
          mkdir -p $TEMP/HARMONIE/test_32h2/bin
          cp ../bin/AROME $TEMP/HARMONIE/test_32h2/bin
```
Also copy the gl utilities over there:
```bash
          cp ../util/gl/bin/* $TEMP/HARMONIE/test_32h2/bin
```
Finally, steal a mandtg from a HIRLAM repository you have lying around:
```bash
          cp <HIRLAM-repository>/scripts/mandtg $TEMP/HARMONIE/test_32h2/bin
```

## Running the created AROME

Set the start and end date for which you have input data in the script Start_harmonie and run it:
```bash
          ./Start_harmonie
```



----


