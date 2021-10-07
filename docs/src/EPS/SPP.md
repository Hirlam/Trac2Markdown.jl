```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/SPP?action=edit"
```
# SPP in HarmonEPS

## SPP options in HARMONIE

In harmonEPS-40h1.1.1 and release-43h2.

SPP is activated by the flag LSPP in [ config_exp.h](https://hirlam.org/trac/browser/branches/harmonEPS-40h1.1.1/ecf/config_exp.h)

Namelist flags for SPP are found in the namelist [namspp.nam.h](https://hirlam.org/trac/browser/branches/harmonEPS-40h1.1.1/src/arpifs/namelist/namspp.nam.h)

Currently the following perturbations are implemented:


| **Perturbation** | **Description** | **Perturbs** | **Default mean value** | **Recommended range by physics experts** | **CMPERT1** | **Recommended CMPERT, summer/winter testing** | **Clipping range** | **Status** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P1:  LPERT_PSIGQSAT | perturb saturation limit sensitivity | VSIGQSAT | changed from 0.02 to 0.03 | 0-0.06 | 0.1 | CMPERT=0.4/0.4 | none | Implemented, works on full size domain| 
| P2:  LPERT_CLDDPTH  | perturb threshold cloud thickness for stratocumulus/cumulus transition | RFRMIN(19) | 2000 | 1000-4000 | 0.1 | Set to FALSE | none  | **Has no impact, to be removed?** | 
| P3:  LPERT_CLDDPTHDP | perturb threshold cloud thickness used in shallow/deep convection decision | RFRMIN(20) | 4000 | 1000-8000 | 0.1 | CMPERT=0.4/0.4 | none | Implemented, works on full size domain | 
| P4:  LPERT_ICE_CLD_WGT | perturb cloud ice content impact on cloud thickness | RFRMIN(21) | 1 | 0-2 | 0.1 | CMPERT=0.4/0.4 | none | Implemented, works on full size domain | 
| P5:  LPERT_ICENU |    perturb ice nuclei | RFRMIN(9) | 1 | 0.1-10 | 0.35 | CMPERT=0.7/1.4, use median | none | Implemented, works on full size domain  | 
| P6:  LPERT_KGN_ACON | perturb Kogan autoconversion speed | RFRMIN(10) | 10 | 2-50 | 0.25 | CMPERT=0.5/0.5 | none | Implemented, works on full size domain |
| P7:  LPERT_KGN_SBGR | perturb Kogan subgrid scale (cloud fraction) sensitivity | RFRMIN(11) | changed from 1 to 0.5 | 0.01-1 (bigger than 0 and less than 1) | 0.1 | CMPERT=0.2/0.2 | 0.0 - 1.0 | Implemented, works on full size domain | 
| P8:  LPERT_RADGR | perturb graupel impact on radiation | RADGR | changed from 0 to 0.5 | 0-1 | 0.15 | CMPERT=0.3/0.3 | 0.0 - 2.0 | Implemented, works on full size domain | 
| P9:  LPERT_RADSN | perturb snow impact on radiation | RADSN | changed from 0 to 0.5 | 0-1 | 0.15 | CMPERT=0.3/0.6? | 0.0 - 2.0 | Implemented, works on full size domain | 
| P10: LPERT_RFAC_TWOC | perturb top entrainment | RFAC_TWO_COEF | 2 | 0.5-3 | 0.1 | CMPERT=0.4/0.4 | none | Implemented, works on full size domain | 
| P11: LPERT_RZC_H | perturb stable conditions length scale | RZC_H | 0.15 | 0.1-0.25 | 0.1 | CMPERT=0.4/0.4 | none | Implemented, works on full size domain | 
| P12: LPERT_RZL_INF | Asymptotic free atmospheric length scale | RZL_INF | 100 | 30-300 | 0.15 | CMPERT=0.6/0.6 | none | Implemented | 
| P13: LPERT_RLWINHF | Long wave inhomogeneity factor | RLWINHF | N/A | ? | ? | ? | none | Implemented | 
| P14: LPERT_RSWINHF | Short wave inhomogeneity factor | RSWINHF | N/A | ? | ? | ? | none | Implemented | 

CMPERT1 is the value that gives the range of values for the parameters that is recommended by the experts. After tuning we ended up with larger perturbations (the values that are listed in the column "Recommended CMPERT"), typically they are 2 or 4 times larger than CMPERT1.

The min/max range of each perturbed parameter can be controlled by the CLIP_[PARAMETER] namelist variable where the limits are specified in harmonie_namelists.pm as e.g.

```bash
 NAMSPP=>{
 'CLIP_PSIGQSAT' => '0.0,0.1',
 ...
 },
```

For more details see [spp_mod.F90](https://hirlam.org/trac/browser/branches/harmonEPS-40h1.1.1/src/arpifs/module/spp_mod.F90)

## Pattern diagnostics

The raw and scaled patterns are stored in the vertical column of SNNNEZDIAG01 using the index given in the SPP initialization. Thus

```bash
...
KGET_SEED_SPP: PSIGQSAT                10000   1841082593
   pattern   1 for PSIGQSAT         using seed   1841082593
KGET_SEED_SPP: CLDDPTH                 10002    570790063
   pattern   2 for CLDDPTH          using seed    570790063
KGET_SEED_SPP: CLDDPTHDP               10004    980493159
   pattern   3 for CLDDPTHDP        using seed    980493159
KGET_SEED_SPP: ICE_CLD_WGT             10008   1362729695
   pattern   4 for ICE_CLD_WGT      using seed   1362729695
...
```

would give us


| **Perturbation** | **FANAME raw pattern** | **FANAME scaled pattern** | 
| --- | --- | --- |
| PSIGQSAT | S001EZDIAG01 | S002EZDIAG01 |
| CLDDPTH | S003EZDIAG01 | S004EZDIAG01 |
| CLDDPTHDP | S005EZDIAG01 | S006EZDIAG01 |
| ICE_CLD_WGT | S007EZDIAG01 | S008EZDIAG01 |


**Note! in release-43h2 the FANAME is SNNNSPP_PATTERN and is activated by TEND_DIAG=yes in ecf/config_exp.h.**

## Tendency diagnostics

Tendency diagnostics is available in release-43h2 through the TEND_DIAG switch in ecf/config_exp.h. Activation gives six new 3D-fields


| **FANAME** | **Description** |
| --- | --- |
| SNNNPTENDU | U-component tendencies |
| SNNNPTENDV | V-component tendencies |
| SNNNPTENDT | Temperature tendencies |
| SNNNPTENDR | Moisture tendencies |
| SNNNMULNOISE | SPPT pattern, same for all levels | 
| SNNNSPP_PATTERN | SPP pattern, distribution as explained above | 


## Experiments


|
|
|**Experiment name**|**Experiment !Setup/Data**|**Experiment description**|**Experiment period**|**Domain**|**Perturbed Parameters**|**Status of experiment**|**Contact**|
|REF_40h111|/home/ms/no/fai/hm_home/REF_40h111 \\ ec:/fai/harmonie/REF_40h111|DEFAULT eps_ec experiment for comparison | !2017051400-!2017060400|METCOOP25B|None|Finished|Inger-Lise|
|heps40h111_ref|/home/ms/se/snh/hm_homeheps40h111_ref \\ ec:/snh/harmonie/heps40h111_ref | Used for spinup. | Sinup date: !2017051318 | METCOOP25B| None | Finished | Ulf |


----


