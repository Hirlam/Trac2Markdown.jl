```@meta
EditURL="https://hirlam.org/trac//wiki//ObservationHowto/Modes?action=edit"
```

# Mode-S Enhanced Surveillance

## Introduction

From [http://mode-s.knmi.nl](http://mode-s.knmi.nl/):

A novel method to measure wind and temperature is related to tracking and ranging by an enhanced surveillance (EHS) air traffic control (ATC) radar.

Modern aircraft carry sensors to measure the Mach number (using pitotstatic probe) and the total air temperature (T). An EHS radar interrogates all aircraft in sight in a selective mode (Mode-S), on which the aircraft replies with a message containing, for example, magnetic heading, airspeed and Mach number. From this information wind and temperature can be extracted.

## Mode-S EHS data
### Description
The data description is available here: [http://mode-s.knmi.nl/data/](http://mode-s.knmi.nl/data/)

### Access
Access to MUAC Mode-S EHS data can be requested from KNMI by signing a Non Disclosure Agreement. Send an e-mail to mode-s@knmi.nl with a request like this:
```bash
Dear Sir/Madam,

On behalf of MyNHMS, My NHMS Full Name, I would like to request access to Mode-S EHS derived meteorological data made available by Maastricht Upper Area Centre (MUAC) of EUROCONTROL and KNMI.

MyNHMS intend to use these data for NWP (Numerical Weather Prediction) research and development with the hope of assimilating these data in operational NWP system(s) in the near future.

My contact details are as follows:
Name
Address
e-mail
Telephone

Yours Sincerely,
Name
```
## Prepare the BUFR data
### ftp server
Mode-S EHS bufr, netCDF and ASCII data are available on the KNMI ftp server, ftpservice.knmi.nl. The ASCII and netCDF file contain all observations, while BUFR file contains about 10% of the available observations. The thinning is for descending and ascending aircraft evry 300m in pressure altitude, and for level flight one observation per 2 minutes.

### BUFR data sub-category change
At present the BUFR-sub category needs to be changed: bufr_set, an ecCodes tool, can be used to change the data sub-category from 146 to 147. This is required by HARMONIE.
```bash
bufr_set -sdataSubCategory=147 Mode-S-EHS_MUAC_20170507_2345.bufr Mode-S-EHS_MUAC_20170507_2345_147.bufr
```
## HARMONIE changes
### scr/include.ass
In [source:scr/include.ass] should be edited to "switch on" the use of Mode-S EHS data:
```bash
export MODESEHS_OBS=1          # Mode-S EHS
```
### Processing using Bator
The BUFR template (WMO AMDAR v7) used by your Mode-S EHS data should be defined in the param.cfg file used by Bator. param.cfg files for Bator are in the [nam](https://hirlam.org/trac/browser//trunk/harmonie/nam) namelist directory. The modes param.cfg template should be something like this:
```bash
BEGIN amdar

END
```

### Processing using Oulan
The processing of Mode-S EHS BUFR using Oulan is controlled by the following namelist entry in scr/Oulan:
```bash
LMODES=.FALSE.
```