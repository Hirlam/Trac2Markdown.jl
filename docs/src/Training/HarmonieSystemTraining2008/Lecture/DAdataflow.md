```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Lecture/DAdataflow?action=edit"
```

# Overview of HARMONIE Upper Air and Surface Data Assimilation
## HARMONIE Analysis Steps
The following figure shows different schematic steps in the HARMONIE data assimilation system.  
It is worth to mention some differences between the observation pre-processing systems used by ECMWF/IFS (IFS), Météo France (MF),HARMONIE, and HIRLAM. Some of these differences are listed below:

| | Météo France | IFS | HARMONIE | HIRLAM |
| --- | --- | --- | --- | --- |
| data format/content | BUFR, but sometimes with own table | BUFR with WMO code | BUFR with WMO code | BUFR with WMO code |
| creation of ODB database | two steps using oulan and bator | one step, use of complex package bufr2odb | two steps using oulan and bator | no ODB for HIRLAM |
| blacklisting technique | during the creation of the ODB and screening | (may be) only during screening | during the creation of the ODB and screening | no blacklist for HIRLAM |
| .... | .... | .... | .... | .... |

### Preparation of the observations
 * In off-line experiment this step consists of extraction of observations from data archive. e.g, from MARS archive at ECMWF platform.
   * At ECMWF platform, the HARMONIE script (scr/WriteMARSreq) prepares the retrieval (retrin) file for MARS request
```bash
    WriteMARSreq -d $DATE -t $TIME -r $RANGE -o $OBSLIST -m ./retrin -z $BUFRFILE -g $GEOL
```
   * The variables above denote
     * DATE - analysis date
     * TIME - analysis time
     * RANGE - extraction time interval
     * OBSLIST - list of the observations to be extracted according to MARS definition; 
     * BUFRFILE - name of the extracted BUFR file
     * GEOL - Extraction of the model domain properties from the climate file as follows
```bash
  $BINDIR/domain_prop $CLIMDIR/m$MM -f -MAX_EXT > foo
     EASTEC=$( tail -1 foo | head -1 | sed 's/ //g' )
     NORTHEC=$( tail -2 foo | head -1 | sed 's/ //g' )
     WESTEC=$( tail -3 foo | head -1 | sed 's/ //g' )
     SOUTHEC=$( tail -4 foo | head -1 | sed 's/ //g' )
```
 * In operational run this step consists of fetching (/waiting for) the observations. In that case one can use the command “cat” to merge different observations in one BUFR file.  
 
### Observation pre-processing: OULAN + BATOR

