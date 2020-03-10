```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/ConfFilesExp?action=edit"
```
# Configuration for a specific experiment
We have to turn our attention to the file
```bash
sms/config_exp.h
```
in your experiment directory.

For instance, the model domain:
```bash
# **** Model geometry ****
DOMAIN=DENMARK                          # See definitions further down
VLEV=65                                 # Vertical level definition.
                                        # HIRLAM_60, MF_60,HIRLAM_40, or
                                        # BOUNDARIES = same number of levs as on boundary file.
                                        # See the other choices from scr/Vertical_levels.pl

```
Where to find the observations:
```bash
OBDIR=$HM_DATA/observations             # Observation file directory
```
The nesting strategy:
```bash
# **** Nesting ****
HOST_MODEL="ifs"                        # Host model (ifs|hir|ald|ala|aro)
                                        # ifs : ecmwf data
                                        # hir : hirlam data
                                        # ald : Output from aladin physics
                                        # ala : Output from alaro physics
                                        # aro : Output from arome physics
```
The location of the boundary data (Note that I prefer a setup comparable with the location of the observations, e.g., $HM_DATA/boundaries):
```bash
BDDIR=$HM_DATA/${BDLIB}/archive/@YYYY@/@MM@/@DD@/@HH@   # Boundary file directory,
```
The boundary "strategy":
```bash
BDSTRATEGY=simulate_operational   # Which boundary strategy to follow 
                                  # as defined in scr/Boundary_strategy.pl
                                  # 
                                  # available            : Search for available files in BDDIR, try to keep forecast consistency
                                  #                        This is ment to be used operationally
                                  # simulate_operational : Mimic the behaviour of the operational runs using ECMWF LBC,
                                  #                        i.e. 6 hour old boundaries
```
Do you want GRIB with that ? (better say yes, because the default is no):
```bash
# **** GRIB ****
MAKEGRIB=no                             # Conversion to GRIB (yes|no)
```