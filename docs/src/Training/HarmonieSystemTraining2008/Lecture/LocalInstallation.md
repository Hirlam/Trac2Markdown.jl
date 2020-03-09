```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/LocalInstallation?action=edit"
```
# Harmonie System Training

## Build HARMONIE ROOTPACK on non-ECMWF platforms

### Compiler version

If you are using the [GNU compiler system](http://gcc.gnu.org/), make sure you have gfortran 4.3 or higher. You can find a binary for a 32 bit Intel Linux system at [The installation instructions are at [http://gcc.gnu.org/wiki/GFortranBinaries32Linux](http://quatramaran.ens.fr/~coudert/gfortran/gfortran-i686-linux.tar.bz2].).

### BLAS and LAPACK libraries

You need [BLAS and LAPACK-lite](http://netlib.org/) libraries.

If they are already on your system, verify they have been made with the correct compiler, or rebuild them.

First build BLAS (untarring blas.tgz places it in the BLAS directory). Go to that directory, and edit make.inc to set the compiler and linker to 'gfortran'. Then type 'make'.

Subsequenty, for LAPACK, after untarring lapack-lite-3.1.1.tgz, go to the lapack-lite-3.1.1 directory.

Copy make.inc.example to make.inc.
Edit make.inc to point to the proper compiler/loader (gfortran) and to put the variable PLAT to the empty string. Set TIMER to INT_ETIME.

Copy the blas.a library from the BLAS directory to the lapack-lite-3.1.1 directory, run ranlib on it, then type 'make'.

Then put the libraries in $HOME/auxlibs with names libblas.a and liblapack.a, respectively, else the default configuration will not find them. Run ranlib on them.

### Auxiliary libraries

Next, you need a set of auxiliary libraries
[Auxiliary libraries](http://moene.indiv.nluug.nl/~toon/auxlibs_installer.1.3.tgz).

They will untar in the directory auxlibs_installer.1.3. There you'll find the following directories:
 * bufr_000350
 * dummies_001
 * eclite_001
 * gribex_000350
 * rgb_001

In each of these directories, run the script ./build_library.  You'll have to answer the following
questions:

 * Which compiler to use
 * Whether you want 64 bit reals (yes)
 * Where to store the library on completion of the build (choose a subdirectory of your home directory
   where you have write permission - note: full path; the GFORTRAN.LINUX configuration assumes these
   libraries are in $HOME/auxlibs and include files in $HOME/auxinclude)

After build_library finishes, run ./install - this will put the library in the directory you've chosen above.

### Get the HARMONIE sources and scripts

Use 'svn export' in a convenient directory 'dir':
```bash
svn export https://user@svn.hirlam.org/tags/harmonie-33h1
```
where 'user' is your user name at hirlam.org. Below, the location of this export of the repository <full_path_to_dir>/harmonie-33h1 is referred to PATH_TO_HARMONIE.

### Create an experiment

Subsequently, create your experiment directory in your home directory:
```bash
mkdir -p hm_home/EXP
```
Perform experiment setup:
```bash
cd hm_home/EXP
PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h LinuxPC # or any other -h <host>
```
Then, in config-sh/config.LinuxPC point SCRATCH to your scratch directory.

Your auxiliary libraries are expected to be in $HOME/auxlibs, with their
associated include files in $HOME/auxinclude.

### Your domain and other settings

In sms/config_exp.h:

Define your domain or choose one of the existing ones.

If you want to run AROME inside a HIRLAM boundary/start file setup:
```bash
# **** Nesting settings ****
HOST_MODEL="hir"                        # Host model (hir|ifs|ald)
TRGT_MODEL="aro"                        # Target model (ald|aro)
```
Climate files are best pre-created at ECMWF:
```bash
# **** Climate files ****
CREATE_CLIMATE=no                       # Run climate generation (yes|no)
```

### Flex problem

Release 33h1 of HARMONIE still has problems with most versions of flex installed on modern Linux systems. Download [http://prdownloads.sourceforge.net/flex/flex-2.5.4a.tar.bz2?download] and then:
```bash
tar jxf flex-2.5.4a.tar.bz2
cd flex-2.5.4a
./configure
make
```
and then move the resulting 'flex' binary to a directory in the beginning of your PATH environment variable.

### Create rootpack

Then create the root pack by performing the following:
```bash
PATH_TO_HARMONIE/config-sh/Harmonie install
```

## Prepare for running an experiment

### Work around for bug in namelist reading

Create a scr subdirectory in your experiment directory. Copy PATH_TO_HARMONIE/scr/hir2aro and PATH_TO_HARMONIE/scr/Prep_ini_surfex scripts from the repository to that directory.

Change the creation of the 'naminterp' namelist in your copy of hir2aro as follows:
```bash
echo " &NAMINTERP" > naminterp

if [ "$VLEV" != BOUNDARIES ] ; then
 echo OUTGEO%NLEV=$( perl -S Vertical_levels.pl $VLEV NLEV ) "," >> naminterp
 echo AHALF=$( perl -S Vertical_levels.pl $VLEV AHALF ) >> naminterp
 echo BHALF=$( perl -S Vertical_levels.pl $VLEV BHALF ) >> naminterp
fi

cat << EOF >> naminterp
   atmkey = 76,0,0,'LIQUID_WATER',
            58,0,0,'SOLID_WATER',
            62,0,0,'SNOW',
            79,0,0,'RAIN',
EOF

echo ' /' >> naminterp
```
and for your copy of Prep_ini_surfex as follows:
```bash
echo " &NAMINTERP" > naminterp

 echo OUTGEO%NLEV=$( perl -S Vertical_levels.pl $PREP_VLEV NLEV ) "," >> naminterp
 echo AHALF=$( perl -S Vertical_levels.pl $PREP_VLEV AHALF ) >> naminterp
 echo BHALF=$( perl -S Vertical_levels.pl $PREP_VLEV BHALF ) >> naminterp

cat << EOF >> naminterp
   atmkey = 76,0,0,'LIQUID_WATER',
            58,0,0,'SOLID_WATER',
            62,0,0,'SNOW',
            79,0,0,'RAIN',
EOF

echo ' /' >> naminterp
```
The resolution of this gfortran bug can be tracked here: [http://gcc.gnu.org/PR37707].

### Adapt namelists for running HARMONIE without MPI

The standard namelists in the repository assume that HARMONIE will be run in parallel using MPI. We do not do that, so we have to adapt the namelists.

Copy the following namelists from the repository PATH_TO_HARMONIE/nam:
```bash
namelist_ald2arome_0_default
namelist_ald2arome_N_default
namelist_ald2arome_s_default
namelist_fcstarome_default
namelist_pparome_default
```
to the nam subdirectory of your experiment directory.

Now edit these files so that the NAMPAR0 namelist contains the line:
```bash
LMPOFF=.TRUE.,
```
Add to sms/config_exp.h in your experiment directory where your climate files, observations and boundaries are found, e.g.:
```bash
BDDIR=$HOME/hir-bnd                     # Boundary file directory
...
CLIMDIR=$HOME/clim-harm50               # Climate files directory
BDCLIM=$HOME/clim-inter                 # Boundary climate files (ald2ald,ald2aro)
...
OBDIR=$HOME/observations                # Observation file directory
```

## Run the experiment

Then start the run (don't use DR HOOK for tracebacks, the compiler's are much more precise):
```bash
ulimit -s unlimited

export DR_HOOK_IGNORE_SIGNALS=-1

PATH_TO_HARMONIE/config-sh/Harmonie start DTG=2006120112
```

## Known problems
 * It is currently not possible to run full climate generation locally as long as SURFEX is involved. Do it at ECMWF in advance.
## [Hands on practice task] (../../../HarmonieSystemTraining2008/Training/LocalInstallation.md)
## *Questions & issues related to the current topics* 
 * The installation of additional softwares (auxlibs, blas, lapack) are a bit complicated, but it might be difficult to write a script wrapper for such things due to platform diversity
 
## Reference links

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)