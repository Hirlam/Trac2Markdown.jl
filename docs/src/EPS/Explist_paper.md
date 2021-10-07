```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/Explist_paper?action=edit"
```
# List of experiments for HarmonEPS paper 2018


## Experiments

| Figure number | Exp name in the paper | Location of FCtables | Location of obs sqlite file | Exp period | Responsible | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| LBC1 | slaf_ref_sum, ens_ref_sum_det_sst, ens_clu_newVer, heps40h11rfp | ecgate:/scratch/ms/se/snh/HARP/FCtables | /scratch/ms/se/snh/HARP/OBS | 2017082100-2017092000, only 00 | Ulf | |
| SAPM1 | |  |  |  | Ulf | Figures taken from http://shiny.hirlam.org/metcoopEPS/ I don't know where to find the original data |
| EDA0          | 1: EDA_surfobs | /scratch/ms/no/fai/HARP/FCtables/EDA_moreobs3 | /scratch/ms/no/fai/HARP/OBS/KI_OBS_2016.sqlite | 2016053000-2016061500, only 00 | Inger-Lise | |
|               | 2:  EDA_surfobs without Pert-Ana | /scratch/ms/no/fai/HARP/FCtables/EDA_moreobs3_noPertAna | | | Inger-Lise | |
| EDA2          | 1: EDA_surfobs | /scratch/ms/no/fai/HARP/FCtables/EDA_moreobs3 | /scratch/ms/no/fai/HARP/OBS/KI_OBS_2016.sqlite | 2016053000-2016061500, only 00 | Inger-Lise | |
|               | 2: REF | /scratch/ms/no/fai/HARP/FCtables/REF_moreobs3_surfpert_PTOPfix | | | Inger-Lise | |
|               | 3: EDA_surfpert | /scratch/ms/no/fai/HARP/FCtables/EDA_moreobs7 | | | Inger-Lise | |
| LETKF1, LETKF3, LETKF4 | 1: LETKF_PERTSFC | /scratch/ms/es/im8/HARP/data/EPS/FCtables/LETKF_PERTSFC | /scratch/ms/es/im8/HARP/data/EPS/OBS | 2018091500-2018093012 (00 and 12) | Pau | |
|                        | 2: PERTANA_REF | /scratch/ms/es/im8/HARP/data/EPS/FCtables/PERTANA_REF | /scratch/ms/es/im8/HARP/data/EPS/OBS | 2018091500-2018093012 (00 and 12) | Pau | |
| MPIL1         | 1: REF | /scratch/ms/no/fai/FCtables/SLAF_MetCoOp (NB: 0+8 members) | /scratch/ms/no/fai/HARP/OBS_2015.sqlite | 2015072006 - 2015081006, only 06 | Inger-Lise | |
|               | 2: MP  | /scratch/ms/no/fai/FCtables/HEPS_40h11b5_MP (NB: use only 0+8 members)  |  | | Inger-Lise | |
| MP1      | | /scratch/ms/dk/nhf/HARP/FCtables/COMEPS_opr/multiphys | /scratch/ms/dk/nhf/HARP/OBS_2018.sqlite | 2018051600-2018053018 | Henrik | stationlist: /home/ms/dk/nhf/Harp/data/denmark_opr.csv. No physics pert: use mbr015,016,023,024. Physics pert1: use mbr013,014,015,016. Physics pert2: use mbr015,016,021,022. My config.file: /home/ms/dk/nhf/Harp/eps/conf/HARPenv.comeps_multiphys |
| SPPT1    | 1: REF |  |  |  2017052600 -2017061500, only 00 | Janne | |
|          | 2: SPPT_0.2 |/scratch/ms/fi/fn8/HARPresults/FCtables/MEPS_summer2017_SPPT_NosfcPert |  /scratch/ms/fi/fn8/HARPresults/OBS|   2017052600 -2017061300  | Janne | |
|          | 3: SPPT_0.3 | /scratch/ms/fi/fn8/HARPresults/FCtables/MEPS_summer2017_SPPT_NosfcPert2|  /scratch/ms/fi/fn8/HARPresults/OBS |  2017052600 -2017061300| Janne | |
| SPP1     | 1: REF  | /scratch/ms/no/fai/FCtables/REF_moreobs3 | /scratch/ms/no/fai/OBS/EDA_no_ref/KI_OBS_2016.sqlite | 2016053000-2016061500, onoly 00 | Inger-Lise | |
|          | 2: SPPT | /scratch/ms/no/fai/FCtables/SPPT_default | | | Inger-Lise | |
|          | 3: RPP  | /scratch/ms/no/fai/FCtables/VSIGQSAT_pert003 |  | | Inger-Lise | |
|          | 4: SPP  | /scratch/ms/no/fai/FCtables/VSIGQSAT_SPPTpattern_default | | | Inger-Lise | |
| sfcPert1 | | | | | Andrew | |
| sfcPert2 | | | | | Andrew | |
| sfcPert3 | | | | | Andrew | |
| sfcPert4 | | | | | Andrew | |
| OPER3    | COMEPS | hirlam.org:/home/hf/HARP/COMEPSv2/FCtables/2018/11 and hirlam.org:/data/www/project/portal/smhi/vfld/IFSENS/FCtable_Pcp_IFSENS201811.tar.gz | hirlam.org:/home/hf/HARP/COMEPSv2/OBStables | !2018110100 - !2018113018 | Henrik
| OPER4    | IREPS | /scratch/ms/ie/duah/HARP/FCtables/IREPS/2018/11 |/scratch/ms/ie/duah/HARP/OBS | !2018110100 - !2018113012 | Alan
| OPER5    | RMI-EPS | ec:/cvg/HARP/RMI_EPS25_OPER_v0_noTCOR/SQLtables/2018/11 | ec:/cvg/HARP/RMI_EPS25_OPER_v0_noTCOR/vobs/OBS_2018.sqlite | !2018110100 - !2018113012 | Geert | stationlist: ec:/cvg/HARP/RMI_EPS25_OPER_v0_noTCOR/SQLtables/synopBelgium.csv
| OPER6    | AEMET-gSREPS | /scratch/ms/es/im8/HARP/data/EPS/FCtables/GSREPS/2018/11 | /scratch/ms/es/im8/HARP/data/EPS/OBS/OBS_2018.sqlite | !2018110100 - !2018113012 | Pau 



