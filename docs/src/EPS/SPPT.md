```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/SPPT?action=edit"
```
The SPPT configuration within HarmonEPS is being tested over the period 2016053000 to 2016060500 using the !MetCoOp domain. It has been found that there are some problems with the default pattern generator and thus it has been decided to use the Stochastic Pattern Generator (SPG).

Below is a table of experiments which will be completed in order to find a suitable configuration of the SPG control parameters TAU (time correlation scale) and XLCOR (length correlation scale).
The value of the standard deviation of the perturbation amplitudes (SDEV_SDT) is kept fixed at 0.20 as is the clipping ratio of the perturbations (XCLIP_RATIO_SDT=5.0). 
These values along with the default value for XLCOR come from suggested settings used by Mihaly Szucs.

First of all, keeping the XLCOR parameter constant (set at the default value of 2000000), TAU will be varied between 1h and 24h as shown in the table. The value of TAU is in seconds in the table below. The value of XLCOR is in metres.

The experiments are started by typing ~hlam/Harmonie start DTG=2016053000 DTGEND=2016060500 BUILD=yes


|= **Experiment Name**   =|= **Who** =|= **DTG**  =|= **DTGEND** =|=  **Version**   =|= **Domain**  =|= **TAU** =|= **XLCOR** =|= **Description and Comments** =|= **Status** =|= **Verification** =|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SPPT_only_40h111_2000km_1h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 3600 | 2000000 | XLCOR constant, TAU varying | **Suspended** | No |
| SPPT_only_40h111_2000km_3h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 10800 | 2000000 | XLCOR constant, TAU varying | Crash | No |
| SPPT_only_40h111_2000km_6h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 21600 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes |
| SPPT_only_40h111_2000km_9h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 32400 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes | 
| SPPT_only_40h111_2000km_12h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 43200 | 2000000 | XLCOR constant, TAU varying | **Complete**  | Yes | 
| SPPT_only_40h111_2000km_15h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 54000 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes | 
| SPPT_only_40h111_2000km_18h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 64800 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes | 
| SPPT_only_40h111_2000km_21h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 75600 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes | 
| SPPT_only_40h111_2000km_24h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 86400 | 2000000 | XLCOR constant, TAU varying | **Complete** | Yes | 

Once these experiments have been completed testing will commence on keeping the time correlation scale constant and the spatial scale will be varied. Below is a table of experiments to this effect. 

A default value of 8h will be used for TAU as per the suggested value from Mihaly Szucs.


|= **Experiment Name**   =|= **Who** =|= **DTG**  =|= **DTGEND** =|=  **Version**   =|= **Domain**  =|= **TAU** =|= **XLCOR** =|= **Description and Comments** =|= **Status** =|= **Verification** =|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SPPT_only_40h111_100km_8h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 100000 | XLCOR varying, TAU constant | **Complete** | Yes | 
| SPPT_only_40h111_200km_8h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 200000 | XLCOR varying, TAU constant | **Complete** | Yes | 
| SPPT_only_40h111_400km_8h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 400000 | XLCOR varying, TAU constant | **Complete** | Yes | 
| SPPT_only_40h111_600km_8h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 600000 | XLCOR varying, TAU constant | **Complete** | Yes | 
| SPPT_only_40h111_800km_8h | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 800000 | XLCOR varying, TAU constant | **Complete** | Yes | 
| SPPT_only_40h111_1000km_8h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 1000000 | XLCOR varying, TAU constant | **Complete** | Yes |
| SPPT_only_40h111_1200km_8h | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 1200000 | XLCOR varying, TAU constant | **Complete**  | Yes | 
| SPPT_only_40h111_1500km_8h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 1500000 | XLCOR varying, TAU constant |**Complete**  | Yes | 
| SPPT_only_40h111_1800km_8h | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 28800 | 1800000 | XLCOR varying, TAU constant | **Complete** | Yes | 

The next step in the SPPT sensitivity analysis will be a set of experiments designed to test the impact of the SDEV parameter. Default values of 8h and 2000000 for TAU and XLCOR are used respectively.

The XCLIP_RATIO_SDT parameter will also be adjusted as a function of the SDEV_SDT value. Initially keeping the clipping at 1.0 (clipping value is XCLIP_RATIO_SDT * SDEV_SDT), but also exploring other options.


|= **Experiment Name**   =|= **Who** =|= **DTG**  =|= **DTGEND** =|=  **Version**   =|= **Domain**  =|= **SDEV_SDT** =|= **XCLIP_RATIO_SDT** =|= **Description and Comments** =|= **Status** =|= **Verification** =|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SPPT_only_40h111_sdev_01 | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.1 | 10.0 | SDEV and XCLIP varying | **Complete**  | Yes |
| SPPT_only_40h111_sdev_02 | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.2 | 5.0 | SDEV and XCLIP varying | **Complete** | Yes |
| SPPT_only_40h111_sdev_03 | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.3 | 3.3 | SDEV and XCLIP varying | **Complete** | Yes |
| SPPT_only_40h111_sdev_04 | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.4 | 2.5 | SDEV and XCLIP varying | **Complete** | Yes |
| SPPT_only_40h111_sdev_05 | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.5 | 2.0 | SDEV and XCLIP varying | **Complete** | Yes |
| SPPT_only_40h111_sdev_06 | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.6 | 1.65 | SDEV and XCLIP varying | **Complete**  | Yes | 
| SPPT_only_40h111_sdev_07 | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.7 | 1.4 | SDEV and XCLIP varying | **Complete**  | Yes | 
| SPPT_only_40h111_sdev_08 | Janne | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.8 | 1.25 | SDEV and XCLIP varying |**Complete** | Yes | 
| SPPT_only_40h111_sdev_09 | Karoliina | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 0.9 | 1.1 | SDEV and XCLIP varying | **Complete**  | Yes | 
| SPPT_only_40h111_sdev_10 | Alan | 2016053000 | 2016060500 | harmonEPS40h1.1.1(17985) | METCOOP25B | 1.0 | 1.0 | SDEV and XCLIP varying | **Complete** | Yes |
