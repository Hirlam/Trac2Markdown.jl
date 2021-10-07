```@meta
EditURL="https://hirlam.org/trac//wiki//ObservationHowto/Atovs?action=edit"
```

# ATOVS radiances (pre-) processing  


## Introduction

The IFS/ARPEGE/AROME data assimilation code uses level 1-c radiances. ATOVS radiances are available through local HRPT (High Rate Picture Transmission) antenna and the EUMETSAT EARS (European Advanced Retransmission Service) EUMETCast broadcasting system. Data received through local antenna need to be pre-processed with the ATOVS and AVHRR Pre-processing Package (AAPP). Radiances are also available trough the GTS, but with longer timelines. 

This short description explains how to prepare ATOVS radiances for (operational) data assimilation. Like all radiances, ATOVS data bias is corrected using Variational technique. VarBC coefficients should be updated for each limited area model. The variational bias correction is activated through namelist switches (see below).

## ATOVS radiances

### scr/include.ass
[include.ass](https://hirlam.org/trac/browser/scr/include.ass) should be edited to "switch on" the use of AMSUA (AMSU-A), AMSUB (AMSU-B/MHS):
```bash
export AMSUA_OBS=1             # AMSU-A
export AMSUB_OBS=1             # AMSU-B, MHS
export ATOVS_SOURCE=mars       # local: EUMETCast;
                               # mars: data from MARS
                               # hirlam: hirlam radiance template
```

The default handling of ATOVS (AMSU-A and AMSU-B/MHS) is so that we store/load them in separate ODB bases. The definition of the bases in Harmonie is done in [include.ass](https://hirlam.org/trac/browser/scr/include.ass).
### Loading the ATOVS radiances
### = Data extracted from MARS=
 * Data extracted from MARS (the default setting in the Harmonie) is loaded the following way: * After extraction, all observations, including the radiances, are shuffled per observation type; * In Bator ATOVS data are loaded from the oulan working directory the following way:{{{
        # AMSU-A observations
      elif [ "$base" = amsua] ; then
        # AMSU-A
        if [ "$AMSUA_OBS" -eq 1]; then
          echo "amsua    BUFR     amsua            ${YMD} ${HH}">>refdata
          ln -sf "$WRK"/oulan/amsua ./BUFR.amsua
          cp "${HM_LIB}"/nam/param_bator.cfg.amsua."${ATOVS_SOURCE}" ./param.cfg
        fi
      elif [ "$base" = amsub] ; then
        # AMSU-B
        if [ "$AMSUB_OBS" -eq 1]; then
          echo "amsub    BUFR     amsub            ${YMD} ${HH}">>refdata
          ln -sf "$WRK"/oulan/amsub ./BUFR.amsub
          cp "${HM_LIB}"/nam/param_bator.cfg.amsub."${ATOVS_SOURCE}" ./param.cfg
        fi
```

  
### = Locally received data=
  * Locally received (usually through the EARS system) data are loaded the from a source or the "observations" directory. Note, it is recommanded to have both AMSU-B and MHS data in one file. Otherwise, it's recommanded to create a single file with them. One can use the command "cat" to do this.  * The example below shows a case when AMSU-B and MHS are stored in different BUFR files:{{{
         # AMSU-A observations
      elif [ "$base" = amsua] ; then
        # AMSU-A
        if [ "$AMSUA_OBS" -eq 1]; then
          echo "amsua    BUFR     amsua            ${YMD} ${HH}">>refdata
          #ln -sf "$WRK"/oulan/amsua ./BUFR.amsua
          ln -sf /scratch/ms/no/sbt/hm_home/RR_CONV/observations/amsua${YMD}${HH} ./BUFR.amsua
          cp "${HM_LIB}"/nam/param_bator.cfg.amsua."${ATOVS_SOURCE}" ./param.cfg
        fi
      elif [ "$base" = amsub] ; then
        # AMSU-B
        if [ "$AMSUB_OBS" -eq 1]; then
          cat /scratch/ms/no/sbt/hm_home/RR_CONV/observations/amsub${YMD}${HH}  /scratch/ms/no/sbt/hm_home/RR_CONV/observations/mhs${YMD}${HH} > "$WRK"/oulan/amsub
          echo "amsub    BUFR     amsub            ${YMD} ${HH}">>refdata
          ln -sf "$WRK"/oulan/amsub ./BUFR.amsub
          cp "${HM_LIB}"/nam/param_bator.cfg.amsub."${ATOVS_SOURCE}" ./param.cfg
        fi
```
   
### param.cfg
The BUFR template used by ATOVS (AMSU-A, AMSU-B/MHS) data should be defined in the param_bator.cfg.${atovs}.${ATOVS_SOURCE} file used by Bator. Where $atovs (amsua or amsua) and ATOVS_SOURCE as defined above according to the source of the data source. param.cfg files for Bator are in the [nam](https://hirlam.org/trac/browser//trunk/harmonie/nam) namelist directory. The ATOVS param.cfg template should be something like this:
For locally processed AMSU-A:
```bash
BEGIN amsua
1 1 0 14
codage     1  310009
control    1      15  nb de canaux
values     6  001034  Originating sub-centre
values     7  001007  Satellite identifier
values    11  005041  Scan line number
values    12  005043  Field of view number
values    22  005001  Latitude
values    23  006001  Longitude
values    16  004001  Year
values    25  007024  Satellite zenith angle
values    24  007001  Height of station
values    26  005021  Bearing or azimuth
values    27  007025  Solar zenith angle
values    28  005022  Solar azimuth
values    43  012063  Brightness Temperature
values    38  002150  Tovs Channel number
END amsua
```

For AMSU-A from MARS:
```bash
BEGIN amsua
1 1 0 14
codage     1  310008
control    1      15  nb de canaux
values     6  001034  Originating sub-centre
values     7  001007  Satellite identifier
values    11  005041  Scan line number
values    12  005043  Field of view number
values    22  005001  Latitude
values    23  006001  Longitude
values    16  004001  Year
values    25  007024  Satellite zenith angle
values    24  007001  Height of station
values    26  005021  Bearing or azimuth
values    27  007025  Solar zenith angle
values    28  005022  Solar azimuth
values    43  012063  Brightness Temperature
values    38  002150  Tovs Channel number
END amsua
```

For locally processed AMSU-B:
```bash
BEGIN amsub
1 1 0 15
codage     1  310010
control    1       5  nb de canaux
values     6  001034  Originating sub-centre
values     7  001007  Satellite identifier
values    11  005041  Scan line number
values    12  005043  Field of view number
values    22  005001  Latitude
values    23  006001  Longitude
values    16  004001  Year
values     8  002048  Satellite sensor type
values    24  007001  Height of station
values    25  007024  Satellite zenith angle
values    26  005021  Bearing or azimuth
values    27  007025  Solar zenith angle
values    28  005022  Solar azimuth
values    38  002150  Tovs Channel number
values    43  012063  Brightness Temperature
END amsub
```

For AMSU-B from MARS:
```bash
BEGIN amsub
1 1 0 15
codage     1  310008
control    1       5  nb de canaux
values     6  001034  Originating sub-centre
values     7  001007  Satellite identifier
values    11  005041  Scan line number
values    12  005043  Field of view number
values    22  005001  Latitude
values    23  006001  Longitude
values    16  004001  Year
values     8  002048  Satellite sensor type
values    24  007001  Height of station
values    25  007024  Satellite zenith angle
values    26  005021  Bearing or azimuth
values    27  007025  Solar zenith angle
values    28  005022  Solar azimuth
values    38  002150  Tovs Channel number
values    43  012063  Brightness Temperature
END amsub
```


### BATOR namelist and data extraction

Depending on the satellite and channel you may have to add entries to the NADIRS namelist in the Bator script like the following:
```bash
 &NADIRS
   LMFBUFR=.FALSE.,
   TS_AMSUA(206)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(206)%t_select%TabFov(:) = -1,
   TS_AMSUA(206)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(207)%t_select%TabFov(:) =  -1,
   TS_AMSUA(207)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(207)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(209)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(209)%t_select%TabFov(:) = -1,
   TS_AMSUA(209)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(223)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(223)%t_select%TabFov(:) = -1,
   TS_AMSUA(223)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(4)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(4)%t_select%TabFov(:) = -1,
   TS_AMSUA(4)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(3)%t_select%ChannelsList(:) = -1,
   TS_AMSUA(3)%t_select%TabFov(:) = -1,
   TS_AMSUA(3)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUA(3)%t_select%SclJump = 0,
   TS_AMSUA(784)%t_select%TabFov(:) = -1,
   TS_AMSUA(784)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(206)%t_select%TabFov(:) = -1,
   TS_AMSUB(206)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(206)%t_select%SclJump = 0,
   TS_AMSUB(206)%t_satsens%ModSensor = -1,
   TS_AMSUB(207)%t_select%TabFov(:) = -1,
   TS_AMSUB(207)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(207)%t_select%SclJump = 0,
   TS_AMSUB(207)%t_select%ChannelsList(:) = -1,
   TS_AMSUB(208)%t_select%TabFov(:) = -1,
   TS_AMSUB(208)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(208)%t_select%SclJump = 0,
   TS_AMSUB(208)%t_select%ChannelsList(:) = -1,
   TS_AMSUB(209)%t_select%TabFov(:) = -1,
   TS_AMSUB(209)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(209)%t_select%SclJump = 0,
   TS_AMSUB(209)%t_satsens%ModSensor = 4,
   TS_AMSUB(209)%t_select%ChannelsList(:) = -1,
   TS_AMSUB(4)%t_select%TabFov(:) = -1,
   TS_AMSUB(4)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(4)%t_select%SclJump = 0,
   TS_AMSUB(4)%t_select%ChannelsList(:) = -1,
   TS_AMSUB(3)%t_select%TabFov(:) = -1,
   TS_AMSUB(3)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(3)%t_select%SclJump = 0,
   TS_AMSUB(3)%t_satsens%ModSensor = 15,
   TS_AMSUB(223)%t_select%TabFov(:) = -1,
   TS_AMSUB(223)%t_select%TabFovInterlace(:) = -1,
   TS_AMSUB(223)%t_select%SclJump = 0,
   TS_AMSUB(223)%t_select%ChannelsList(:) = -1,
```

All the "-1" mean that we extract all available data we found. No restriction on the channels nor fields of view (FOV), nor on scanning lines (through "TS_AMSUB(???)%t_select%SclJump = 0,"). The default choices are defined in the routine called [src/odb/pandor/module/bator_init_mod.F90](https://hirlam.org/trac/browser/Harmonie/src/odb/pandor/module/bator_init_mod.F90). Note that although the NOAA-18 was embarked with MHS instrument, somehow our system treat the NOAA-18 MHS as AMSU-B (implementation decision) "TS_AMSUB(209)%t_satsens%ModSensor = 4," is changing the instrument characteristics in our system, while for Metop-A MHS is defined through "TS_AMSUB(3)%t_satsens%ModSensor = 15,".

## Variational bias correction and screening

The variational technique is used to correct the bias for radiance data in Harmonie. Default choice of predictors used to correct bias for different channels of different instruments is defined in [varbc_rad.F90](https://hirlam.org/trac/browser//trunk/harmonie/src/arpifs/module/varbc_rad.F90) as the example taken for AMSU-B below:

```bash
DO ic = 2, 5
  SELECT case (ic)
  case (2)
    yconfig(msensor_AMSUB, ic)%nparam = 4
    yconfig(msensor_AMSUB, ic)%npredcs(1:4) = (/0,8,9,10/)
  case (3:5)
    yconfig(msensor_AMSUB, ic)%nparam = 8
    yconfig(msensor_AMSUB, ic)%npredcs(1:8) = (/0,1,2,5,6,8,9,10/)
  END SELECT
ENDDO
```

The choice for predictors for VarBC in Harmonie is given through namelist of the screening and minimisation in "nam/harmonie_namelist.pm" as follows. The update concerns the choice of predictors for each channel of the used instruments and also the "**nbg**" (nbg_AMSUA, nbg_AMSUB, nbg_MHS, ...) definition for each instruments. Note that the "NBG" defines the "speed of the  adaptivity" of the varBC. High value have slowing, while low value have speeding effect:


```bash
 NAMVARBC=>{
 },
 NAMVARBC_RAD=>{
 'LBC_RAD' => '.TRUE.,',
 'yconfig(3,5)%nparam' => '10',
 'yconfig(3,5)%npredcs(1:10)' => '0,1,2,8,9,10,15,16,17,18',
 'yconfig(3,6)%nparam' => '5',
 'yconfig(3,6)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(3,7)%nparam' => '5',
 'yconfig(3,7)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(3,8)%nparam' => '5',
 'yconfig(3,8)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(3,9)%nparam' => '5',
 'yconfig(3,9)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(3,10)%nparam' => '5',
 'yconfig(3,10)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(4,2)%nparam' => '4',
 'yconfig(4,2)%npredcs(1:4)' => '0,8,9,10',
 'yconfig(4,3)%nparam' => '5',
 'yconfig(4,3)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(4,4)%nparam' => '5',
 'yconfig(4,4)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(4,5)%nparam' => '5',
 'yconfig(4,5)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(15,2)%nparam' => '4',
 'yconfig(15,2)%npredcs(1:4)' => '0,8,9,10',
 'yconfig(15,3)%nparam' => '5',
 'yconfig(15,3)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(15,4)%nparam' => '5',
 'yconfig(15,4)%npredcs(1:5)' => '0,1,8,9,10',
 'yconfig(15,5)%nparam' => '5',
 'yconfig(15,5)%npredcs(1:5)' => '0,1,8,9,10',
 'nbg_AMSUA' => '2000',
 'nbg_AMSUB' => '2000',
 'nbg_MHS' => '2000'   
```

 * Satellite identifiers are available here: [https://software.ecmwf.int/wiki/display/ECC/WMO%3D27+code-flag+table]
 

## Source code
The reading of BUFR ATOVS (AMSU-A and AMSU-B/MHS) is taken care of by the [and [source:amsub](https://hirlam.org/trac/browser/amsua]) subroutines in [src/odb/pandor/module/bator_decodbufr_mod.F90](https://hirlam.org/trac/browser/Harmonie/src/odb/pandor/module/bator_decodbufr_mod.F90). These subroutines read the above parameters defined in the param.cfg file (see above):

Default values for VarBC are defined in [src/arpifs/module/varbc_rad.F90](https://hirlam.org/trac/browser/Harmonie/src/arpifs/module/varbc_rad.F90).

The defined varBC predictors are computed in [src/arpifs/module/varbc_pred.F90](https://hirlam.org/trac/browser/Harmonie/src/arpifs/module/varbc_pred.F90).


## Blacklisting 

### Preparation for radiance monitoring
 Radiances sensed by polar orbiting satellites like NOAA and Meteop series are accessible differently at different assimilation time for different LAM model. This means that we use these data differently in different Harmonie LAM models. To make the assimilation optimal for our domain, we need to monitor the accessibility of data from different instruments inside our model domain. There are two ways of monitoring the radiance data assimilation: - 1) we do passive assimilation of the radiances using the assimilation and forecast systems; - 2) when having forecasts with the system, which we would like to use when assimilating the radiance data, then we can do independent assimilations of radiances with the first guess from the existing mentioned results.
### = Monitoring with passive data assimilation=

 There two ways of monitoring the availability and assimilation of polar orbiting-based radiances. In any case we assimilate the radiances in passive way by changing some settings in the [srs/blacklist/mf_blacklist.b](https://hirlam.org/trac/browser/Harmonie/srs/blacklist/mf_blacklist.b) as follows at the end of blacklisting procedure for each instrument. Please read carefully this paragraph until the end before starting your passive experiment. Below is the example for AMSU-A radiances:
```bash

 ...
! begin passive
        fail(EXPERIMENTAL);
! end passive

    endif;   ! SENSOR = AMSUA
```

This way we guarantee that the blacklisting rules for active radiances are applied, which is very important when we change to active assimilation.

### = Monitoring using the Obsmon tool=

To have the all statistics we need when using the **Obsmon** tool, in [ecf/config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) set the following:
```bash
# *** Observation monitoring ***
OBSMONITOR=obstat               # Create Observation statistics plots
```

Note that running the Harmonie system with this option may slow down you monitoring process. Instead, you can run the Obmon separately. More about the Obsmon monitoring tool can be found [here].[[BR]](./PostPP/Obsmon.md)


### = Cold start=
 This way of monitoring is defined the following way in Harmonie through the [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass):
```bash
# Start with empty VARBC coefficients
export VARBC_COLD_START=yes # yes|no
```

In this way **the estimation starts with zero coefficients and we need minimum 20 days** to have the bias for different channels well converging to their nominal values. This is the common practice in Hirlam community, but some studies in LACE showed that warmstart can be advantageous. 
### = Warm start=
 This way we start with precomputed varBC coefficients from other LAM or from a global model. See the section on "**activating existing varBC coefficients**" below. We set our choice in [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass) the following way:{{{
# Start with empty VARBC coefficients
export VARBC_COLD_START=no # yes|no
```

### = Monitoring with independent analyses and without Obsmon=
 This solution needs additional playfile, which is not yet implemented in the Harmonie system. The playfile avoid the extraction of the LBCs, execution of the forecast and the post-processing parts of the Harmonie system. On top of the screening and minimization, it takes into account of the archiving part of the odb data.

Once you have the ODB database after a month of experiment with analyses only, you can extract the the first-gess departures (fg_depar) and the analysis increments (an_depar) using the scripts in [this tarbal](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/ObservationHowto/Atovs/For_WW.tar). When the extraction is finished, you can compute the statistics using the [this tool](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/ObservationHowto/Atovs/For_WW2.tar). Use the script called "ExtractOdb_??" to extract the departure information. To compute the statistics, use the script called "checkbias_??". To plot the final results you can use the R-based scripts in [this tartbal](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/ObservationHowto/Atovs/R_Plots.tar) file. 

### = Analysing the results=

  * **Using obsmon **
To check the efficiency of the assimilation of each channel extracted by Bator use the obcmon abd make your choice similar to the example below. Make sure that you have chosen your experiment and set up the period for the whole period of your monitoring.





Then plotting the results, you should have something similar to the example below:




Take note about the channels that behave badly (having large bias an_depar over Land or Sea) at different assimilation time. Note that for AMSU-B and MHS, the observation error is relatively larger than that of the AMSU-A. So, you can allow larger bias than for AMSU-A. See the examples bellow.

  * **Not using obsmon **
 
The good point of choosing this tool is that the results are more compacted in only few eps-formatted files, which makes the analysis easier than with Obsmon. The analysis procedure is the same. 

When the assimilation of the ATOVS radiances at all assimilation times was checked, then use the blacklisting rules described below to make your final choice for your LAM model with ATOVS.
 
### Blacklisting rules

  Once we have the list of the bad channels for each of the assimilation time you'd like to apply your ATOVS assimilation, the follow the rules described below. Let take the following decision for example. We need to blacklist the channels 5,6,7, 8 from NOAA-18 AMSU-A 12 UTC. How to register the bad channels in the file called LISTE_LOC_${HH} is described in [this presentation](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/ObservationHowto/Atovs/28_Bp_workshop1n_n_RogerR.ppt).
According to our example, we create the file called **LISTE_LOC_12** with the following content:{{{
N  7 210      209       3 TOVS4       5       6       7       8
N  7 210      209       3 TOVS5      11      12      13      14      15
```

The first line means: N      - blacklist 7      - satem observation 210    - level 1c 209    - NOAA-18 3      - AMSU-A TOVS4  - blacklist 4 channels, which are 5, 6,7 and 8 
Put the LISTE_LOC_$HH files under the "nam" directory.

### Set up the VarBC coefficients for your experiment or operational data assimilation

### = For experiments=

Here we have already the VarBC coefficients, so **we do warm start** (see setup above). her is the procedure:
 - Fetch the VARBC.cycle files from the latest odb_stuff.tar for each assimilation time. In case of 3h cycling, we fetch the VARBC.cycle from the latest 8 cycles. Rename them the following way: VARBC.cycle.$DOMAIN.$EMONTH.$HH, where EMONTH can be SUMMER or WINTER. Like for example: VARBC.cycle.AROME_Arctic.SUMMER.12.
 - Put these files under "const/bias_corr/"

These files are arranged this Fetch_assim_data the following way:
For all Hamonie cycles up to 40:
```bash
     # Fetch data
       if [ ! -s ${DLOCVARBC}/VARBC.cycle] ; then

         echo "Fetch the data from $HM_LIB/const/bias_corr"
         # Set the proper VARBC period for coefficients
         case $MM in
           10|11|12|01|02|03)
             EMONTH=WINTER
           ;;
           04|05|06|07|08|09)
             EMONTH=SUMMER
           ;;
           *)
             echo "This should never happen. MM is $MM"
             exit 1
         esac

         cp $HM_LIB/const/bias_corr/VARBC.cycle.$DOMAIN.$EMONTH.$HH ${DLOCVARBC}/VARBC.cycle || \
         { echo "Could not find cold start VARBC data VARBC.cycle.$EMONTH.$HH" ; exit 1 ; }
              ls -lrt ${DLOCVARBC}
       fi
```

From cycle 43:
```bash
     # Fetch data
       if [ ! -s ${DLOCVARBC}/VARBC.cycle] ; then

         echo "Fetch the data from $HM_LIB/const/bias_corr"
         # Set the proper VARBC period for coefficients
         case $MM in
           10|11|12|01|02|03)
             EMONTH=WINTER
           ;;
           04|05|06|07|08|09)
             EMONTH=SUMMER
           ;;
           *)
             echo "This should never happen. MM is $MM"
             exit 1
         esac

         cp $HM_LIB/const/bias_corr/${DOMAIN}/VARBC.cycle.$HH ${DLOCVARBC}/VARBC.cycle || \
         { echo "Could not find cold start VARBC data VARBC.cycle.$EMONTH.$HH" ; exit 1 ; }
              ls -lrt ${DLOCVARBC}
       fi
```

With a tiny difference that all the VarBC files are now stored under a ${DOMAIN} directory. This allows our system to be up-to-date and ready for all known model domains. Please send your VarBC files to the system administrators.

### = For operational implementation=

The setup is much easier. Name the VARBC.cycle files the following way "VARBC.cycle.${HH} and put them in "$ARCHIVE_ROOT/VARBC_latest", which you need to create.

To check that you have done things right: * Doing experiment: Check that you have all LISTE_LOC_$HH files under the "nam" directory, and the VARBC.cycle.$DOMAIN.$EMONTH.$HH files under "const/bias_corr" directory.
 * Operational implementation: Check that you have all LISTE_LOC_$HH files under the "nam" directory, and the VARBC.cycle.$HH under the $ARCHIVE_ROOT/VARBC_latest directory. 
If you passed the test, then **you are ready** with ATOVS implementation. Congratulation!
