```@meta
EditURL="https://hirlam.org/trac//wiki//Analysis/CANARI_EKF_SURFEX?action=edit"
```
## Surface variables assimilated / read in EKF_MAIN

From cycle 37 EKF is implemented in research/development mode. The following tiles and variables are modified:

### NATURE
### = WG2/WG1/TG2/TG1=
The uppermost two levels in ISBA of soil moisture and temperature are assimilated. With CANARI/CANARI_OI_MAIN by an OI method, by CANARI_SURFEX_EKF by an Extended Kalman Filter (EKF).


For 2012 it is planned to have a re-writing of OI_MAIN/EKF_MAIN to be the same binary in order to be able to apply the work done for OI_MAIN in EKF_MAIN and thus reduce the maintainance costs.


[Back to the main page of Surface analysis](./Analysis/SurfaceAnalysis.md)
