```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/SurfacePerturbations?action=edit"
```
# Surface perturbations in HarmonEPS - page under construction

Surface perturbation code from Meteo France was implemented in HarmonEPS and is available from cy40 (harmonEPS-40h1.1)

A presentation that describes the surface perturbation code in HarmonEPS can be found here: [status of surface perturbations in HarmonEPS](https://hirlam.org/trac/attachment/wiki/HarmonieWorkingWeek/EPS201611/Surface%20perturbations%20in%20HarmonEPS.pdf)

Results from experiments are here: http://shiny.hirlam.org/metcoopEPS/


|**HARP name**|**Experiment Data**|**Experiment description**|**Experiment period**|**Domain**|**Perturbed Parameters**|**Status of experiment**|**Contact**|
| --- | --- | --- | --- | --- | --- | --- | --- |
|SLAF_6hpert|ec:/fai/harmonie/SLAF_6hpert|DEFAULT SLAF experiment for comparison|SUMMER: 2015072006-2015081006|MetCoOp|None|Finished|Inger-Lise|
|SfcPert_MetCoOp|ec:/fa1m/harmonie/MFsurfacePerturbationsOnly|Surface perturbations only. No LBC or IC perturbations|SUMMER: 2015072006-2015081006|MetCoOp|All Default|Finished|Andrew|
|SfcPert_SLAF_MetCoOp|ec:/fa1m/harmonie/MFsurfacePerturbationsSLAF6h|Surface perturbations. SLAF LBC and IC perturbations|SUMMER: 2015072006-2015081006|MetCoOp|All Default|Finished|Andrew|
|SLAF_6hpert|ec:|DEFAULT SLAF experiment for comparison|WINTER: 2015123006-2016011906|MetCoOp|None|Finished|Ulf|
|SfcPert_MetCoOp|ec:/sur/harmonie/HEPS_winter_MFsurfPertOnly/|Surface perturbations only. No LBC or IC perturbations|WINTER: 2015123006-2016011906|MetCoOp|All Default|Finished|Björn|
|SfcPert_SLAF_MetCoOp|ec:/sur/harmonie/HEPS_winter_MFsurfPertSLAF6h/|Surface perturbations. SLAF LBC and IC perturbations|WINTER: 2015123006-2016011906|MetCoOp|All Default|Finished|Björn|
|MEPS_sfcPert300km_SRNWP|ec:/fa1m/harmonie/MEPS_sfcPert300km_SRNWP|Surface perturbations. SLAF LBC and IC perturbations|SUMMER SRNWP: 2016053000-2016061500|MetCoOp|All Default|Finished|Andrew|
|MEPS_sfcPert150km_SRNWP|ec:/sur/harmonie/MEPS_sfcPert150km_SRNWP/|Surface perturbations. SLAF LBC and IC perturbations. Correlation length scale of perturbations reduced to 150km|SUMMER SRNWP: 2016053000-2016061500|MetCoOp|All Default|Finished|Björn|
|MEPS_sfcPert300km_SRNWP_clip4halfPert|ec:/fa1m/harmonie/MEPS_sfcPert300km_SRNWP_clip4halfPert|Surface perturbations. SLAF LBC and IC perturbations. Doubled clipping value and halved standard deviations of perturbations|SUMMER SRNWP: 2016053000-2016061500|MetCoOp|All Default|Finished|Andrew|
|MEPS_sfcAssimCntrlOnly|ec:/|Surface assimilation on control only|WINTER: 2015123000-2016011900|MetCoOp|None|Finished|Björn|
|MEPS_sfcAssimCntrlOnly_sfcPert300km|ec:/|Surface assimilation on control only + surface perturbations|WINTER: 2015123000-2016011900|MetCoOp|Sfc Assim on control error|Finished|Andrew|
| MEPS_sfcPert150km | ec:/fai/harmonie/MEPS_sfcPert150km | Surface perturbations, 150km, LAI std halved, surface assimilation all members, ENS boundaries | WINTER: 2015123000-2016011900 | MetCoOp | Default, but std for LAI halved to 0.1 | Finished | Inger-Lise |
| MEPS_sfcPert150km_NewsfcAssimCtrl | ec:/sur/harmonie/MEPS_sfcPert150km_NewsfcAssimCtrl | Surface perturbations, 150km, LAI std halved, surface assimilation from control copied to all members, ENS boundaries | WINTER: 2015123000-2016011900 | MetCoOp | Default, but std for LAI halved to 0.1 | Finished | Björn |
|MEPS_summer2017_sfcPertRef|ec:/fa1m/harmonie/MEPS_sfcPertRef|Surface perturbations, 150km, LAI std halved, surface assimilation control only, ENS boundaries|SUMMER: 2017052600-2017061521|MetCoOp|Default, but std for LAI halved to 0.1 | Failed in CANARI 2017061306 | Andrew |
|MEPS_summer2017_NosfcPert|ec:/fn8/harmonie/MEPS_NosfcPert|No Surface perturbations, surface assimilation control only, ENS boundaries|SUMMER: 2017052600-2017061521|MetCoOp|Default, but std for LAI halved to 0.1 | Failed in CANARI 2017061306 | Janne |
|**Suggestions below**| | | | | | | |
|-Name1-|ec:/|Remove SNOW, LAI, VEG, CV from perturbed parameter list|SUMMER SRNWP: 2016053000-2016061500|MetCoOp|All Default except SNOW, LAI, VEG, CV|Not started|Janne|
|-Name2-|ec:/|Add perturbations to WGI1 and WGI2|WINTER: ? |MetCoOp|All Default + WGI1, WGI2|Not started|??|

Verification results and station SQLite (FCTABLE) files can be found on ecgate at

```bash
/scratch/ms/no/fa1m/HARPresults (Andrew)
/scratch/ms/se/sur/HARPresults  (Björn)
```
