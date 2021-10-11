```@meta
EditURL="https://hirlam.org/trac//wiki//CHKEVO?action=edit"
```
# ECHKEVO

## Introdcution
This page describes how to activate CHKEVO for diagnosing forecast model spin-up of pressure. This diagnostic is available in trunk from r16488. Yann Michel (MF) kindly suggested some of the changes required. The diagnostics are generated as part of a forecast model run up to 3 h or 6 h. A known problem is that the method fails when the first lateral boundary conditions are read by the model. The suggestion is to use BDINT=3 and forecast length 3 h. FULL-POS should also be deactivated in config_exp.h.

## Preparations
It is assumed you already have a well defined experiment called your_exp. The following instructions are valid for a 3 h diagnostic forecast.
### NAMCHK namelist
 * Enable CHKEVO in the namelist (in the %arome entries):
```bash
cd $HOME/hm_home/your_exp
~hlam/Harmonie co nam/harmonie_namelists.pm
```
 * Edit NAMCHK:
```bash
 NAMCHK=>{
  'LECHKEVO' => '.TRUE.,',
  'LECHKTND' => '.TRUE.,',
  'LECHKPS' => '.TRUE.,',
 },
```
### ecf/config_exp.h
 * Edit your ecf/config_exp.h  as follows:
```bash
POSTP="none"                          # Postprocessing by Fullpos (inline|offline|none).
BDINT=3
HH_LIST="00-21:3"                     # Which cycles to run, replaces FCINT
LL_LIST="3"                           # Forecast lengths for the cycles [h], replaces LL, LLMAIN
```
 * Alternatively for a 6 h diagnostic forecast:
```bash
POSTP="none"                          # Postprocessing by Fullpos (inline|offline|none).
BDINT=6
HH_LIST="00-18:6"                     # Which cycles to run, replaces FCINT
LL_LIST="6"                           # Forecast lengths for the cycles [h], replaces LL, LLMAIN
```

## Results
After running the forecast with CHKEVO activated the statistics of surface pressure tendencies are written to *NODE.001_01* log file. This log file is included in the HM_Date_YYYYMMDDHH.html log file (written to $SCRATCH/hm_home/your_exp/archive/log on ecgate). The results can be obtained by grepping the log file as follows:
```bash
grep "^ CHKEVO : " HM_Date_2013041118.html | tail -n +2
```
This gives the RMS and AVG of pressure tendency for each time step. (The first line is removed as the reading of the start file produces zeros):
```bash
 CHKEVO :   2.5683273661035013       0.42575646791552352     
 CHKEVO :   2.5432078820872874       0.36700119757663685     
 CHKEVO :   1.4402533781888094       0.23533175032737094     
 CHKEVO :   1.3677546254375832       0.22965677860570116     
 CHKEVO :   1.1506125378848564       0.20575065246468008     
 CHKEVO :  0.98597708942270756       0.19299583141063531
.....
```
 * The first column contains the string "CHKEVO :"
 * Second column contains the RMS of dps/dt averaged over the domain.
 * Second column contains the AVG of dps/dt averaged over the domain.

The RMS of dps/dt alone can be extracted with:
```bash
grep "^ CHKEVO : " HM_Date_2013041118.html | tail -n +2 | awk '{print $3}'
```

## Plotting
Some instructions here ...

```bash
grep "^ CHKEVO : " HM_Date_2013041118.html | tail -n +2 > dps.dat
wget https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/CHKEVO/plotCHKEVO.py
chmod 755 ./plotCHKEVO.py
./plotCHKEVO.py -h
./plotCHKEVO.py -i ps.dat  && eog plot.png
# OR
./plotCHKEVO.py -i ps.dat -t 75  && eog plot.png
```
To get the unit of hPa/3h the time-step is taken into account using the "-t" option. If, for example, the time-step is 60 s the values in the second column will be multiplied with 60.*3. and then divided by 100.
