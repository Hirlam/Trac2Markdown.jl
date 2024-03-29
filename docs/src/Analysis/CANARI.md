```@meta
EditURL="https://hirlam.org/trac//wiki//Analysis/CANARI?action=edit"
```


# Surface Data Assimilation Scheme: Canari

## Introduction
(by Alena.Trojakova)

**CANARI** stands for **C**ode for the **A**nalysis **N**ecessary for **A**RPEGE for its **R**ejects and its **I**nitialization.
It is software (part of IFS/ARPEGE source code) to produce an ARPEGE/ALADIN analysis based on optimum interpolation method. The number of ARPEGE/ALADIN configuration is 701. CANARI has the two main components the quality control and an analysis. According to the type of observations the analysis can be:
 * 3D multivariate for U, V, T, Ps
 * 3D univariate for RH
 * 2D univariate for 2m/10m fields
 * soil parameters analysis is based on 2m increments

CANARI can handle following 10 types of observations:
 * SYNOP: Ps, T2m, RH2m, 10m Wind, RR, Snow depth, SST
 * AIREP: P ( or Z), Wind, T
 * SATOB: P, Wind, T - from geostationary satellite imagery
 * DRIBU: Ps, T2m, 10m Wind, SST
 * TEMP: P, Wind, T, Q
 * PILOT: Wind with the corresponding Z, (sometimes 10m Wind)
 * SATEM: Q, T retrieved from radiances- surface

## Applications

 * Diagpack - diagnostic of mesoscale features via detailed analysis of PBL using high resolution surface observation with specific tunings:
```bash
REF_S_T2  = 3.0,
REF_S_H2  = 0.20,
REF_A_H2  = 40000.,
REF_A_T2  = 40000.,
...
```
 * Quality control and verification - VERAL package
 * Surface analysis

Detailed description of the method and technical documentation can be found in the References below. Here follows basic input/output summary and command line arguments.


## CANARI procedure

All optional items are controlled by various keys in namelist.

## INPUTs

 * The first guess file
```bash
ln -s guess ICMSHANALINIT
ln -s guess ELSCFANALALBC000
```
 * The observation database, which requires special variables to be exported
```bash
export ODB_STATIC_LINKING=1
export TO_ODB_ECMWF=0
export ODB_CMA=ECMA    ... Database type (ECMA extended CCMA compressed)
export ODB_SRCPATH_ECMA=...
export ODB_DATAPATH_ECMA=...
export IOASSIGN=
export ODB_MERGEODB_DIRECT= ... optional direct ODB merge, If your ODB was not merged previously use  1
```
 * Concerning the observation use, another file is necessary, but it is without any interest for CANARI (just part of variational analysis code is not controlled by a logical keyt !) The file can be obtained on "tori" via gget var.misc.rszcoef_fmt.01.
```bash
ln -s rszcoef_fmt var.misc.rszcoef_fmt.01
```
 * The climatological files
```bash
ln  -s  climfile_${mm}  ICMSHANALCLIM
ln  -s  climfile_${mm2} ICMSHANALCLI2
```
 * The namelist file
```bash
ln -s namelist fort.4 
```
 * The ISBA files
               - file used to derive soil moisture from 2m increment
```bash
ln -s POLYNOMES_ISBA fort.61              
```
               - OPTIONAL assimilated increments files to smooth the fields (ICMSHANALLISSEF file is created at the and of analysis )
```bash
ln -s increment_file ICMSHANALLISSE     
```

 * OPTIONAL The SST file - an interpolated NCEP SST analysis on ARPEGE grid and stored in FA file format) used for relaxation towards "up-dated" climatology
```bash
ln -s SST_file ICMSHANALSST        
```
 * OPTIONAL The error statistic file; OI allows to know the variance of the analysis error, which can be used to improve background error next cycle => an option to use "dynamics" statistics instead of fixed. Output file ICMSHANALSTA2 is produced with statistics for the current run
```bash
ln -s statistics_file ICMSHANALSTA
```
 * OPTIONAL The incremental mode files (global option only); it is possible to read 3 input file to build non-classical init; the combination is done on spectral fields only: G1=G0+A-G
```bash
ln -s G0_file ICMSHANAINIT
ln -s A_file ICMSHANALANIN
ln -s G_file ICMSHANALFGIN
```

## run CANARI

MASTERODB -c701 -vmeteo -maladin -eANAL -t1. -ft0 -aeul

 * -c: configuration number (CANARI = 701)
 * -v: version of the code (always "meteo" for ARPEGE/ALADIN)
 * -m: LAM or global model ("aladin" or "arpege")
 * -e: experiment name (ANAL for instance)
 * -t: time-step length (no matter for CANARI, usually "1.", avoid 0.)
 * -f: duration of the integration ("t0" or "h0" for CANARI)
 * -a: dynamical scheme (does not matter for CANARI Eulerian = "eul" or semi-Lagrangian = "sli" (sli as usual))

## OUTPUTs

 * OPTIONAL The analysis file
```bash
ICMSHANAL+0000
```
 * OPTIONALLY updated observational database
 * OPTIONAL The error statistics file
```bash
ICMSHANALSTA2
```
 * OPTIONAL The increment file
```bash
ICMSHANALLISSEF
```
 * The output listing - enables checking of various parameters, e.g. number observation of given type (SYNOP,TEMP,..), number of used observation parameters (T2m, RH2m, T, geop., ...), some namelist variables, various control prints (O-G and O-A statistics, ...), grid-point and spectral norms.
 NODE*

Sample of script is attached.


As a part of the system training in Copenhagen in 2008, Roger prepared an intoduction to CANARI, which is found [wiki:/HarmonieSystemTraining2008/Lecture/SurfaceAssimilation here]

## References

 * F. Taillefer, 2002: [Canari - technical documentation](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article3&var_recherche=canari&var_lang=en)
 * F. Bouttier and P. Courtier, 1999: [Data assimilation concepts and methods](http://www.ecmwf.int/newsevents/training/rcourse_notes/pdf_files/Assim_concepts.pdf)
 * F. Bouyssel - [presentation from Budapest](http://netfam.fmi.fi/HMS07/)


[Back to the main page of Surface analysis](./Analysis/SurfaceAnalysis.md)
