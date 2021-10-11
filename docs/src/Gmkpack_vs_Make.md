```@meta
EditURL="https://hirlam.org/trac//wiki//Gmkpack_vs_Make?action=edit"
```
## GMKPACK vs. Make

The HARMONIE system, like the ARPEGE/ALADIN/AROME system, uses the (set of scripts) GMKPACK to build the libraries and binaries.

GMKPACK builds a script "ics_arome" that performs the following steps, using scripts from the "aux" directory:

 1. Establishes an order in the "projects" (in fact, the subdirectories of the src/local directory) using the file conf/projects.
 1. Constructs interface block header files for the ald and arp directories:
```bash
Auto-generated explicit interface blocks on projects ald arp ...
file=ald/adiab/elarche.F90 dir=local/.intfb/ald elarche.intfb.h : no-changes
file=ald/adiab/elarmes.F90 dir=local/.intfb/ald elarmes.intfb.h : no-changes
```
 1. Generates a list of include paths:
```bash
Include/source paths ...
Include path :
-I/home/harmonie/pack/31h1_main.01.420./src/local/ald/module
-I/home/harmonie/pack/31h1_main.01.420./src/local/arp/module
```
 1. Builds a ordered list of source files to compile:
```bash
Ordered compilation list INCluding dependencies ...
Source descriptors for local view is trivial ...
Local view for modules ...
Check for duplicated modules ...
Sort all projects together ...
------ Level 1
local@xrd/module/parkind1.F90
------ Level 2
local@.intfb/arp/tridialcz.intfb.h
local@xrd/include/dr_hook_util.h
```
 1. Builds the precompilers odb98.x and bla95.x.
 1. Actually compiles the sources.
```bash
------ Start compilation --------------------------------------
----------- Level 1 / 250 ---------------------------------------
No recursive update:
Compile:
gfortran -c -fconvert=swap -ffree-form -DBLAS -DLINUX -DLITTLE_ENDIAN -DLITTLE -DHIGHRES -g -O2 -fbacktrace local/xrd/module/parkind1.F90
```
 1. Then it builds the libraries.
```bash
------ Make libraries -----------------------------------------------

ar: creating /home/harmonie/pack/31h1_main.01.420./lib/libsur.local.a
a - ./surfexcdriversad.o
```
 1. Subsequently, it builds the single executable (AROME):
```bash
========= Linking binary AROME =========

Top libraries actually used :
lib[01].a="/home/harmonie/pack/31h1_main.01.420./lib/libald.local.a"
...
scanning lib[12].a ...

gfortran -g -fbacktrace -Wl,--start-group ./master.o -L. -l[1] -l[2] -l[3] -l[4] -l[5] -l[6] -l[7] -l[8] -l[9] -l[10] -l[11] -l[12] -Wl,--end-group -L/home/harmonie/auxlibs -lecR64 -lgribexR64 -lfdbdummy_000_gnuR64 -lwamdummy_000_gnuR64 -lnaglitedummy_000_gnuR64 -loasisdummy_000_gnuR64 -llapack -lblas -L/home/harmonie/auxlibs -lmpidummy_000_gnuR64 -libmdummy_000_gnuR64
```

To construct a make file, we have to use the outcome of steps 1 - 4.

Issues with gmkpack:

 1. Hard to understand logic.
 1. Slow, especially because the handling of the dependencies is done in scripts.
 1. Not clear how to compile in parallel, unless on an MPI capable system.

## USING FCM TO BUILD HARMONIE