The pre-processing step creates ODB (Observational Data Base) from various observation data files possibly in different formats.
 * Software: The programs used for pre-processing (Shufflebufr, oulan and BATOR) are not part of the IFS code. OULAN is a software developed at Meteo France to extract observations from their local database (BDM). The output of oulan (OBSOUL) is one of the inputs of bator. Bator is also software developed at Meteo France to generate the ODB (Observational DataBase) database for the ARPEGE/ALADIN/HARMONIE analysis system. ODB is a tailor made database software developed at ECMWF to manage very large observational data volumes through the IFS/4DVAR-system, and to enable flexible post-processing of this data [(Sami Saarinen, 2006)](http://old.ecmwf.int/services/odb/odb_overview.pdf). We use oulan to generate an OBSOUL file from different BUFR files (note you can easily change the oulan program to handle data in different format than BUFR. For example in OPLACE data processing some files are in netCDF format). OBSOUL file is an ASCII formatted file, the content of which is similar to that of the CMA (Central Memory Array, packing format actually in use in the HIRLAM data assimilation system). Normally the oulan program can be found among any export packages. Since we use a modified version of it, our version is placed under “util” directory in the repository, and rarely touched. HARMONIE BATOR originates from the MF export-pack. Figure bellow describes the mechanism of the observation pre-processing in HARMONIE DA. To sum it up, shufflebufr splits different observations into BUFR files, the oulan creates the OBSOUL file, and batodb (BATOR) creates the ODB file using satellite BUFR/GRIB/BIN files and the OBSOUL one.
 * Compilation: Oulan and Shufflebufr are compiled using Makefile. BATOR is compiled using gmakpack or makeup.
 * Scripts: !RunInit and !RunBatodb.
 * Input/output
   * oulan  input: BUFR files; output: the OBSOUL file in ASCII format
   * BATOR  input: OBSOUL (ASCII-formated) and BUFR/GRIB/BIN files; output: the ODB database
 * Shufflebufr splits different observations into separate BUFR files according the IFS observation type definition. Some of them (essentially those of conventional observations) are then fed to OULAN; the others go directly into BATOR.
 The splitting is done with the following command:
```bash
      $BINDIR/ShuffleBufr -i ${BUFRFILE} -s3 -a 
      where BUFRFILE – file containing all observations.
```
 * OULAN reads (primarily conventional observation) BUFR data and converts it into ASCII format OBSOUL files. Note, **we can make observation selection** in Oulan. More details about how to do data selection can be found [here (Randriamampianina, ALADIN/HIRLAM Workshop 2005)](http://owww.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt)
  1. make a namelist
```bash
    SDATE=`echo ${DTG} | cut -c 1-8`
    SHOUR=`echo ${DTG} | cut -c 9-10`
    cp ${HM_LIB}/nam/${f_OULANNML} ./${f_OULANNML}
    sed -e "s/DDATE/$SDATE/" \
        -e "s/HHOUR/$SHOUR/" ${f_OULANNML} >NAMELIST
```
  1. a constant file about station height. The original idea behind the use of this file was to have consistent station heights with ARPEGE, so MF data. 
```bash
    cp -f ${HM_LIB}/nam/Hongrie_meteo.lst   
```
  1. run oulan
```bash
    $BINDIR/oulan 
```
 * BATOR creates the ODB files using OBSOUL and other (satellite) data in BUFR/GRIB/BIN format. BATOR also includes also filtering (blacklisting) of parameters from stations of different observation types. To run the bator program one needs files containing blacklist rules/information, namelist(s), file containing information about observations and their format – refdata -, and some setting for the ODB environment.
  * refdata file: - depending on the needed observation 
```bash
     if [[ $SYNOP_OBS -eq 1 || $AIRCRAFT_OBS -eq 1 || \
              $BUOY_OBS -eq 1  || $TEMP_OBS -eq 1     || $PILOT_OBS -eq 1 ]]; then
           echo "conv     OBSOUL   conv             ${YMD} ${HH}">> refdata
	   ln -sf $WRK/oulan/OBSOUL ./OBSOUL.conv
     fi
     if [ $AMV_OBS -eq 1 ]; then
           echo "geow     BUFR     geowind          ${YMD} ${HH}">>refdata
	   ln -sf $WRK/oulan/sato7 ./BUFR.geow
     fi

     if [ $AMSUA_OBS -eq 1 ]; then
           echo "amsua    BUFR     amsua            ${YMD} ${HH}">>refdata
	   ln -sf $WRK/oulan/amsua ./BUFR.amsua
     fi
       ...
    Where XXX_OBS is set in scr/include.ass expressing our choice regarding the XXX observation. This is an other way of selecting observation to be used in the assimilation.
```
  * Namelists are needed for BATOR to deal with observations having format structure different than that of MF. For example to read local Seviri data in grib format, one should set some parameters (NLON_GRIB and NLAT_GRIB) in the NADIRS group. Note: If my last modifications will be accepted, we will need to set parameters in the mentioned group, so the use of this namelist become obligatory for “local” (outside MF) HARMONIE system. The namelist looks like this:
```bash
            &NADIRS
              LLPRINT=.false.,
              NBSAUT=0,
              NFREQ_SEV=5,
              NLON_GRIB=1400,
              NLAT_GRIB=600,
              LSEVIRIBIN=.TRUE.,
              LMFBUFR=.FALSE.,
              LIASILOC=.TRUE.,
;
```
  * Namelist to activate (bator)LAMFLAG (needed to extract the observations for the model + extension zone domain): one needs to fetch the bator_lamflag namelist using the following command
```bash
        lamflag_namelist VAR
```
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

       where:
       base – list of your ODB bases (base can be conv (for conventional data), amsu (ATOVS/AMSU-A,AMSU-B/MHS), sev (for Sevir), iasi, radarv (radar) for example).
              Important: If you would like to have more bases, do not forget to take that into consideration when generating the “refdata” file for BATOR to define which observations you would like to have in each base.
```
 
 === Surface analysis – CANARI ===
    - Configuration: 701 of the IFS/ARPGE/ALADIN/AROME/HARMONIE
    - Script name: !RunCanari
    - Compilation: Use of the gmkpack or makeup
    - Executable:  ALDODB or AROMODB or MASTERODB
    - Input/output: On top of few constant files, inputs are the first-guess file and an extended ODB (ECMA) database. Output of CANARI is an analysis file with updated/analysed surface fields. Note that thanks to the optimum interpolation properties, observations can be situated outside the model domain. Hence, ECMA database for CANARI is prepared by bator using special lamflag settings.

     - We use CANARI to do (surface) analysis of temperature and humidity at 2m. Our current setting requires diagnosed fields for skin temperature and soil water content, which are from the ECMWF analysis. Before running the master program, we need to do some preliminary preparations:
 
       -- Set the input database 
```bash
   d_DB=$WRK/odb_can
```
       -- Merge the ODB sub-bases i.e. create an ECMA virtual base with conventional observations only.
```bash
   RunMerge -s CANARI
```
       -- Fetching the first-guess file
```bash
  ln -sf  $WRK/first_guess ICMSHANALINIT
  ln -sf ICMSHANALINIT ELSCFANALALBC000
```
       
       -- Fetching constant files
```bash
	  cp -f ${HM_LIB}/const/sa_const/POLYNOMES_ISBA fort.61  
        where:
          POLYNOMES_ISBA is a file used to derive soil moisture from 2m increment
```
       -- Set the climatological files
```bash
        cp -f ${CLIMDIR}/m${mm} ICMSHANALCLIM 
        cp -f ${CLIMDIR}/m${M2} ICMSHANALCLI2 
```
        There is possibility to use increment for water content created at the end of the previous analysis to smooth the fields (ICMSHANALLISSEF). This relaxation technique is not used in the current version of CANARI.
```bash
        # ln –s increment_file ICMSHANALLISSE
```
       -- ODB settings for CANARI
```bash
        export ODB_CMA=ECMA
        export ODB_ANALYSIS_DATE=${YMD}
        export ODB_ANALYSIS_TIME=${HH}0000
        export ODB_IO_METHOD=1
        export ODB_STATIC_LINKING=1
        export ODB_MERGEODB_DIRECT=1
        export BASETIME=$DTG
        export ODB_ECMA_CREATE_POOLMASK=1
        export ODB_ECMA_POOLMASK_FILE=ECMA.poolmask
	export ODB_SRCPATH_ECMA=${d_DB}/ECMA
	export ODB_DATAPATH_ECMA=${d_DB}/ECMA
	export IOASSIGN=${d_DB}/ECMA/IOASSIGN
```
       -- Fetch the namelist
```bash
	sed -e "s/_NPROC_/${NPROC}/g" \
	 ${HM_LIB}/nam/namel_canari > fort.4 
```
   - Running the master for CANARI
```bash
       $MPPEXEC $BINDIR/$MODEL -c701 -maladin -vmeteo -eANAL -t1. -ft0 -asli -procs ${NPROC} 
       where: MODEL=ALDODB or AROMODB or MASTERODB;
        -c: configuration (screening = 701)
        -v: version of the code (always “meteo” for ARPEGE/ALADIN/HARMONIE)
        -m: aladin for LAM
        -e: experiment name (ANAL for instance)
        -t: time-step length (“1.” for canari)
        -f: duration of the integration (“t0” or “h0” for canari)
        -a: dynamical scheme (does not matter, Eulerian = “eul”
            or semi-Lagrangian = “sli”
        -procs: needs number of processors ${NPROC}
```

 See [Trojakova, 2008](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow/Trojakova_canari_2.ppt) for more details on the Canari and its exploitation.
 
 === Observation screening ===
    - Configuration: 002 of the IFS/ARPGE/ALADIN/AROME/HARMONIE
    - Script name: !RunScreening 
    - Compilation: Use of the gmkpack or makeup
    - Executable:  ALDODB or AROMODB or MASTERODB
    - Input/output: On top of constant files, inputs are the first-guess file and an extended ODB (ECMA). As output of the screening, we can get compressed ODB (CCMA, containing only active observations) and/(or just) an updated version (with status and obs departures) of the extended ODB (ECMA).
    - Observation screening is the last step of the observation-processing in variational analysis. Before running the master program, we need to do some preliminary preparation:
        -- Merge the ODB sub-bases i.e. create an ECMA virtual base. For that we
           use the RunMerge script the following way:
```bash
   ${d_SCR}/RunMerge -s SCREENING
```
        -- Set the input and output ODB
           d_DBVAR=$WRK/odbvar      # input/output ODB containing all observations this is ECMA directory
           d_DB_OUT=$WRK/odb_ccma   # output, when the environment parameter ODB_CCMA_CREATE_DIRECT is set to 1
	-- Copy the ODB for Screening
```bash
           InitDir $d_DB $d_DBVAR   # d_DB is supposed to be located under Bator workdir
```
        -- Fetching the guess
```bash
          ln -sf $WRK/first_guess ICMSHMIN1INIT
```
        -- Set files needed for the configuration (settings related to "MIN1" experiment- IFS/A/A/A convention) 
```bash
          ln -sf ICMSHMIN1INIT ICMSHMIN1IMIN
          ln -sf ICMSHMIN1INIT ICMRFMIN10000
          ln -sf ICMSHMIN1INIT ELSCFMIN1ALBC000
          ln -sf ICMSHMIN1INIT ELSCFMIN1ALBC
```
        -- Fetching constants
```bash
        if [ $LVARBC = "T" ]; then

         BEG_DIFF=`mandtg $DTG - $DTGBEG`
         if [ "$VARBC_COLD_START" == "yes" -a $BEG_DIFF -gt 30 -o "$VARBC_COLD_START" == "no" ]; then

          [[ -s $WRK/VARBC.cycle ]] || \
          { echo "You don t have VARBC table from the earlier run \
            please check the content of your WORKDIR " ; exit 1 ; }

          cp $WRK/VARBC.cycle  ./VARBC.cycle

         fi

        else
         cp ${HM_LIB}/const/bias_corr/bcor_noaa.dat bcor_noaa.dat
         cp ${HM_LIB}/const/bias_corr/bcor_mtop.dat bcor_mtop.dat
        fi

 	cp ${HM_LIB}/const/bias_corr/correl.dat  correl.dat
 	cp ${HM_LIB}/const/bias_corr/sigmab.dat  sigmab.dat
 	cp ${HM_LIB}/const/bias_corr/rszcoef_fmt rszcoef_fmt
 	cp ${HM_LIB}/const/bias_corr/errgrib0scr errgrib
        cp ${HM_LIB}/const/sat_const/rt_coef_atovs_newpred_ieee.dat rt_coef_atovs_newpred_ieee.dat
        cp ${HM_LIB}/const/sat_const/var.sat.noaa_chanspec.11 chanspec_noaa.dat
 	cp ${HM_LIB}/const/sat_const/var.sat.noaa_rmtberr.11 rmtberr_noaa.dat
 	cp ${HM_LIB}/const/sat_const/rmtberr_airs.dat  rmtberr_airs.dat
 	cp ${HM_LIB}/const/bias_corr/cstlim_noaa.dat  cstlim_noaa.dat
        -- RTTOV coefficients 
        cp ${HM_LIB}/const/sat_const/rtcoef_* . # (you are under you workdir for screening)
        -- For radiosonde bias correction
	  for tabfile in table1 table2 table3;do
		cp ${HM_LIB}/const/bias_corr/$tabfile . # (you are under you workdir for screening)
          done
```
        -- ODB settings for screening
```bash
        export ODB_CMA=ECMA
        export ODB_SRCPATH_ECMA=${d_DBVAR}/ECMA
        export ODB_DATAPATH_ECMA=${d_DBVAR}/ECMA
        export ODB_ANALYSIS_DATE=${YMD}
        export ODB_ANALYSIS_TIME=${HH}0000
        export ODB_ECMA_POOLMASK_FILE=${d_DBVAR}/ECMA/ECMA.poolmask
```
        If the parameter ODB_CCMA_CREATE_DIRECT is set to 1, then we request for
        the CCMA (compressed ODB data containing only active observations)
        database.
```bash
        mkdir -p ${d_DB_OUT}/CCMA
       	export ODB_SRCPATH_CCMA=${d_DB_OUT}/CCMA
       	export ODB_DATAPATH_CCMA=${d_DB_OUT}/CCMA
       	export ODB_CCMA_POOLMASK_FILE=${d_DB_OUT}/CCMA/CCMA.poolmask
       	export IOASSIGN=${d_DB_OUT}/CCMA/IOASSIGN
	cd ${d_DB_OUT}/CCMA
        --  Creating the IOASSIGN file needed for CCMA database:
       	rm -f ${IOASSIGN}
        $HM_LIB/scr/create_ioassign -l "CCMA" -n ${NPROC}
        grep ECMA ${d_DBVAR}/ECMA/IOASSIGN >> ${IOASSIGN} 
```
         In case the parameter ODB_CCMA_CREATE_DIRECT is not set, or is set to 0,
         we will only get the extended ODB (ECMA) database. In this case our
         IOASSIGN remains the one with ECMA    
```bash
        	export IOASSIGN=${d_DBVAR}/ECMA/IOASSIGN
```
        -- Prepare namelist
```bash
         sed -e "s/NBPROC/${NPROC}/" \
          -e "s/NBPROMA/${NBPROMA}/" \
          -e "s/mbxsize/${MBXSIZE}/" ${HM_LIB}/nam/namel_screening > fort.4
```
      - Running the master for screening
```bash
        $MPPEXEC $BINDIR/$MODEL -c002 -maladin -vmeteo -eMIN1 -t001 -ft0 -asli -procs ${NPROC} 
        where:
          MODEL=ALDODB or AROMODB or MASTERODB;
        -c: configuration (screening = 002)
        -v: version of the code (always “meteo” for ARPEGE/ALADIN/HARMONIE)
        -m: aladin for LAM
        -e: experiment name (MIN1 for instance)
        -t: time-step length (“1.” for screening)
        -f: duration of the integration (“t0” or “h0” for screening)
        -a: dynamical scheme (does not matter for screening, Eulerian = “eul”
            or semi-Lagrangian = “sli”
        -procs: needs number of processors ${NPROC}
```
 See also  [(Randriamampianina, ALADIN/HIRLAM Workshop 2005)](http://owww.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt) for more details on the processes during the sreening.
 
### Variational analysis - minimisation
    - Configuration: 131 of the IFS/ARPGE/ALADIN/AROME/HARMONIE
    - Script name: !RunMInim 
    - Compilation: Use of the gmkpack
    - Executable:  ALDODB or AROMODB or MASTERODB
    - Input/output: On top of few constant files, input files for the minimisation are compressed ODB database (CCMA), the first-guess  file, the coefficients/table files for bias correction, and the background error statistics files. Output files are the updated compressed ODB database (with analysis increments), updated coefficients and table files for bias correction, and an analysis file.
    - During this step we do the upper-air analysis, by solving the variational equation. Like in other previous steps before running the master program, here we need to do some preliminary preparations as well:
        -- Define the input ODB
```bash
   d_DB_MINIM=$WRK/odb_ccma
```
        -- Check and fetch the  background error statistics
```bash
           for F in $f_JBCV $f_JBBAL ; do
              [[ -s  ${HM_LIB}/const/jb_data/$F.gz ]] || \
              Access_lpfs -from $JBDIR/$F.gz ${HM_LIB}/const/jb_data/. 
           done
	   #--- background error stat
	   gunzip -c ${HM_LIB}/const/jb_data/$f_JBCV.gz > stabal96.cv 
	   gunzip -c ${HM_LIB}/const/jb_data/$f_JBBAL.gz > stabal96.bal 
```
        -- fetching the guess
```bash
          cp ${WRK}/first_guess ./ICMSHMIN1INIT
```
        -- Set files needed for the configuration (settings related to "MIN1" experiment- IFS/A/A/A convention)
```bash
          ln -sf ICMSHMIN1INIT ICMSHMIN1IMIN
          ln -sf ICMSHMIN1INIT ICMRFMIN10000
          ln -sf ICMSHMIN1INIT ELSCFMIN1ALBC000
          ln -sf ICMSHMIN1INIT ELSCFMIN1ALBC
```
	-- Fetching constant files
```bash
          if [ $LVARBC = "T" ]; then

           BEG_DIFF=`mandtg $DTG - $DTGBEG`

             [[ -s $WRK/VARBC.cycle ]] || \
             { echo "You don t have VARBC table from the earlier run \
               please check the content of your WORKDIR " ; exit 1 ; }

             ln -s $WRK/VARBC.cycle  ./VARBC.cycle

          fi

          cp ${HM_LIB}/const/bias_corr/rszcoef_fmt	rszcoef_fmt
          cp ${HM_LIB}/const/sat_const/rt_coef_atovs_newpred_ieee.dat rt_coef_atovs_newpred_ieee.dat
          cp ${HM_LIB}/const/sat_const/rmtberr_airs.dat  rmtberr_airs.dat
          cp ${HM_LIB}/const/sat_const/var.sat.noaa_chanspec.11 chanspec_noaa.dat
          cp ${HM_LIB}/const/sat_const/var.sat.noaa_rmtberr.11 rmtberr_noaa.dat
          cp ${HM_LIB}/const/bias_corr/cstlim_noaa.dat  cstlim_noaa.dat
          #--- RTTOV coeffs
          cp ${HM_LIB}/const/sat_const/rtcoef_* .
          #--- RADIOSONDE BIAS CORRECTION
          for tabfile in table1 table2 table3;do
                cp ${HM_LIB}/const/bias_corr/$tabfile .
          done
```
	-- Check the input ODB and set the needed environment 
```bash
	   CheckDir ${d_DB_MINIM}
	   #--- ODB settings for 3dvar
	   export ODB_CMA=CCMA
	   export ODB_SRCPATH_CCMA=${d_DB_MINIM}/CCMA
	   export ODB_DATAPATH_CCMA=${d_DB_MINIM}/CCMA
	   export IOASSIGN=${d_DB_MINIM}/CCMA/IOASSIGN
```
	-- Set the namelist
```bash
	   sed -e "s/NBPROC/${NPROC}/"    \
               -e "s/NREDNMC/${REDNMC}/"  \
               -e "s/NBPROMA/${NBPROMA}/" \
               -e "s/mbxsize/${MBXSIZE}/" \
	       ${HM_LIB}/nam/namel_minim > fort.4 
```
        -- Execute the master program
```bash
           $MPPEXEC $BINDIR/$MODEL -c131 -maladin -vmeteo -eMIN1 -t001 -ft0 -asli -procs ${NPROC}
           where:
           MODEL=ALDODB or AROMODB;
           -c: configuration (screening = 002)
           -v: version of the code (always “meteo” for ARPEGE/ALADIN/HARMONIE)
           -m: aladin for LAM
           -e: experiment name (MIN1 for instance)
           -t: time-step length (“1.” for screening)
           -f: duration of the integration (“t0” or “h0” for screening)
           -a: dynamical scheme (does not matter for screening, Eulerian = “eul”
            or semi-Lagrangian = “sli”
           -procs: needs number of processors ${NPROC}
```
       -- Save the VarBC coefficients
```bash
         if [ $LVARBC = "T" ]; then
           #--- save VARBC tables
           cp -f VARBC.cycle $ARCHIVE/.
         fi
```

Details about the minimization procedure can be found [here (Desroziers, ALADIN/HIRLAM Workshop 2005)](http://owww.met.hu/pages/seminars/ALADIN2005/30_minim_GeraldDesroziers.ppt), and [here (Fischer, ALADIN/HIRLAM Workshop 2005)](http://owww.met.hu/pages/seminars/ALADIN2005/25_technical_ClaudeFischer.ppt)
 
### Observation post-processing
    - Configuration: Although the program (MANDALAY) used to post-process the assimilation can be found among the IFS/ARPEGE/ALADIN/AROME/HARMONIE codes, it does not have any configuration number.
    - Script name: RunAssPos (to be created !!!) 
    - Compilation: Use of the gmkpack. Note that the MANDALAY with the below settings (export VERSION=1) does not have the proper sql request (mandalay.sql), since this is the user-defined version. To compile mandalay with this option, one needs to compile it with user-defined mandalay.sql placed in the following directories: ./odb/ddl.ECMA; ./odb/ddl.CCMA, and ./odb/ddl.ECMASCR.
    - Executable:  MANDALAY 
    - Input/output: Inputs for this procedure are the extended (ECMA) and the compressed (CCMA) ODB databases. The two generated outputs are in ascii format (ecma_full.dat and ccma_full.dat).
    - Purpose of the post-processing job is to monitor the functionality of data pre- and processing (screening), as well as the analysis performance. The script looks as follows:
```bash
      #  Extraction of the extended ODB (ECMA)
        SUBVERSION=0
        export VERSION=1
        #export DEGREE=0  # unfortunately in this case (VERSION=1,SUBVERSION=0), we cannot get latitude and longitude in degrees, one should use degrees function in the sql request for that.
        export ODB_CMA=ECMA
        for base in $types_BASE;don
            cd $WRK/odbvar/ECMA.$base
            ${BINDIR}/MANDALAY
            grep -v : fic_odb.lst >> $ARCHIVE/ecma_$base_$DTG
        done
       #  Extraction of the compressed OBD after screening (CCMA)
          SUBVERSION=0
          export VERSION=1
          #export DEGREE=0
          export ODB_CMA=CCMA
          cd $WRK/odb_ccma/CCMA
          ${BINDIR}/MANDALAY
          grep -v : fic_odb.lst > $ARCHIVE/ccma_$DTG

```
## Hands on practice task
Exercises on observation usage in data assimilation will be divided into two parts:

Recommendations about possible ways on doing the tasks are given. Please, read them carefully before choosing and starting the experiment.

### Mandatory test of the DA cycling. 
(Should not require source code and namelist modification)

This task has two purposes: -to validate all steps in DA system, and to prepare ODB databases for testing diagnosis and monitoring tools. Feel free to choose, which kind of analysis to do (you can do surface analysis only, variational only, or both of them). See at [ here](https://hirlam.org/trac/wiki/Harmonie_33h0#NewfeaturesandfunctionalitieswithHarmonie-33h0) how to create your experiment and request for cycling run in a period. Don't forget to check in [ config_exp.h](https://hirlam.org/trac/browser/tags/harmonie-33h0/sms/config_exp.h) your system settings before starting your experiment. In order to diagnose each step in your assimilation, I suggest you to copy all [relevant scripts](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow) into your experiment directory. Check each executable so, that you will surely save the “standard output” and “standard error” output. This is important for BATOR for example. 

    Tasks related to this run:
     a- check the functionality of each executable in the DA steps

     b- extract the following parameters from you screened ODB: longitude, latitude (both in degrees), observation type, number of the variable , and the blacklist status related to the variable. [possible help](http://www.cnrm.meteo.fr/gmapdoc/meshtml/DOC_odb/FRANCAIS/CY_32r1/gp_tables.html#hdr) about variables in ODB.  
  How I did it:
1- Create The experiment directory:
   mkdir -p $HOME/hm_home/HTEST
2- Enter your experiment directory
   cd  $HOME/hm_home/HTEST
3- Setup your syytem
    ~nhz/Harmonie setup -r ~nhz/harmonie_release/33h1
4- Do our cycling:
    ~nhz/Harmonie start  DTG=2007020100 DTGEND=2007020318
5- You can find your output on hpce:
       - $TEMP/HTEST/archive

### Second exercises
Please choose one of the exercises listed below (all somehow need code, namelist, source data, or script modification).

**a- (Easy): Single observation experiment using aircraft measurements.**

                    How to do it:
          Create an OBSOUL file (tip: you can save OBSOULs file from the exercise 1.)

          Choose one aircraft report (help: in OBSOUL, except the first line, second value in the line is the observation type number, and the obstype for aircraft is “2”). Taking the whole line you have all observation from the report you have chosen. Here is one example of such a line:
```bash

  22 2 10077144    43.73000     1.61000  'EU9967  '  20080226 213100 2160.000000 2 11111 0  2 2160.000000 0.1699999976E+39 273.8999939 4111  3 2160.000000 9.300000191 305.0000000 4111

```
Each report has a header of 12 elements (the 11-th and the 12-th element are not so important). See [this presentation](http://owww.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt) to know more about content of the OBSOUL file. So here is the header
```bash

22 2 10077144    43.73000     1.61000  'EU9967  '  20080226 213100 2160.000000  2 11111 0

```
But you need only one observation. In each report the first value is the number of elements in the report, including itself. Now you choose your single observation. The 10-th element indicates the number of measured parameters (bodies) in the report. In this example we have “2” parameters. Each body has 5 elements, and the first value is the variable name (varno in ODB). So you can choose varno=2 (temperature), or varno=3 (wind). Let choose temperature, and we will have 22-5 elements in the report. So your OBSOUL looks like this:
```bash

20080227 0
17 2 10077144    43.73000     1.61000  'EU9967  '  20080226 213100 2160.000000 1 11111 0  2 2160.000000 0.1699999976E+39 273.8999939 4111

```
That's it! Now use this as observation. You need to change the RunInit script to use only this OBSOUL. Choose another day and choose wind measurement. If you find it too simple then cheat the model and use the wind measurement as !Geowind data (obstype=3). If you find this exercise interesting, then continue with plotting the analysis increment field around your measurements level. 

**b- (A bit difficult)** Blacklist the following stations from radiosonde measurements “01384 -Oslo Gardermoen”, “02571 – Norrkoping”, “11816 – Bratislava”, “02963 – Jokioinen”.
  Tips:
     1-change the content of your  LISTE_NOIRE_DIAP. If you need help see this [ presentation](http://owww.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt) about the blacklist rules using LISTE_NOIRE_DIAP.
     2- change the file ./bla/mf_blacklist.b
    Plot analyses difference between run with and without your change. Good luck!

**c- (difficult) use only temperature measurement from the following stations**  “01384 -Oslo Gardermoen”, “02571 – Norrkoping”, “11816 – Bratislava”, “02963 – Jokioinen”.
Tip: Create new rule of blacklisting for your stations and change accordingly the content of your LISTE_NOIRE_DIAP. To do so, change the subroutine bator_saisi elndiap in bator_saisies_mod.F90.
Plot the impact of your modification. Good luck for this exercise as well!

**d- (Easy) Do single observation analysis with CANARI** (never tested, might not work due to box checking, but why not to try?).
   Tip: Follow the instructions given in exercise “a-”, and instead of aircraft (obstype=2), choose SYNOP (obstype=1). Problem might occur due to dependency / or completeness of observations, so take one report with all bodies/parameters. But control your choice in namelist of CANARI. Plot the increment field.

**e- Single observation using one AMSU-A channel 7:** 
Here is the content of the OBSOUL file.
```bash
 20080215 12
 32 7 10000210  60.00000  0.00000  '     209'
 20080215 120000  1.7000000E+38 4 11111 0 
 200   3.000000       60.00000       15.00000          999999
 200   825400.0       1.880000       76.03000          999999
 200   90.43000      -105.2400      1.7000000E+38      999999
 119   7.000000   1.7000000E+38   217.771786212    32783
```

**f- Experiments with modified VARBC coefficients:**
 Here one example of how to change the default setting for radiance VARBC. See the example bellow to switch off certain predictors.

```bash
!! AMSUA
&NAMVARBC
  LBC_PRED_RAD1C(3,7,5)=.FALSE.,
/
 
```

first eøement - "3" - shows the satellite sensor (AMSU-A);
second element - "7" - the channel number;
third element - "5" - the number of the predictor.

Check [this routine](https://hirlam.org/trac/browser/trunk/harmonie/src/arp/module/varbc_rad.F90) to see which predictors are used for which sensors and channels. And check [this routine](https://hirlam.org/trac/browser/trunk/harmonie/src/arp/module/varbc_pred.F90) and also [this routine](https://hirlam.org/trac/browser/trunk/harmonie/src/arp/module/varbc_pred.F90) to know more about the VarBC predictors.


### Questions  

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the in page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)