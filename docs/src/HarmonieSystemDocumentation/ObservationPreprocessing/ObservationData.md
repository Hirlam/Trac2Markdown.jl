```@meta
EditURL="https://hirlam.org/trac//wiki/HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData?action=edit"
```
# Observation data
In off-line experiments the Oulan script extracts observations from a data archive, e.g from MARS archive at ECMWF platform, or from existing observation files (BUFR/GRIB [seviri]/HDF5 [radar]) available locally.
# ECMWF
At ECMWF, the HARMONIE script [prepares the retrieval (retrin) file for MARS request. [source:Harmonie/scr/WriteMARSreq](https://hirlam.org/trac/browser/Harmonie/scr/WriteMARSreq]) is executed by [source:Harmonie/scr/Prepare_ob].
```bash
    WriteMARSreq -d $DATE -t $TIME -r $RANGE -o $OBSLIST -m ./retrin -z $BUFRFILE -g $GEOL
```
The variables above denote
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
## MARS contents
**Note:** by default, MARS observations are retrieved from the MARS TYPE# OB stream. ECMWF add late observations into MARS on a daily basis. MARS OB observations may also be updated with new observation types by ECMWF staff from time to time. eg E-AMDAR BUFR data were added at the end of June 2015 to TYPEOB data (observations from November 2014 - June 2015).Here are changes made to [source:Harmonie/scr/Prepare_ob] to retrieve E-AMDAR (OBSTYPE=146) data from AI/LWDA MARS BUFR:
```bash

     # Write request for Conventional data
     if [ "$OBSLIST" != ""]; then
+      # Write request for special case of E-AMDAR data in AI strem
+      if [ $AIRCRAFT_OBS -eq 1];then
+        AIDATE=`mandtg -date $DTG`
+        AIHOUR=`mandtg -hour $DTG`
+        [ $AIHOUR -ge  0 -a $AIHOUR -lt  3] && AIMHOUR=0000
+        [ $AIHOUR -ge  3 -a $AIHOUR -lt  9] && AIMHOUR=0600
+        [ $AIHOUR -ge  9 -a $AIHOUR -lt 15] && AIMHOUR=1200
+        [ $AIHOUR -ge 15 -a $AIHOUR -lt 21] && AIMHOUR=1800
+        if [ $AIHOUR -ge 21 -a $AIHOUR -le 23]; then
+         NXTDTG=`mandtg $DTG + 24`
+         AIDATE=`mandtg -date $NXTDTG`
+         AIMHOUR=0000
+        fi  
+        WriteMARSreq -p AI -d $AIDATE -t $AIMHOUR        -o 146    -m ./retrin                  -z ${BUFRFILE}ai
+        WriteMARSreq -p OB -d $DATE   -t $TIME -r $RANGE -o 146    -m ./filtin -i ${BUFRFILE}ai -z ${BUFRFILE}ai.146 -g $GEOL
+      fi
     fi
 
     # Write request for ATOVS and AMV over and extended area
@@ -150,6 +166,10 @@
     #--- MARS queue
     if [ -f retrin]; then
       mars retrin || { echo "MARS failed" ; exit 1 ; }
+      if [ $AIRCRAFT_OBS -eq 1];then
+        mars filtin || { echo "MARS FILTER failed" ; exit 1 ; }
+        cat ${BUFRFILE}ai.146 >> $BUFRFILE
+      fi
     else
       echo "No MARS request exists. Please select some observation types!"
     fi
```

# Local implementation
Otherwise, this step consists of fetching (or waiting for) the observations stored in $OBDIR defined in ecf/config_exp.h . In that case one can use the command “cat” to merge different observations into one BUFR file, ob${DTG}.  
 