Instead of gmkpack, we could try to use [fcm (Flexible Configuration Management)](http://www.metoffice.gov.uk/research/nwp/external/fcm/).

 1. Create a new directory for this build.
 1. Change directory to the top of this build tree.
 1. Add the fcm/bin directory to your PATH (where ever it is based).
 1. Make a copy of the repository checkout's src directory:
```bash
cp -R /home/harmonie/harmonie/src .
```
 1. Delete the following subdirectories:
```bash
rm -rf src/bla/compiler src/odb/y2k.obsolete src/odb/bufrbase src/odb/examples src/odb/prescreen
```
 1. Make the MESO-NH sources (.mnh files) available to fcm by giving them a .f90 extension:
```bash
for f in `find . -name '*.mnh' -print`
do
   d=`dirname $f`
   b=`basename $f .mnh`
   (cd $d; ln -s $b.mnh $b.f90)
done
```
 1. Go to the odb compiler's directory and pre-build the lexical analyzer and parser (actually, fcm should be able to generate rules for this):
```bash
cd src/odb/compiler
flex -l lex.l
yacc -d yacc.y
```
 1. In the resulting file lex.yy.c, move the following definitions to before their first use (a bug in versions of flex newer than 2.5.4):
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
 1. Add the following prototype to odb98.c (it is necessary for odb98.c to be recognized as the source file for the main program of odb98.exe - probably a shortcoming in fcm):
```bash
int main(int, char**);
```
 1. Return to the root of the build directory tree:
```bash
cd ../../..
```
 1. Construct a Build Configuration file bld.cfg.
```bash
# This file is a build configuration

cfg::type  bld

# The root directory of this build

dir::root  $HOME/tmp

# The two target executables to be build

target     odb98.exe master.exe

# Their dependencies on the source directories

exe_dep::odb98.exe    odb
exe_dep::master.exe   ald  arp  bla  mpa  mse  odb  sat  sur  tal  tfl  uti  xrd

# Tools: the compilers

tool::fc   gfortran
tool::cc   gcc

# Tools: the compile time flags

tool::fflags -g -fconvert=swap -O2 -fdefault-real-8 -fdefault-double-8 -DLINUX -DLITTLE_ENDIAN -DLITLLE -DBLAS -DHIGHRES
tool::cflags -g -O2 -DLINUX -DLITTLE_ENDIAN -DLITTLE -DCANARI -DSTATIC_LINKING -DXPRIVATE=PRIVATE -UINTERCEPT_ALLOC -UUSE_ALLOCA_H

# Tools: the loader and the load flags

tool::ld   gfortran
tool::ldflags -g -z muldefs -L/home/harmonie/auxlibs -lecR64 -lgribexR64 -lfdbdummy_000_gnuR64 -lwamdummy_000_gnuR64 -lnaglitedummy_000_gnuR64 -loasisdummy_000_gnuR64 -llapack -lblas -L/home/harmonie/auxlibs -lmpidummy_000_gnuR64 -libmdummy_000_gnuR64

# The extension of include files for autogenerated interface blocks

outfile_ext::interface .intfb.h

# Don't consider this file when computing dependencies

excl_dep   h::mpif.h
```
 1. Start the Build:
```bash
fcm build
```
 1. It now needs the mpif.h file.  Add it to the inc directory, e.g., like this (alternatively, we could add -I/home/harmonie/auxinclude/mpidummy_000 to the fortran compile flags):
```bash
cp /home/harmonie/auxinclude/mpidummy_000/mpif.h inc/
```
 1. Unfortunately, the names for the "done" files of the interface block include files are not correct in the done directory (this is probably an error in fcm, although it could subtly be dependent on a mistake in the configuration file):
```bash
cd done
for f in *.intfb.h.pdone
do
   ln -s $f `basename $f .intfb.h.pdone`.intfb.done
done
cd ..
```
 1. In bld/odb!__aux.mk, add the following directory specification: $(SRCDIR0!__odb!__aux)/ in front of every mention of odbi_shared.c without a directory.  This is necessary because odbi_shared.c is an include file (but not recognized by fcm as such - hence it's not in the inc directory and cannot be found without a full path).  This is something fcm should be able to do right without human intervention.
 1. Equivalently, in bld/odb!__extras!__ec.mk add $(SRCDIR0!__odb!__extras!__ec)/ in front of every mention of julian_lib.c without a directory.  Idem for error.c.
 1. Equivalently, in bld/odb!__tools.mk add $(SRCDIR0!__odb!__tools)/ in front of every mention of odbi_direct_main.c without a directory.
 1. Restart the Build.
```bash
fcm build
```
 1. Results:
 1. Problems:
  * How to deal with the .mnh and .sql files (get processed by gmkpack/ics_arome in a special way).
  * How to deal with the different Fortran / C compile time flags for different subdirectories.
  * How to generate the link command like gmkpack does.