

## **File formats in HARMONIE**

## Introduction

 The HARMONIE system reads and writes a number of different formats. 

## FA files

 Default internal format input/output for HARMONIE for gridpoint, spectral and SURFEX data. GRIB is used as a way to pack data, but the grib record cannot be used as such.

 * The header contains information about model domain, projection, spectral truncation, extension zone, boundary zone, vertical levels. 
 * Only one date/time per file.
 * FA routines are found under ifsaux/fa
 * List or convert a file with [gl_grib_api](HarmonieSystemDocumentation/PostPP/gl_grib_api)
 * Other listing tool [PINUTS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page# recherche&recherchePINUTS)

 [Read more](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page# recherche&rechercheFA+)


## GRIB/GRIB2

 All FA files may be converted to GRIB after the forecast run. For the conversion between FA names and GRIB parameters check [this table](HarmonieSystemDocumentation/Forecast/Outputlist/43h2).

 * List or convert a GRIB file with [gl_grib_api](HarmonieSystemDocumentation/PostPP/gl_grib_api)

## NETCDF

 In climate mode all FA files may converted to NETCDF after the forecast run. For the conversion between FA names and NETCDF parameters check [this table](Harmonie/util/gl_grib_api/inc/nc_tab.h?rev=release-43h2.beta.3).

 * For the manipulation and listing of NETCDF files we refer to standard NETCDF tools.
 * NETCDF is also used as output data from some SURFEX tools.

## BUFR and ODB

 BUFR is the archiving/exchange format for observations. Observation Database is used for efficient handling of observations on IFS. ODB used for both input data and feedback information.

 Read more about observations in HARMONIE [here](HarmonieSystemDocumentation/UseofObservation).

## DDH (LFA files )

 Diagnostics by Horizontal Domains allows you to accumulate fluxes from different packages over different areas/points. 
 
 * LFA files ( Autodocumented File Software )
 * [gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article44&var_recherche# LFA&var_langen)
 * under util/ddh

## Misc
 
 * vfld/vobs files in a simple ASCII format used by the [verification](HarmonieSystemDocumentation/PostPP/Verification).
 * Obsmon files are stored in sqlite format.


----