## Experiments, OLD table

| Exp name | Location of FCtables | Location of exp in ecfs/ectemp | Exp period | Name of exp in the paper | List of exp to be compared with | Short description of the experiment | Responsible |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REF_moreobs3 | /scratch/ms/no/fai/FCtables/REF_moreobs3 | ec:/fai/harmonie/REF_moreobs3 | 2016053000-2016061500 (only 00) | REF | EDA, EDA only, EDA surfpert | Reference for EDA exp, with IASI, AMSU-A and B | Inger-Lise |
| EDA_moreobs3 | /scratch/ms/no/fai/FCtables/EDA_moreobs3 | ec:/fai/harmonie/EDA_moreobs3 | 2016053000-2016061500 (only 00) | EDA | REF, EDA only, EDA surfpert | EDA exp, with IASI, AMSU-A and B | Inger-Lise |
| EDA_moreobs3_noPertAna | /scratch/ms/no/fai/FCtables/EDA_moreobs3_noPertAna | ec:/fai/harmonie/EDA_moreobs3_noPertAan | 2016053000-2016061500 (only 00) | EDA only | REF, EDA, EDA surfpert | As EDA, but without PertAna | Inger-Lise |
| EDA_moreobs3_surfpert | /scratch/ms/no/fai/FCtables/EDA_moreobs3_surfpert | ec:/fai/harmonie/EDA_moreobs3_surfpert | 2016053000-2016061500 (only 00) | EDA surfpert | REF, EDA, EDA only | As EDA, but MF surface perturbations at the surface instead of surface observations perturbations | Inger-Lise |
| heps40h11rfp | /scratch/ms/dk/nhf/HARP/FCtables/heps40h11rfp | ec:/nhf/harmonie/heps40h11rfp | 2017082000-2017091912 (only 00 and 12) | RFP(?) | ? | Random field initial and lateral boundary perturbations | Henrik |
| RMI_EPS25_OPER_v0 | /scratch/ms/be/cvg/HARP/RMI_EPS25_OPER_v0_noTCOR/SQLtables or ec:/cvg/HARP/RMI_EPS25_OPER_v0_noTCOR/SQLtables | ectmp:/cvg1/harmonie/RMI_EPS25_OPER_v0 | 2017090100-2018022812 (only 00 and 12) | RMI-EPS_aro (arome members only?) |ECEPS (over Belgium only, see /home/ms/be/cvg/Harp/data/synopBelgium.csv)| RMI-EPS semi-operational runs | Geert || MEPS_summer2017_SPPT_NosfcPert | /scratch/ms/fi/fn8/HARPresult/FcTables/MEPS_summer2017_SPPT_NosfcPert |ec:/fn8/harmonie/MEPS_summer2017_SPPT_NosfcPert| 2017052900-2017061300 | SPPT |MEPS_summer2017_SPPT_NosfcPert2 |SPPT testing |Janne|| MEPS_summer2017_SPPT_NosfcPert2 | /scratch/ms/fi/fn8/HARPresult/FcTables/MEPS_summer2017_SPPT_NosfcPert2 |ec:/fn8/harmonie/MEPS_summer2017_SPPT_NosfcPert2| 2017052900-2017061300 | SPPT |MEPS_summer2017_SPPT_NosfcPert |SPPT testing |Janne|| letkf_40h11_lsmix_fc2 | /scratch/ms/es/im8/HARP/data/EPS/FCtables/LETKF | ec:/im8/harmonie/letkf_40h11_lsmix_fc2  | 2017040112-2017041600 (00 and 12) | LETKF | PertAna | LETKF assimilating only conventional observations over Iberian Pensinsula | Pau Escribà |
| lameps_40h11_e3 | /scratch/ms/es/im8/HARP/data/EPS/FCtables/PertAna | ec:/im8/harmonie/lameps_40h11_e3 | 2017040112-2017041600 (00 and 12) | PertAna | LETKF | PertAna EPS assimilating only conventional observations over Iberian Pensinsula | Pau Escribà |
