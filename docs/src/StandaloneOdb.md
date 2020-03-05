# ODB software
## Get the software
To make best use of ODB information produced by your Harmonie experiment one should use ODB and ODB-API software developed by ECMWF. Below are instruction on how to obtain the software from ECMWF.
### ODB-API
ODB-API software is open source and released under an Apache licence. In the future the ODB Confluence page [https://software.ecmwf.int/wiki/display/ODB/ODB+Home](https://software.ecmwf.int/wiki/display/ODB/ODB+Home) will be open to the public and everybody will be allowed to download ODB-API source code from it and use it. Until then, ECMWF have said they are happy to give access to the page on case by case basis to interested member states/HIRLAM partners, so they have always access to the latest releases and release notes. Requesting access to ODB API from Data Services is not necessary.

An e-mail should be sent to your ECMWF User Support contact to request access to the ODB-API Confluence page stating that you are working at an HIRLAM NMS and are using ODB data with your Harmonie experiments. 

### ODB
''ODB stands for Observational !DataBase. It is database software to store and retrieve large amounts of meteorological numerical data in an efficient manner while used from within IFS. ODB software mimics relational database queries through its ODB/SQL -compiler and accesses data currently via a Fortran90 library interface.'' The original documentation is available here: [http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf](http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf)

ODB software is made available to member states under a stricter license and must be requested from Data Services at ECMWF. It might be best for your ECMWF Computer Representative to make this request on behalf of your institute. This request may take some time to be processed. The request (one per institute) can be made by e-mail to (data.services@ecmwf.int) with the following information:
```bash
Dear Data Services,

I would like to request a licence for the use of the following software packages:
 * ODB
 * OBSTAT

--- My organization
Name:
Registered Address:

--- Details of the person authorized to sign the licence on behalf of the organization
Name:
Title:
e-mail:
```
 * After some time your ''person authorized to sign the licence on behalf of the organization'' will receive a software license agreement to be signed and returned to ECMWF.
 * ....

## Building your ODB software
Both ODB and ODB-API use cmake [http://www.cmake.org](http://www.cmake.org) to configure the makefiles used to compile the software. You may have to build your own (more up to date) copy of cmake depending on your PC operating system.

### ODB
Instructions on how to build ODB:
 * Get ODB software once ECMWF have provided your institute with a software license from [https://software.ecmwf.int/wiki/display/ODB/Legacy+Releases](https://software.ecmwf.int/wiki/display/ODB/Legacy+Releases)
```bash
cd $HOME
mkdir odb_releases
cp Odb-1.0.0-Source.tar.gz odb_releases/
cd odb_releases
gunzip Odb-1.0.0-Source.tar.gz
tar -xvf Odb-1.0.0-Source.tar
cd Odb-1.0.0-Source
```
 * Now draft a configuration script, **config.metie.sh**, that uses cmake. Here is my example sample script:
```bash
#!/bin/ksh
alias cmake='/usr/local/cmake-2.8.9/bin/cmake'
source_dir=$HOME/odb_releases/Odb-1.0.0-Source
build_type=Production
install_prefix=/opt/metlib/odb/`cat $source_dir/VERSION.cmake | awk '{print $2}' | sed 's/["]//g' | sed 's/[)]//g'`/gnu
echo "prefix=$install_prefix"

cmake $source_dir \
    -DCMAKE_BUILD_TYPE=$build_type \
    -DCMAKE_INSTALL_PREFIX=$install_prefix \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_C_FLAGS="-g -fPIC -DLINUX -DINTEGER_IS_INT" \
    -DCMAKE_C_FLAGS_DEBUG="-O0" \
    -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG" \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_CXX_FLAGS="-g -fPIC" \
    -DCMAKE_CXX_FLAGS_DEBUG="-O0" \
    -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG" \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DCMAKE_Fortran_FLAGS="-fconvert=big-endian -fdefault-real-8 -fPIC -DLINUX" \
    -DCMAKE_Fortran_FLAGS_DEBUG="-g -O0" \
    -DCMAKE_Fortran_FLAGS_RELEASE="-O2" \
    -DODB_API_TOOLS=OFF \
    -DNETCDF_PATH=/opt/metlib/netcdf/4.1.3/gnu $@
```
 * No let's compile! (You should be in $HOME/odb_releases/Odb-1.0.0-Source)
```bash
mkdir build
cd build
../config.metie.sh
make
make install  ## you may have to log in as root to carry out the final install
```

### ODB-API
Instructions on how to build ODB-API:
 * Download the latest version of ODB-API from [https://software.ecmwf.int/wiki/display/ODB/Releases](https://software.ecmwf.int/wiki/display/ODB/Releases)
```bash
cd $HOME
mkdir -p odb_releases
cp OdbAPI-0.9.31-Source.tar.gz odb_releases/
cd odb_releases/
gunzip OdbAPI-0.9.31-Source.tar.gz
tar -xvf OdbAPI-0.9.31-Source.tar
cd OdbAPI-0.9.31-Source
```
 * Now draft a configuration script, **config.metie.sh**, that uses cmake. Here is my example that I place in OdbAPI-0.9.31-Source
```bash
#!/bin/sh
# This is an Irish template of a script for building ODB API. See instructions in file INSTALL.
# Please edit values of the cmake options or delete them.

export ODB_ROOT=/opt/metlib/odb/1.0.0/gnu
. /opt/metlib/odb/1.0.0/gnu/bin/use_odb.sh

alias cmake='/usr/local/cmake-2.8.9/bin/cmake'
source_dir=$HOME/odb_releases/OdbAPI-0.9.31-Source
build_type=Production
install_prefix=/opt/metlib/odb_api/`cat $source_dir/VERSION.cmake | awk '{print $3}' | sed 's/["]//g' | sed 's/[)]//g'`/gnu

echo "INSTALL = $install_prefix"
echo "BUILD   = `basename $(pwd) | sed 's/\W[a-zA-Z0-9]*//'`"
echo "ODB_ROOT= $ODB_ROOT"
echo 

cmake $source_dir \
    -DCMAKE_BUILD_TYPE=$build_type \
    -DCMAKE_PREFIX_PATH=/usr/local/python-2.7.2 \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DLIBGFORTRAN_PATH=/usr/lib/gcc/x86_64-redhat-linux/4.4.7 \
    -DCMAKE_MODULE_PATH=$source_dir/ecbuild/cmake \
    -DCMAKE_INSTALL_PREFIX=$install_prefix \
    -DODB_PATH=/opt/metlib/odb/1.0.0/gnu \
    -DECLIB_SOURCE=$source_dir/eclib \
    -DBUILD_SHARED_LIBS=ON \
    -DODB_API_MIGRATOR=ON \
    -DODB_API_FORTRAN=ON \
    -DODB_API_PYTHON=OFF \
    -DBISON_EXECUTABLE=/usr/bin/bison \
    -DSWIG_EXECUTABLE=/usr/bin/swig
```
 * Now let's compile! (You should be in $HOME/odb_releases/OdbAPI-0.9.31-Source)
```bash
mkdir build
cd build
../config.metie.sh
make
make install  ## you may have to log in as root to carry out the final install
```
# ODB data
## Convert ODB-1 to ODB-2
Details on how to convert your ODB-1 (Harmonie experiment) databases to ODB-2 using odb_migrator are described here. I have used version 0.9.31 of ODB-API (I have had some problems with 0.9.32). I will use a Harmonie CCMA conventional ODB-1 database as an example:
```bash
tar -xvf odb_ccma.tar
cd odb_ccma/CCMA/
dcagen
cd ../../
ls -l ../conv.38h1.sql
which odb_migrator
/opt/metlib/odb_api/0.9.31/gnu/bin/odb_migrator -addcolumns "expver='    38h1',class=2,stream=1025,type=264" odb_ccma/CCMA ../conv.38h1.sql var${DTG}.odb
ls -l var${DTG}.odb
```
Here is the SQL file used: [conv.38h1.sql](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/StandaloneOdb/conv.38h1.sql). To construct my conv.38h1.sql file did carried out the following commands:
```bash
cd odb_ccma/CCMA/
odbsql -q "select * from desc,timeslot_index,hdr,body" | head -1 
```

## Instructions for use on ecgb
On ecgb I have installed ''odb_migrator'' in my own account. ODB developers have promise to provide a "system" installation of odb_migrator soon. The next version of ODB-API on ecgb should include ''odb_migrator''. My installation is here:
```bash
/home/ms/ie/dui/odbapi/0.9.31
```

To produce your own ODB-2 file from a Harmonie CCMA tar ball on ecgb:

```bash
module load odb
export PATH=/home/ms/ie/dui/odbapi/0.9.31/bin:$PATH
export LD_LIBRARY_PATH=/home/ms/ie/dui/odbapi/0.9.31/lib:$LD_LIBRARY_PATH
cd $SCRATCH
mkdir ODB2odb
cd ODB2odb
## copy your odb_stuff.tar/odb_ccma.tar file from ECFS/your home system to this directory
## eg -- ecp ec:/dui/harmonie/refSonde38h1p1/2013/12/27/00/odb_stuff.tar .
tar -xvf odb_stuff.tar
tar -xvf odb_ccma.tar
cd odb_ccma/CCMA/
dcagen
cd ../../
odb_migrator odb_ccma/CCMA -addcolumns "expver='refSonde',class=2,stream=1025,type=264" /home/ms/ie/dui/odbapi/conv.38h1.sql conv2013122700.odb
odb header conv2013122700.odb
odb sql 'select distinct varno' -i conv2013122700.odb
odb sql 'select count(*) where varno=2' -i conv2013122700.odb
#
rm -f bdstrategy odb*.tar ## tidy up the directory if you wish
rm -rf odb_ccma
```

# ODB visualisation
ODB-2 data can be visualized (directly) using Metview. On local platforms Metview must be built with ODB support (that uses ODB-API software) to visualize ODB-2 data. Here is an example, odbmap.mv4, of using Metview on ecagte to visualize ODB-2 data using a Metview Macro. This example requires an ODB-2 data file as input. Optionally this macro can also plot domain grid-points from a Harmonie GRIB file (called dom.grib) to indicate the extent of your Harmonie model domain.
 * Usage:
```bash
 odbmap:: Usage: metview -b odbmap.mv4 inputfile odbvar odbrequest odblegend outputtype
 odbmap::   where: inputfile  -- ODB-2 file
 odbmap::   where: odbvar     -- ODB variable to be plotted
 odbmap::                     -- (enclosed with inverted commas)
 odbmap::   where: odbrequest -- ODB SQL request 
 odbmap::                     -- (enclosed with inverted commas)
 odbmap::   where: odblegend  -- legon/legoff
 odbmap::   where: outputtype -- ps/png
```
 * An example to plot 2m temperature observation values on 25th December 2013 at 12z:
```bash
cd  $SCRATCH
cp -r /home/ms/ie/dui/odbMacroTest .
cd odbMacroTest
metview4 -b odbmap.mv4 conv201312.odb "obsvalue" "andate=20131225 and antime=120000 and varno=39" legon png
xv odbmap.1.png
```
