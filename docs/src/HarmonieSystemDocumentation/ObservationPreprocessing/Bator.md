```@meta
EditURL="https://hirlam.org/trac//wiki/HarmonieSystemDocumentation/ObservationPreprocessing/Bator?action=edit"
```
# ODB creation: Bator
## General Description
The pre-processing step creates ODB (Observational Data Base) from various observation data files possibly in different formats.
 * Software: The programs used for pre-processing (Shufflebufr, oulan and BATOR) are not part of the IFS code. oulan is software developed at Météo France to extract observations from their local database (BDM). The output of oulan (OBSOUL) is one of the inputs of BATOR. BATOR is also software developed at Météo France to generate the ODB (Observational !DataBase) database for the ARPEGE/ALADIN/HARMONIE analysis system. ODB is a tailor made database software developed at ECMWF to manage very large observational data volumes assimilated in the IFS 4DVAR system, and to enable flexible post-processing of this data [(Sami Saarinen, 2006)](http://old.ecmwf.int/services/odb/odb_overview.pdf). We use oulan to generate an OBSOUL file from different BUFR files (note you can easily change the oulan program to handle data in different format than BUFR. For example in OPLACE data processing some files are in netCDF format). OBSOUL file is an ASCII formatted file, the content of which is similar to that of the CMA (Central Memory Array, packing format actually in use in the HIRLAM data assimilation system). Our version of ouland is placed under “util” directory in the repository. HARMONIE BATOR originates from the MF export-pack. The figure bellow describes the mechanism of the observation pre-processing in HARMONIE DA. To sum it up, !ShuffleBufr splits different observations into BUFR files, then oulan creates the OBSOUL file, and BATOR creates the ODB file using satellite BUFR/GRIB/BIN files and the OBSOUL one.
 * Compilation: BATOR is compiled using gmakpack or makeup.
 * Scripts: Bator.
 * Input: OBSOUL (ASCII-formated) and BUFR/GRIB/BIN files
 * Output: ODB databases for surface and upper-air data assimilation

## BATOR
BATOR creates the ODB files using OBSOUL and other (satellite) data in BUFR/GRIB/BIN format. BATOR also includes filtering (blacklisting) of parameters from stations of different observation types. To run the BATOR program one needs files containing blacklist rules/information, namelist(s), file containing information about observations and their format – refdata -, and some setting for the ODB environment.
### refdata
The *refdata* file tells BATOR what observations types are to be processed.  *refdata* is written by the Bator script using environment variable defining observation types to be assimilated (set in scr/include.ass). The format of *refdat* is strictly defined and white space is important! The READ statement used to read the *refdata* file is:
```bash
 READ(NULOBI,'(a8,1x,a8,1x,a16,1x,i8,1x,i2,1x,a200)',IOSTAT=iret) &
     & TREF_FICOBS(j)%nomfic,TREF_FICOBS(j)%format,TREF_FICOBS(j)%type, &
     & TREF_FICOBS(j)%date,TREF_FICOBS(j)%heure,chaine(j)
```
where:
 * TREF_FICOBS(j)%nomfic = filename suffix
 * TREF_FICOBS(j)%format = input format (OBSOUL/BUFR/GRIB/HDF5)
 * TREF_FICOBS(j)%type   = observation type
 * TREF_FICOBS(j)%date   = date (YYYYMMDD)
 * TREF_FICOBS(j)%heure  = hour (HH)
 * chaine(j)             = not yet sure about what is read here ...
Below is an excerpt from the Bator script showing how *refdata* is written for conventional (OBSOUL) and AMSUA (BUFR) observation data:
```bash
     if [[ $SYNOP_OBS -eq 1 || $AIRCRAFT_OBS -eq 1 || \
              $BUOY_OBS -eq 1  || $TEMP_OBS -eq 1     || $PILOT_OBS -eq 1]]; then
           echo "conv     OBSOUL   conv             ${YMD} ${HH}">> refdata
	   ln -sf $WRK/oulan/OBSOUL ./OBSOUL.conv
     fi
     if [ $AMV_OBS -eq 1]; then
           echo "geow     BUFR     geowind          ${YMD} ${HH}">>refdata
	   ln -sf $WRK/oulan/sato7 ./BUFR.geow
     fi

     if [ $AMSUA_OBS -eq 1]; then
           echo "amsua    BUFR     amsua            ${YMD} ${HH}">>refdata
	   ln -sf $WRK/oulan/amsua ./BUFR.amsua
     fi
       ...
    Where XXX_OBS is set in scr/include.ass expressing our choice regarding the XXX observation. This is an other way of selecting observation to be used in the assimilation.
```

### param.cfg
BATOR reads BUFR data according to definitions describing BUFR templates in the *param.cfg* file. The general layout of definitions in the *param.cfg* file is as follows:
```bash
BEGIN sensor
a b c d
codage  a1  desc_a1
...
codage  an   desc_an
control b1   val1
...
control bn   valn
offset  c1   inc1
...
offset  cn   incn
values  pos_d1 desc_d1
...
values  pos_dn desc_dn
END sensor
```
where: 
 * a: number of unexpanded descriptors (NTDLEN if you are familiar with bufrdc software).
 * b: number of "control" entries - "control" values used by src/odb/pandor/module/bator_decodbufr_mod.F90
 * c: number of "offset" entries - "jump" values used by src/odb/pandor/module/bator_decodbufr_mod.F90
 * d: number of "values" entries - bufrdc VALUES array indices of parameters
 * codage desc: FXY's of NTDLST array values
 * values desc: FXY's of NTDEXP array values
Below is a simple example for temp BUFR:
```bash
BEGIN temp
1 0 1 21
codage     1  309052
offset     1  10
values     1  001001  WMO block number
values     2  001002  WMO station number
values     3  001011  station identifier
values     4  002011  Radiosonde type
values     9  004001  Year
values    15  005001  Latitude (high accuracy)
values    16  006001  Longitude (high accuracy)
values    17  007030  Height of station ground above mean sea level
values    19  007007  Height
values    29  031002  Extended delayed descriptor replication factor
values    28  022043  Sea/water temperature
values    30  004086  Long time period or displacement
values    31  008042  Extended vertical sounding significance
values    32  007004  Pressure
values    33  010009  Geopotential height
values    34  005015  Latitude displacement (high accuracy)
values    35  006015  Longitude displacement (high accuracy)
values    36  012101  Temperature/dry-bulb temperature
values    37  012103  Dew-point temperature
values    38  011001  Wind direction
values    39  011002  Wind speed
END temp
```
### Namelists
  * Namelists are needed for BATOR to deal with observations having format structure different than that of MF. For example to read local Seviri data in grib format, one should set some parameters (NLON_GRIB and NLAT_GRIB) in the NADIRS group. Note: If my last modifications will be accepted, we will need to set parameters in the mentioned group, so the use of this namelist become obligatory for “local” (outside MF) HARMONIE system. The namelist looks like this:
```bash
 &NADIRS
   LMFBUFR=.FALSE.,                                         # we are not using Météo France BUFR
   ASCAT_XYGRID=12500.,                                     # ASCAT XYGRID RESOLUTION /LR=25000m/HR=12500m/
   GPSSOLMETHOD="CENT",                                     # Selection method for GNSS data "CENT"/"MEAN"
   NbTempMaxLevels=6000,                                    # Maximum number of radiosonde levels read
   TempSondOrTraj=.FALSE.,                                  # .TRUE. = sondage vertical, .FALSE. = trajectoire
   TempSondSplit=.FALSE.,                                   # .TRUE. = on coupe le radiosondage/timeslot, .FALSE. = profil simple
   ElimTemp0=.FALSE.,                                       # suppression des TEMP sans delta lat/lon/time si .TRUE.
   ElimPilot0=.FALSE.,                                      # suppression des PILOT sans delta lat/lon/time si .TRUE.
   NFREQVERT_TPHR=100,                                      # thinning factor for radiosonde data
   NbMinLevelHr=300,                                        # level threshold for high-resolution treatement of sonde data
   TS_AMSUA(206)%t_select%ChannelsList(:) = -1,             # ...
   TS_AMSUA(206)%t_select%TabFov(:) = -1,                   # ...
   TS_AMSUA(206)%t_select%TabFovInterlace(:) = -1,          # ...
   :                                                        # :
   :                                                        # :
   :                                                        # :
   SIGMAO_COEF(1:18)=18*1.0,                                # Scaling of sigmo-o coefficients
 /
 &NAMSCEN
 /
 &NAMDYNCORE
 /
 &NAMSATFREQ
 /

```
  * Namelist to activate (bator) LAMFLAG (needed to extract the observations for the model + extension zone domain): one needs to fetch the bator_lamflag namelist using the following command
```bash
        lamflag_namelist VAR
```

```bash
 &NAMFCNT
   LOBSONLY=.FALSE.,
 /
 &NAMFGEOM
   EFLAT0=$LAT0,
   EFLON0=$LON0,
   EFLATC=$LATC,
   EFLONC=$LONC,
   EFLAT1=$LAT1,
   EFLON1=$LON1,
   EFDELX=$GSIZE,
   EFDELY=$GSIZE,
   NFDLUN=1,
   NFDGUN=1,
   NFDLUX=$NDLUXG,
   NFDGUX=$NDGUXG,
   Z_CANZONE=1500.,
   REDZONE=$REDZONE_BATOR,
   LVAR=$LVAR,
   LNEWGEOM=.TRUE.,
 /
 &NAMFOBS
   LSYNOP=$LSYNOP,
   LAIREP=$LAIREP,
   LDRIBU=$LDRIBU,
   LTEMP=$LTEMP,
   LPILOT=$LPILOT,
   LPAOB=$LPAOB,
   LSCATT=$LSCATT,
   LSATEM=$LSATEM,
   LSATOB=$LSATOB,
   LSLIMB=$LSLIMB,
   LRADAR=$LRADAR,
```

### Environment variables

  * ODB settings for batodb:
```bash
		export ODB_CMA=ECMA
		export ODB_SRCPATH_ECMA=${d_DB}/ECMA.${base}
		export ODB_DATAPATH_ECMA=${d_DB}/ECMA.${base} 
		export ODB_ANALYSIS_DATE=${YMD}
		export ODB_ANALYSIS_TIME=${HH}0000
		export IOASSIGN=${d_DB}/ECMA.${base}/IOASSIGN
		export BATOR_NBPOOL=${NPOOLS}

		#--- prepare db dir
		RecreateDir ${d_DB}/ECMA.${base}	   
		#-- create IOASSIGN file for the given sub-base
		cd ${d_DB}/ECMA.${base}	
		export ODB_IOASSIGN_MAXPROC=${NPOOLS}
		$HM_LIB/scr/create_ioassign -l "ECMA" -n ${BATOR_NBPOOL}
```
where $base is the ODB base ($base can be conv (for conventional data), amsu (ATOVS/AMSU-A,AMSU-B/MHS), sev (for Sevir), iasi, radarv (radar) for example).
Important: If you would like to have more bases, do not forget to take that into consideration when generating the “refdata” file for BATOR to define which observations you would like to have in each base.