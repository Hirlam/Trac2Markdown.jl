```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/PreqSoft?action=edit"
```
# Software Prerequisites
A recent Linux distribution, which implies with regards to the system software:
## Compilers
* gcc/gfortran 4.4 or newer.
* flex and bison (compiler utility software).
## System Libraries
* BLAS and LAPACK.
## System Software
* Parallel processing
  - MPI (preferably OpenMPI 1.4 or newer).
* Shells and other interpreters
  - bash and ksh.
  - Perl and PerlTK (for mXCdp).
## User Libraries
GRIB API 1.9.9 or newer. Obtain from ECMWF:
```bash
http://ecmwf.int/products/data/software/grib_api.html
```
Ungzip and untar the gzip'd tar file, and
```bash
cd grib_api-1.9.9
./configure --prefix# $HOME/grib_api --with-ifs-samples$HOME/grib_api/share/samples --disable-jpeg
make
make install
```
This will install the GRIB API library into $HOME/grib_api/lib, where the Linux configuration expects it.