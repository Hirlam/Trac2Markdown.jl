```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2016/EPyGrAM?action=edit"
```

# EPyGrAM
## General
 * [https://opensource.cnrm-game-meteo.fr/projects/epygram](https://opensource.cnrm-game-meteo.fr/projects/epygram): EPyGram wiki
 * [https://opensource.cnrm-game-meteo.fr/projects/epygram/wiki/Vortex_packages](https://opensource.cnrm-game-meteo.fr/projects/epygram/wiki/Vortex_packages): Vortex information

## Using EPyGrAM at ecgate
  * Set up EPyGrAM configuration:
```bash
cd $HOME
mkdir .epygram
cp ~dui/.epygram/* .epygram
```

  * Set up Vortex and EPyGrAM environment information by adding the following lines to the end of $HOME/.user_bashrc:
```bash
# EPyGram

# Vortex & Footprints
VORTEX_INSTALL_DIR=/home/ms/ie/dui/EPyGrAM/vortex-1.0.0
export PYTHONPATH=$PYTHONPATH:$VORTEX_INSTALL_DIR
export PYTHONPATH=$PYTHONPATH:$VORTEX_INSTALL_DIR/src
export PYTHONPATH=$PYTHONPATH:$VORTEX_INSTALL_DIR/site

# EPyGrAM
EPYGRAM_INSTALL_DIR=/home/ms/ie/dui/EPyGrAM/EPyGrAM-1.2.1
export PYTHONPATH=$PYTHONPATH:$EPYGRAM_INSTALL_DIR
export PYTHONPATH=$PYTHONPATH:$EPYGRAM_INSTALL_DIR/site
export PATH=$PATH:$EPYGRAM_INSTALL_DIR/apptools
export GRIB_SAMPLES_PATH=$GRIB_SAMPLES_PATH:$EPYGRAM_INSTALL_DIR/epygram/data
```

  * Open a new xterm or source $HOME/.user_bashrc 
  * Test:
```bash
epy_plot.py -f shortName:t,level:801 /home/ms/ie/dui/EPyGrAM/fc2005010218+003grib_sfx
epy_section.py -f shortName:t,typeOfLevel:heightAboveGround -s'-8,53' -e'-7,53'
/home/ms/ie/dui/EPyGrAM/fc2005010218+003grib_sfx
domain_maker.py
```

## Build shared libraries for EPyGrAM

This is an example how to build the required libs4py.so using gfortran. An example how to auto generate dummies can be found in Create_dummies, attached.

Make sure you have [15510](https://hirlam.org/trac/changeset/15510) and the patches for the interface.

```bash
#!/bin/bash

LIBS="\
/usr/lib64/libgrib_api_f90.so \
/usr/lib64/libgrib_api.so \
"


mkdir -p shared
cd shared
rm -f *.o

DIR=../makeup.redhat70.gfortran482.nompi/src

for L in ifsaux trans etrans arpifs biper algor mpi_serial gribex ;  do

 D=$DIR/lib$L.a
 ar -x $D
 gfortran -shared -o lib$L.so  *.o  

done

gcc -fpic -c ../dummies.c

set -x
gfortran -shared -o ../libs4py.so dummies.o  -Wl,-rpath=$PWD *.so $LIBS -fopenmp
```
