```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/SLAF?action=edit"
```


# SLAF in HarmonEPS

## Background
**SLAF** stands for Scaled Lagged Average Forecasting (Ebisuzaki & Kalnay, 1991) and it is a technique used to easily generate perturbed boundary and initial conditions from a single deterministic model (HRES).

The general idea of SLAF is that perturbations are taking HRES 
forecasts valid at the same time but with different forecast lengths and initial times :

 **IC_m = A_c + K_m * ( IFS_0 – IFS_N )** 

 **BC_m = IFS_0 + K_m * ( IFS_0 – IFS_N )**
Where IC_m is the initial condition for member m, BC_m is the lateral boundary condition for member m, A_c is the control analysis, K_m a scaling factor, IFS_0 is the 
latest available IFS forecast and N [[BR]] is the forecast length for an earlier forecast valid at the same 
time.

This first attempt on using SLAF revealed an undesirable clustering between the different members using positive or negative perturbations. Depending on the sign of K_m the members gather on either side of the mean. If HRES has a increasing bias over the forecast length the same bias will be introduced through the perturbations. A cure of this problem is to use shorter forecast lengths and construct the perturbations by two consecutive forecasts 6 hours apart:

 **IC_m = A_c + K_m * ( IFS_N – IFS_N-6 )**

 **BC_m = IFS_0 + K_m * ( IFS_N – IFS_N-6 )**

where IFS_N is a forecast with length N and IFS_N-6 is a 6h shorter forecast, both valid at the same time as the analysis. With this construction most of the clustering is gone. **THIS IS THE DEFAULT SETUP IN HarmonEPS cy40.**

From the equation it is clear that every lag used generates two perturbations, so if we use deterministic runs from 06, 12, 18, 24 and 30 hours before we'll have 10 different perturbed members and control, then 11 members in total. 


The goal is to have similar spread at the boundaries of the LAMEPS than using pure downscaling but with less communication time.

Sotfware to use SLAF technique in HarmonEPS was introduced in HarmonEPS branch in version 38h1.1 and first tested by Jose A. Garcia-Moya.

The main advantage of SLAF is that only needs having stored the last runs of the deterministic model and, in daily run mode at home, we only need to have access to the last ECMWF (or any other global model) run avoiding a lot of time in communications compared with the pure downscaling technique.

Summarizing, to run an HarmonEPS experiment using SLAF (default in cy40) you have to:

1) Refer to HarmonEPS branch 38h1.1 (minimum). (Constant 6h lag as described above from cy40)

2) In ecf/config_exp.h  choose:

 2a) BDSTRATEGY=simulate_operational

 2b) ENSMSEL=0-10 (or whatever you want)

 2c) SLAFLAG=1

 2d) SLAFK=1

3) In msms/harmonie.pm:

 3a)  'ENSBDMBR' => [ 0],

 3b)  'SLAFLAG'  => [    0,    6,     6,    12,    12,  18,     18,   24,    24,    30,    30],

 3c)  'SLAFDIFF' => [    0,    6,     6,     6,     6,    6,     6,    6,     6,     6,     6],

 3d)  'SLAFK'    => ['0.0','1.75','-1.75','1.5','-1.5','1.2','-1.2','1.0','-1.0','0.9','-0.9'] (example used for constant 6h lag)


 Where SLAFLAG represent the lags of every member of the ensemble and SLAFK are the different scales (including  the sign). Theoretically the user may set SLAFK as she/he likes but it seems to be more convenient choosing ± in order  to keep symmetry of the perturbations around control. Note that to get equally sized perturbations SLAFK is required to be tuned, please see below for details.

Note that no further control on the equilibrium among the perturbed variables (temperature, humidity and so on) is done, so perhaps you have to check the spin-up if you are interested in the first hour of the ensemble.

## Tuning of SLAF

The correct size of SLAFK can be determined by the perturbation diagnostics done in PertAna (harmonie-40h1.1) or Pertdia (harmonie-40h1.2). Here xtool is used to calculate the differences between the boundary files for the control and the individual member. The output is then collected in the HM_Date*.html files or HM_Postprocessing*.html for harmonie-40h1.1 or harmonie-40h1.2 respectively. 

```bash
Check perturbations for member 004 against 000
SLAFLAG=18 SLAFK=1.4 SLAFDIFF=6
...
Start check boundary 048
...
            NAME |  PAR    LEV TYP                                    DESC          BIAS          RMSE           MIN           MAX
S001TEMPERATURE  |  011   001 109                             Temperature   89.367E-003  286.398E-003 -807.670E-003  861.502E-003
...
SURFPRESSION     |  001   000 105                        Surface pressure   50.062E+000  166.547E+000 -694.022E+000  762.069E+000
```

A parser [Get_pertdia.pl](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/EPS/SLAF/Get_pertdia.pl) , working for harmonie-40h1.2, is attached and should be used like in this example from !MetCoOp
```bash
./Get_pertdia.pl SURFPRESSION HM_Postprocessing_201704??00.html HM_Postprocessing_201704??12.html
Scanning HM_Postprocessing_2017040100.html 
...
Scanning HM_Postprocessing_2017040512.html 
PARAMETER:SURFPRESSION
MBR  HH  SLAFLAG  SLAFDIFF SLAFK     BIAS      RMSE      STDV     CASES
003  00  18       06       -1.40      0.21     59.86     59.86   11 
003  06  18       06       -1.40     -5.67     67.37     67.13   11 
...
009  42  36       06        0.95     28.92    130.72    127.48   11 
009  48  36       06        0.95     14.80    176.10    175.48   11 

```

The SLAKF can then be adjusted to achieve a uniform level of STDV for all member. Note that the response may be different for different seasons and will vary between IFS versions. An example of SLAF diagnostics from !MetCoOp can be seen in the figure below

 

## Examples
Below is an example for 2016052006 for the two different approaches of SLAF described above:

 
 



----


