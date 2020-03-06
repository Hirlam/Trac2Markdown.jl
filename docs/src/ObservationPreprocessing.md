# HARMONIE Observation Preprocessing
## Introduction
The following figure shows different schematic steps in the HARMONIE data assimilation system.  
It is worth to mention some differences between the observation pre-processing systems used by ECMWF/IFS (IFS), Météo France (MF),HARMONIE, and HIRLAM. Some of these differences are listed below:
|                           |# Météo France|# IFS|# HARMONIE|# HIRLAM|
|# data format/content| BUFR, but sometimes with own table           | BUFR with WMO code                        | BUFR with WMO code                           | BUFR with WMO code               |
|# creation of ODB database| two steps using oulan and bator              | one step, use of complex package bufr2odb | two steps using oulan and bator              | no ODB for HIRLAM                |
|# blacklisting technique| during the creation of the ODB and screening | (may be) only during screening            | during the creation of the ODB and screening | blacklist files read by hirvda.x |


## Observation file preparation
  * [Observation Data](HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData?format=pdfarticle)): Observation data

## Preprocessing Software
  * [Oulan](HarmonieSystemDocumentation/ObservationPreprocessing/Oulan) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Oulan?format=pdfarticle)): Oulan - Converts conventional BUFR data to OBSOUL file that is read by BATOR
  * [Bator](HarmonieSystemDocumentation/ObservationPreprocessing/Bator) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Bator?format=pdfarticle)): Bator - reads OBSOUL/BUFR/HDF5/GRIB observation data and writes ODBs used by data assimilation
  * [Cope](HarmonieSystemDocumentation/ObservationPreprocessing/Cope) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Cope?format=pdfarticle)): Cope - preparation of ODBs used by data assimilation (in development)
