```@meta
EditURL="https://hirlam.org/trac//wiki//ObservationPreprocessing?action=edit"
```
# HARMONIE Observation Preprocessing
## Introduction
The following figure shows different schematic steps in the HARMONIE data assimilation system.  
It is worth mentioning some differences between the observation pre-processing systems used by ECMWF, Météo France, and HIRLAM. Some of these differences are listed below:

|                           |=AROME/HARMONIE-AROME                                                                         =|=IFS                                      =|
| --- | --- | --- |
|=data format/content      =| BUFR, but sometimes with own table                                                            | BUFR with WMO code                        |
|=creation of ODB database =| Bator converts BUFR to ODB                                                                    | b2o/bufr2odb converts BUFR to ODB         |
|=blacklisting technique   =| Bator (LISTE_LOC, LISTE_NOIRE_DIAP), Screening (hirlam_blacklist.B) & Minim (NOTVAR namelist) | Screening only                            |


## Observation file preparation
  * [Observation Data] ([wiki:HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData?format=pdfarticle pdf](./ObservationPreprocessing/ObservationData.md)): Observation data -- where to get your BUFR!

## Preprocessing Software
  * [Bator] ([wiki:HarmonieSystemDocumentation/ObservationPreprocessing/Bator?format=pdfarticle pdf](./ObservationPreprocessing/Bator.md)): Bator - reads BUFR/HDF5/OBSOUL observation data and writes ODBs used by data assimilation

Other possibilities include:
  * [Oulan] ([wiki:HarmonieSystemDocumentation/ObservationPreprocessing/Oulan?format=pdfarticle pdf](./ObservationPreprocessing/Oulan.md)): Oulan - Converts conventional BUFR data to OBSOUL file that is read by BATOR
  * [Cope] ([wiki:HarmonieSystemDocumentation/ObservationPreprocessing/Cope?format=pdfarticle pdf](./ObservationPreprocessing/Cope.md)): Cope - preparation of ODBs used by data assimilation (in development)
