```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/ObsHandling?action=edit"
```

# Observation handling in HARMONIE DA

During this lecture we will discuss how can we choose observations to be used in the analysis system. In HARMONIE we can do that mainly at each step in the assimilation scheme shown bellow:  
## Observation preparation
 First choice we can already do configuring the include-file ($EXP/scr/include.ass) in the following way:
```bash
    #---------------------------------------------------
    # LIST OBSERVATIONS TO USE (0: NO; 1: YES)
    #---------------------------------------------------
    export SYNOP_OBS=1      # All synop
    export AIRCRAFT_OBS=1   # AMDAR, AIREP, ACARS
    export BUOY_OBS=1       # Buoy
    export AMV_OBS=0        # Satob geowind
    export TEMP_OBS=1       # TEMP, TEMPSHIP
    export PILOT_OBS=1      # Pilot, Europrofiler
    export AMSUA_OBS=0      # AMSU-A
    export AMSUB_OBS=0      # AMSU-B, MHS
    export IASI_OBS=0       # IASI
    export PAOB_OBS=0       # PAOB not defined everywhere
    export SCATT_OBS=0      # Scatterometer data not defined everywhere
```
These settings are taken into consideration in !RunInit during the extraction of the observations.
HARMONIE DA system can handle conventional[upper air](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/harmonie_obs_upper_air.png) and [surface](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/harmonie_obs_surface.png) as well as [radiance](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/harmonie_obs_radiance.png) measurements.
## Observation handling during the pre-processing
  * In oulan
    * In [ oulan](https://hirlam.org/trac/attachment/wiki/HarmonieDAWorkshop200805/R_Roger_data_handeling.ppt) choice of observation can be done in the namelist in the following way: set L${OBSTYPE} from the NADIRS namelist group to TRUE and be sure that NB${OBSTYPE} is set to a resonable value. NB${OBSTYPE} is the maximum number of ${OBSTYPE}. An example is given below:
```bash
   &NADIRS
     ...
    LTEMP           =  .TRUE.,
    LSYNOP          =  .TRUE.,
    LAMDAR          =  .TRUE.,
    LEUROPROFIL     =  .TRUE.,
     ...
   /END
   &NANBOB
     ...
    NBTEMP         =     1000,
    NBSYNOP        =     4000,
    NBAMDAR        =     9000,
    NBEUROPROFIL   =     8000,
     ...
   /END
```
    * How to check the functionality of the oulan program?
Check the file OULOUTPUT. You should see among the list of observations to extract ("!Messages a extraire") ".T." indication.
```bash
     In OULOUTPUT:
       ...
          Messages a extraire

  SYNOP      :    .T.   SHIP        :    .T.   SYNOR      :
  AIREP      :    .T.   AMDAR       :    .T.   ACAR       :    .T.
  SATOB      :          SATGEO      :         GEOWIND    :
  BUOY       :    .T.   BATHY       :          TESAC      :
  TEMP       :    .T.   TEMPSHIP    :    .T.   TEMPDROP   :          TEMPMOBIL  :
  PILOT      :    .T.   PILOTSHIP   :          PILOTMOBIL :
  EUROPROFIL :    .T.   PROFILER    :
  SATEM      :          TOVS120     :          ATOVS      :          SSMI       :
  TOVSHIRS   :          TOVSMSU     :          TOVSAMSUA  :          TOVSAMSUB  :
  CYCLONE    :
  ERS1UWI    :
     ...
```
The number of the extracted observations
```bash
    In OULOUTPUT:
    ...
    Nombres de messages extraits                                                total cat.

 SYNOP      :  12539  SHIP        :    830  SYNOR      :                                13369
 AIREP      :    163  AMDAR       :   1318  ACAR       :    408                          1889
 SATOB      :         SATGEO      :         GEOWIND    :
 BUOY       :    863  BATHY       :         TESAC      :                                  863
 TEMP       :    198  TEMPSHIP    :      6  TEMPMOBIL  :         TEMPDROP   :             204
 PILOT      :     17  PILOTSHIP   :         PILOTMOBIL :
 EUROPROFIL :      0  PROFILER    :                                                        17
 SATEM      :         TOVS120     :         ATOVS      :        SSMI        :
 TOVSHIRS   :         TOVSMSU     :         TOVSAMSUA  :         TOVSAMSUB  :
 CYCLONE    :
 ERS1UWI    :

 nombre total d'observations transferees :  16342
    ...
```
In this example the total number of the extracted observations is 16342.
  * In bator
See [ here](http://www.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt) how can we choose/blacklist observations when creating the ODB database. 
## Observation handling during screening
At this level, selection of observations concerns mainly the thinning of aircraft and satellite observations. Also, using IFS rule of blacklisting (check the file [$pack/src/bla/mf_blacklist.b](https://hirlam.org/trac/browser/trunk/harmonie/src/bla/mf_blacklist.b), and [here](http://www.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt)) one can set the "utilisation rule" (blacklist, use passively or reject) of observations in the input database.
## Obsrvation handling in CANARI
In the namelist group NACTEX, we can choose parameters, which we would like to analyse. See [here](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/canari_obs_omf.png) and [here](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/canari_obs_omf1.png) how to do your choice.
## Observation handling during the minimisation
During the minimisation observation types and parameters used in the analysis are chosen in the namelist group NAMJO. See example below:
```bash
      &NAMJO
       ...
        NOTVAR(1,1)= 0, 0,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,2)= 0, 0,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,3)= 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,4)= 0, 0,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,5)= 0, 0,-1,-1,-1,-1, 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,6)= 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,7)=-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,8)=-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,9)=0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
        NOTVAR(1,10)=-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
      ...
     /END
```
      where from "./arp/module/yomcosjo.F90" one can see NVAR_U  # 1; NVAR_U10 2; NVAR_DD # 3; NVAR_FF 4; NVAR_H  # 5; NVAR_H2 6; NVAR_T  # 7; NVAR_Z 8; NVAR_DZ # 9; NVAR_LH10; NVAR_T2 # 11; NVAR_TS12; NVAR_RAD# 13; NVAR_SN14; NVAR_RR # 15; NVAR_PS16; NVAR_CC # 17; NVAR_CLW18; NVAR_Q  # 19; NVAR_FFS20; NVAR_S0 # 21;NVAR_X22; NVAR_PWC# 23; NVAR_TO324; NVAR_TCW# 25; NVAR_RFL26; NVAR_APD# 27; NVAR_RO28; NVAR_HLS# 29; and NVAR_AOD30 ! aerosol optical depth at 0.55 microns
   * Note that here we did not talk about some specifications of satellite observation handling, but this wiki page will be updated accordingly.
   * Details about the observation types can be found in the routine called [suvnmb.F90](https://hirlam.org/trac/browser/trunk/harmonie/src/arp/setup/suvnmb.F90)

## Currently Handled Observation Types
   * Conventional observations
     * Surface data
       Most of surface measurements (SYNOP, SHIP, BUOY)
     * Upper-air observations
       * Most of radiosonde measurements (SHIP and Automatic measurements)
       * Almost all aircraft data (ACARS, AMDAR, AIREP)
       * Pilots and Profilers (Europrofiler)
   * Satellite / satellite related observations
     * Atmospheric Motion vectors (AMV) (All geowind, METEOSAT and MODIS)
     * Level 1D radiances (see [the AAPP pre-processing levels](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/aapp_rad_levels.jpg)) 
       * METEOSAT Seviri data
     * Level 1C radiances
       * NOAA data (NOAA-15, 16, 17, and 18) (ATOVS/AMSU-A; ATOVS/AMSU-B; ATOVS/MHS)
       * METOP data (ATOVS/AMSU-A; ATOVS/MHS)
## Available observations not included yet in the reference scheme/scripts (status for 2008.09) are
    * Radiosonde mobile or dropsonde data (needs update of oulan)
    * Level 1C IASI radiances from METOP (the pre-processing part can be added, but the use of the data should be tuned. IASI assimilation is under development)
    * Zenit Total delay from ground-based GPS stations (ready to be tested)
## Instruction on local implementation
Meteo France made a lot of efforts to put the newly implemented observations to be read directly in BATOR and in BUFR format. Furthermore, work had been started to move the extraction observations from OULAN to BATOR. Still some observations are to be extracted with oulan before to be put into the ODB database. The following figure shows the structure of oulan program. Please look in the file ./uti/oulan/oulan_extract.F how your observation is handled (logical key L$OBSTYPE and NB${OBSTYPE}. Please also keep the structure and, as much as possible, the steps in ./uti/oulan/ext_$OBSTYPE.F, which will be ./util/oulan/ext_lam_$OBSTYPE.F for us. If your observation does not exist in oulan, then don't forget to add your parameters (logical key and parameters) in the namelist definition for oulan. If you would like to extract your observation directly in bator, and the observation or similar parameter exists there, try to keep the same philosophy in the structure, steps and control of available parameters.
## [Hands on practice task](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow#Handsonpracticetask)

## Reference materials
[Roger Randriamampianina, 2005, Observation pre-processing (tools)](http://www.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt)

[Sándor Kertész, 2007, Overview of the observation usage in the ALADIN variational data assimilation system](http://www.rclace.eu/File/Data_Assimilation/2007/lace_obspp.pdf)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)