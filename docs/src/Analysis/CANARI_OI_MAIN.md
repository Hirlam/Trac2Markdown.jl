```@meta
EditURL="https://hirlam.org/trac//wiki//Analysis/CANARI_OI_MAIN?action=edit"
```
## Surface variables assimilated / read in OI_main

CANARI_OI_MAIN is the surface assimilation scheme which emulates what is done in CANARI for old_surface, but by using the external surface schme SURFEX.

The default surface model is SURFEX and the default surface assimilation scheme is CANARI_OI_MAIN.

### NATURE
### = WG2/WG1/TG2/TG1=
The uppermost two levels in ISBA of soil moisture and temperature are assimilated. With CANARI/CANARI_OI_MAIN by an OI method, by CANARI_SURFEX_EKF by an Extended Kalman Filter (EKF).

### = SNOW=
The snow analysis is performed in CANARI and is controlled by the key: LAESNM. This is set default to be true in scr/RunCanari. And if running with SURFEX this will need to be true also in scr/OI_main as the SURFEX snow then needs to be updated by the analysis done in CANARI.

### SEA
### = SST/SIC=
The only option for SST/SIC at the moment is to take it from the boundaries.
* ecf/config_exp.h : SST=BOUNDARY

If you are using boundaries from IFS the task Interpol_ec_sst will interpolate sst from your boundary file and take into account that SST in the IFS files is not defined over land (as for HIRLAM) and also use an extra-polation routine to propagate the SST into narrow fjords. 

There is a SST analysis built-in in CANARI but not used by HARMONIE or METEO-FRANCE.

### WATER
### = LAKE temperature=
Lake temperatures are updated in OI_main and are extrapolated from the land surface temperatures.

### TOWN
### = ROAD temperature=
Only used when TEB is activated (key: LAROME). Increment for TG2 is added to to ROAD layer 3. 

[Back to the main page of Surface analysis](./Analysis/SurfaceAnalysis.md)
