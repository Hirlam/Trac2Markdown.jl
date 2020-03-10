```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/ObsMonitoringDiagnosis?action=edit"
```

# Analysis Monitoring and Diagnosis in HARMONIE DA
This document gives some suggestions about how we diagnose the effectiveness of programs execution in different steps during the assimilation. Apart of checking the script output, we check the content of the standard output and standard error files of each executable at each step. 
## Diagnosis of different steps in HARMONIE DA
### **Checking the execution of oulan**
Oulan has good and detailed output in the file called OULOUTPUT. See [here](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling#Observationhandlingduringthepre-processing) to check the demanded observations and how to check the number of extracted observations per type. It is important to notice, especially during analysis within a large domain, that you might reach the maximum number NB$OBSTYPE of available observations. In this case you will get a comment (in French) saying that you have extracted the maximum number of observation for the given observation type. If you see something similar, you should increase the number in [eee  namelist].
### **Checking the execution of bator**
Bator does not have such a nice output file like oulan does, so one should take care about standard outputs ("out" and "err") in the script for diagnostic. The standard output file of a bator run looks similar to the example below, where we can see that this BATOR run dealt with reading two files (OBSOUL and !Geowind).
```bash
****** Traitement initial ******
 Parametres  2
    Lecture   = OBSOUL    conv    -conv
    Lecture   = BUFR      geow    -geowind
    Type base = ECMA
    NB slot   =  1
    NB pool   =  24
    Date      =  20080226
    Heure     =  18

fichier OBSOUL.conv     : INBOBS =    21472 INBWAG =    81659
...

Traitement du fichier         BUFR.geow - type :         geowind
BUFR TABLES TO BE LOADED  B0000980601,D0000980601
BUFR TABLES TO BE LOADED  B0000981101,D0000981101
BUFR TABLES TO BE LOADED  B0000980601,D0000980601
BUFR TABLES TO BE LOADED  B0000981101,D0000981101

 *** GEOWIND Nb d'obs selectionnees : 47160
Rejet producteur /= (34,254,160)       0
Rejet pression incorrecte              0
Rejet donnees vent incorrectes         0

```
Then, in the same file we can see output of bator_lamflag like this
```bash
############  ENTERING LAMFLAG_OBS_SELECT #################
 =============================================================
 ===  Information about Parameters Projection Structure  ====
 =============================================================
...

 LAMFLAG: C+I LISTING
 ------------------------------------
 Obs num= 40307
 Obs for C+I= 7906
 Obs around C+I for CANARI= 0
 ------------------------------------


 LAMFLAG: OBSERVATION LISTING
 ---------------------------------------------
 OBSTYPE      STATUS      TOTAL      SELECTED
 ---------------------------------------------
 SYNOP           T        13111          6208
 AIREP           T         1966           747
 SATOB           T        24391           684
 DRIBU           T          621           223
 TEMP            T          199            44
 PILOT           T           19             0
 SATEM           T            0             0
 PAOB            F            0             0
 SCATT           F            0             0
 SLIMB           F            0             0
 OBT11           F            0             0
 OBT12           F            0             0
 RADAR           F            0             0
 OBT14           F            0             0
 OBT15           F            0             0 
...
```
Simple diagnostic of any IFS/AAA configuration run can be checked in the NODE file searching for the following string
```bash
*** END CNT0 ***
```
This means that your model run has reached the end. But to check the NODE, one needs some knowledge of computational algorithm/steps in each configuration.
### **Checking the NODE of CANARI (c. 701)**
If CANARI went well, one should find the following lines in the NODE file
```bash
...
ANALYSE TERMINEE  configuration demandee    701

    *********************************************
    *                                           *
    * A BIENTOT DANS L'ANALYSE OBJECTIVE CANARI *
    *                                           *
    *********************************************
 NSTEP =     0 CNT0   000000000   3.610   3.610   5.089   0.709      3247508384      2766499840      19113
15032           18928       105949936
IO-STREAM STATISTICS, TOTAL NO OF REC/BYTES READ            0/           0 WRITTEN            0/
 0
 -TASK-OPENED-OPEN-RECS IN -KBYTE IN    -RECS OUT-KBYTE OUT   -WALL   -WALL IN-WALL OU-TOT IN -TOT OUT
   1      0    0        0            0        0            0     0.0     0.0     0.0     0.0     0.0
  *** END CNT0 ***
...
```
### **Checking NODE of the screening (c. 002)**
To check the number of observations handled by the model try the following grep command:
```bash
grep NOBTOT  scrNODE
output of this command looks like:
 NOBTOT  =   3182 NOBTOV  =   2853 NOBNTV  =    329 NOBSCA  =      0
```
Where NOBTOT is the total number of reports; NOBTOV, NOBNTV and NOBSCA are the number of TOVS, non-TOVS (conventional), and scatrometers (?) reports. The results of the quality check in general can be seen scanning the content of the NODE file and finding the following string "SCREENING STATISTICS". One will see something like this
```bash
....
*** SCREENING STATISTICS
     --------------------
 *** FOR WHOLE OBSERVATION ARRAY

 STATUS SUMMARY OF REPORTS:

  OB.TYP      REPORTS       ACTIVE      PASSIVE     REJECTED  BLACKLISTED
       1         6208         1220            0         4988            0
       2          747          641            0          106            0
       3          684            0            0          684          684
       4          223           33            0          190            0
       5           44           44            0            0            0
       6            0            0            0            0            0
       7        68489         2030            0        66459        15304
       8            0            0            0            0            0
       9            0            0            0            0            0
      10            0            0            0            0            0
      11            0            0            0            0            0
      12            0            0            0            0            0
      13            0            0            0            0            0
      14            0            0            0            0            0
      15            0            0            0            0            0
     --------------------------------------------------------------------
     TOT        76395         3968            0        72427        15988

 STATUS SUMMARY OF DATA:

  OB.TYP      REPORTS       ACTIVE      PASSIVE     REJECTED  BLACKLISTED
       1        33394         3940         1696        18633        10885
       2         2216         1905            0          283           28
       3         2052            0            0          628         2052
       4          261           36            0          211           14
       5         9218         7411            0           80         1755
       6            0            0            0            0            0
       7       585855        37702       127954       200393       383744
       8            0            0            0            0            0
       9            0            0            0            0            0
      10            0            0            0            0            0
      11            0            0            0            0            0
      12            0            0            0            0            0
      13            0            0            0            0            0
      14            0            0            0            0            0
      15            0            0            0            0            0
     --------------------------------------------------------------------
     TOT       632996        50994       129650       220228       398478

 EVENT SUMMARY OF REPORTS:
....
```
You can also find explanation of some decisions like this
```bash
  ....
     1=NO DATA IN THE REPORT
     2=ALL DATA REJECTED
     3=BAD REPORTING PRACTICE
     4=REJECTED DUE TO RDB FLAG
     5=ACTIVATED DUE TO RDB FLAG
     6=ACTIVATED BY WHITELIST
     7=HORIZONTAL POSITION OUT OF RANGE
     8=VERTICAL POSITION OUT OF RANGE
     9=TIME OUT OF RANGE
    10=REDUNDANT REPORT
    11=REPORT OVER LAND
    12=REPORT OVER SEA
    13=MISSING STATION ALTITUDE
    14=MODEL SUR. TOO FAR FROM STAT. ALT.
    15=REPORT REJECTED THROUGH THE NAMELIST
    16=FAILED QUALITY CONTROL
  ....
```
Of course do not miss to check the general reports about observation subtypes, when looking for the string "Obstype"
```bash
        Obstype     1 === SYNOP, Land stations and ships
        --------------------------------------------------
             Codetype    11 === SYNOP Land Manual Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U           2762            5576.215280021           2.02    0.200E+01   0.000E+00
                   H2          1382            2165.974415131           1.57    0.100E+00   0.000E+00
                   Z           1325            3543.085017904           2.67    0.785E+02   0.000E+00
                   T2          1383            9994.649126484           7.23    0.140E+01   0.000E+00
                   Q           1382            65181.13285214          47.16    0.592E-03   0.000E+00
             Codetype    14 === SYNOP Land Automatic Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U           7496            12168.33930912           1.62    0.200E+01   0.000E+00
                   H2          3792            5057.359856727           1.33    0.100E+00   0.000E+00
                   Z           3842            7548.493306913           1.96    0.785E+02   0.000E+00
                   T2          3809            19325.40160012           5.07    0.140E+01   0.000E+00
                   Q           3792            69937.61180776          18.44    0.550E-03   0.000E+00
             Codetype    21 === SYNOP-SHIP Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   Z            169            1214.218952374           7.18    0.785E+02   0.000E+00
             Codetype    24 === SYNOP Automatic SHIP Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U            134            560.2749872594           4.18    0.300E+01   0.000E+00
                   H2            21            6.484463242733           0.31    0.100E+00   0.000E+00
                   Z            367            2806.555695205           7.65    0.785E+02   0.000E+00
                   T2            21            22.08384250324           1.05    0.140E+01   0.000E+00
                   Q             21            7.118972614680           0.34    0.609E-03   0.000E+00
                         ----------   ---------------------------   --------
       ObsType  1 Total:      31698            205114.9994855           6.47

        Obstype     2 === AIREP, Aircraft data
        --------------------------------------------------
             Codetype   141 === AIREP Aircraft Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U             16            385.3704231476          24.09    0.414E+01   0.000E+00
                   T              3            10.14588889728           3.38    0.150E+01   0.000E+00
             Codetype   144 === AMDAR Aircraft Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U           1240            1830.502793835           1.48    0.328E+01   0.000E+00
                   T            620            543.8478505464           0.88    0.144E+01   0.000E+00
             Codetype   145 === ACARS Aircraft Report
                Variable      DataCount          Jo_Costfunction       JO/n       ObsErr      BgErr
                   U            218            692.2918224983           3.18    0.355E+01   0.000E+00
                   T            119            141.9056544973           1.19    0.142E+01   0.000E+00
                         ----------   ---------------------------   --------
       ObsType  2 Total:       2216            3604.064433421           1.63
  ...
```
### **Checking the NODE of the minimisation (c. 131)**
Online checking (when the model is still running) - you can follow the minimisation process with the following command:
```bash
tail -f NODE | grep GREPCOST
```
You will see the Jo decreasing and the Jb increasing, as in the given example below:
```bash
 ...
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   18  19   366176.605301       356.004820907       0.00000000000       0.00000000000       12.6049194476    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   18  20   365149.318208       283.125686720       0.00000000000       0.00000000000       8.07232877925    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   19  21   364656.358206       325.586815480       0.00000000000       0.00000000000       10.9092403646    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   20  22   364334.578356       352.308638032       0.00000000000       0.00000000000       13.1667023502    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   21  23   364016.878273       395.186977765       0.00000000000       0.00000000000       17.2976763287    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   22  24   363770.996490       412.618263710       0.00000000000       0.00000000000       19.9179830875    
 GREPCOST - ITER,SIM,JO,JB,JC,JQ,JP   23  25   363609.046104       406.820161672       0.00000000000       0.00000000000       20.0282223695    
...
```
## Purpose and objects of monitoring
It may happen when doing our development that we need to check observation settings or usage status at any step of our analysis. For that we need to extract the information we are interested in from processed ODB (ECMA or CCMA). Other objective of a monitoring system is to check the efficiency of our assimilation system with respect to different observation types. Here also we need to extract relevant (lot of) information from outputs of the screening (ECMA database, in this database we have all the observations entering the assimilation system) and that of the minimisation (CCMA databse, which is the output of the variational analysis). There are two ways of doing the extraction of observation, parameters, or status information from our ODB databases:
### Using odbviewer for the [the ODB tools](http://www.ecmwf.int/services/odb/odb_tools.pdf)
    Here is an [example script](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsMonitoringDiagnosis/example_odbviewer.txt) for such extraction. See Saarinen's presentation about the rules for [data selection using sql request](http://www.ecmwf.int/services/odb/odb_overview.pdf).
### Using the MANDALAY program
    MANADLAY has different versions as follows
```bash
...
!-----------------------------------------------------------------------
!  D. Puech   CNRM/GMAP/OBS1    11/2001
!-----------------------------------------------------------------------
!  arguments are:
!     VERSION   
!     ODB_CMA   CCMA, ECMA, ECMASCR     def=ECMA
!     DEGRE    transformation in degree when =1 
!-----------------------------------------------------------------------
! contexte MANDALAY
!
!    version  =  0     manda_gene_hdr.sql, manda_gene_body.sql
!
!    version  =  1     mandalay.sql  defined by the user
!                1-1   run on nb of proc (?)
!
!    version = 3-x   update    ECMA* ; manda_update.sql
!       x=1  zone=1
!       x=2  status.active=0  elimination
!       x=3  status.active=1  forcage (= forcing)
!-------------------------------------------------------------
...
```
It is important to mention that I don't have much experience with MANDALAY, but it seems that 
     * MANDALAY with VERSION=0 is using manda_gene_hdr.sql, manda_gene_body.sql. These files exist in the export pack.
     * MANDALAY with VERSION=1 is using mandalay.sql, this file should be created and put under ./odb/ddl.ECMASCR/, ./odb/ddl.ECMA/ and ./odb/ddl.CCMA/ before compiling the MANDALAY executable.
     * MANDALAY with VERSION 3-x, is using the file manda_update.sql, this file does not exist either among the ODB sql files.
## Tools
I beleave each Centre has their own efficient monitoring system. But, very often such kind of system is not flexible enough to be ported to other Centres. Nethertheless, exportability of the Hungarian version of the observation monitoring package was successfully tested at Met.no. Now [this system](https://hirlam.org/portal/monitor/start.php) is under implementation on the server hirlam.org.
  * Brief description of the ALADIN/HARMONIE monitoring system
      * Input for the system 
      The following sql request will extract the needed information from both ECMA (after screening) and CCMA (after minimisation).
```bash
   CREATE VIEW mandalay

   SELECT
   obstype@hdr,statid, varno,degrees(lat@hdr),degrees(lon@hdr),press@body,sensor@hdr, date,time@hdr,status.active@hdr,    status.blacklisted@hdr, status.passive@hdr, status.rejected@hdr,status.active@body, status.blacklisted@body, status.passive@body, status.rejected@body,  an_depar, fg_depar, obsvalue
   FROM  hdr,desc,body
   WHERE (varno /= 91 ) AND (an_depar is not NULL)
```
      The above request will be the content of your mandalay.sql in case you choose MANDALAY program for extraction.
      * Programs are written in C, and computation/processing of the data is driven by scripts
      * Drawing software used in the system is the GMT package.
      * The system can be used off-line (not using a web interface), and online using php language.
      * Important: Parameters about the model domain are fixed in the system, so one should work a bit on setting these to have nice plots. For example, statistics about the small domain (11 km resolution, Lambert projection) can be plotted using latlon projection. But, map information about the large domain (16 km) with stereographical projection) needs different syntax in the arguments for plotting functions of the GMT package.
      * The system is not documented yet, this should be done in the near future.
  * Magnus has developed a simple tool using gnuplot for plotting graphs and using a slightly more information than shown above. The advantage of this system can be that we will be able to use it online when performing our experiments.
  * In fact in Hungary, before building the web-based system, we had more simple monitoring package, which describes - in an ASCII file - the observation usage during one analysis cycle. Example of the output of the program is given bellow:
```bash
 date = 20080228 time = 1200
 =============================================
 OBSTYPE = SYNOP
 ----- HEADER ----- 
 tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
     16330        3139           0           0       13191
 -----  BODY  ----- 
  Temperature : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                       5273        1039           0           0        4234
  geopotential: tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                       5794        1044           0           7        4750
  Humidity rel: tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                          0           0           0           0           0
  Wind-U      : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                          0           0           0           0           0
  Wind-V      : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                          0           0           0           0           0
 nlev =  1  npar =  5 (T,V,U,Z,Rhu)
     1  1000  5273     0     0  5794     0      1.9791       .0000       .0000     14.9070       .0000      -.0754       .0000       .0000     -2.8214       .0000
 =============================================
 OBSTYPE = AIREP
 ----- HEADER ----- 
 tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
      9514        7786           0           0        1728
 -----  BODY  ----- 
  Temperature : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                       3180        2593           0          55         532
  Wind-U      : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                       3167        2590           0          34         544
  Wind-V      : tot_num_obs   active_rep   passiv_rep   blackl_rep   reject_rep
                       3167        2590           0          34         544
 nlev =  19  npar =  3 (T,V,U)
     1  1000    99    88    88      1.5020      2.1979      2.7016       .3984       .8297     -1.3257
     2   950   120   120   120      1.0090      2.8102      2.3725       .1782       .5930     -2.1003
     3   925   147   147   147       .9413      3.7278      2.3995      -.2413      1.9015     -2.7580
     4   900    79    79    79       .9388      3.9505      2.6717      -.5250      1.0366     -2.5466
     5   850    76    76    76       .7988      3.0296      2.4622      -.5541       .3935      -.4626
     6   700    66    66    66       .6179      2.1779      1.9131      -.2078       .7635       .2841
     7   600    62    62    62       .8340      2.6524      1.9519      -.3060       .3384       .1141
     8   500    84    84    84       .7527      2.7413      2.6245       .2141       .4548       .3322
     9   400    69    69    69       .6182      2.7901      2.2890       .3309      1.1993      -.0958
    10   300    15    15    15       .8097      2.0700      3.1803       .5326       .9741       .0609
    11   250   113   113   113      1.3440      3.6053      3.1287       .0934      -.4575     -1.0561
    12   200   157   159   159      1.3027      2.4574      4.8769      -.2294      1.0473     -1.1026
    13   150     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    14   100     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    15    70     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    16    50     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    17    30     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    18    20     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
    19    10     0     0     0       .0000       .0000       .0000       .0000       .0000       .0000
 =============================================
```
This package has been "forgotten" for a while, but can be improved in case of demand on it. Outputs of this package are exclusively in an ASCII file. Sandor started with exploiting the output of this file when developing the web-based system.

## A Posteriori Diagnosis of Background Error Statistics
 * see attached ppt presentation
## [Hands on tasks on DA](../../../HarmonieSystemTraining2008/Training/DataAssimilation.md)

## Reference
  * [Joint Operational Hirlam Monitoring of Data Assimilation and Use of Observation](https://www.hirlam.org/portal/monitor)


[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)