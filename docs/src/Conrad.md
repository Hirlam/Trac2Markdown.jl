

## Processing of Radar data using CONRAD

## Introduction
The need for radar data processing software, CONRAD:
 * Need for a way to put local radar data into Harmonie for 3DVAR assimilation
 * Météo-France have a working system
 * Météo-France BUFR  format can be read by BATOR

## NMS details

### met.no

| Input Format                   | Prorad XML                                                         |
| --- | --- |
| Conrad conversion executable   | proradpol2bufrpol.F90                              |
| Scanning strategy              | Different elevation angles for reflectivity and wind observations. Different resolutions (see data below) |
| Sensitivity and radar constant | Varies between radars, and might vary in time. Not available directly in the local files for all radars (yet). Note that the definition of these variables also varies between version of the radar software. |
| QC applied (Vr)                |No extra filtering done. De-aliasing done in the radar software (Gematronix, Rainbow). Quality seems to be quite good, but might have some problems at edges. The built in median filter and smoothing in Harmonie might be able to deal with this. Not investigated thoroughly yet. |
| QC applied (dBz)               | Several QC algorithms applied: Sea clutter, Ground clutter, Beam blockage, Sun flare, Speckle (boats, birds, etc) |


### met.ie

 * Met Éireann radar data is available in an OPERA BUFR format summarised in the table below:

| Input Format                   | OPERA BUFR                                                         |
| --- | --- |
| Conrad conversion executable   | decodemetieopera.F90                                               |
| Scanning strategy              | Different elevation angles and resolutions for reflectivity and wind observations. |
| Sensitivity and radar constant | Varies between radars, and might vary in time. Not available directly in the local files for all radars.Currently hard-coded in decodemetieopera.F90 . |
| QC applied (Vr)                | Information to be added. |
| QC applied (dBz)               | Information to be added. |

 * Met Éireann radar data is now also available in an ODIM hdf5 format summarised in the table below:

| Input Format                   | ODIM hdf5                                                         |
| --- | --- |
| Conrad conversion executable   | Not yet tested                                                    |
| Scanning strategy              | Different elevation angles and resolutions for reflectivity and wind observations. |
| Sensitivity and radar constant | Varies between radars, and might vary in time. Not available directly in the local files for all radars. |
| QC applied (Vr)                | Information to be added. |
| QC applied (dBz)               | beamb (built with BALTRAD) has been tested with GTOPO30 DEM |

 * hdf5 data can be visualised with 
    - hdfview:  [http://www.hdfgroup.org/hdf-java-html/hdfview](http://www.hdfgroup.org/hdf-java-html/hdfview) to produce rays x bins type 2D plots
    - with python based wradlib software: [http://wradlib.bitbucket.org](http://wradlib.bitbucket.org) to produce nice polar plots

### KNMI

| Input Format                   | KNMI hdf5 |
| --- | --- |
| Conrad conversion executable   | read_knmiradar.F90 |
| Scanning strategy              | The two Dutch radars (De Bilt and Den Helder) have the same scanning strategy for both reflectivities and radial winds. The number of scanning angles is identical for all elevations, but the number of range bins is different. In the reading routine, however, the largest number of bins is used for all elevations with the missing values replaced by zero. |
| Sensitivity and radar constant | Sensitivity is hard coded in the reading routine and radar constant is read from the local data-files. |
| QC applied (Vr)                | Information to be added. |
| QC applied (dBz)               | Information to be added. |