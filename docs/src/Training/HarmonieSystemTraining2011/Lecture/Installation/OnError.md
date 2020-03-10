```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/OnError?action=edit"
```
# Where does everything end up on error ?
If, during a cycle for date/time YYYYMMDDHH, an error occurs, the input/output of the failing component is saved under a subdirectory Failed_<component> of $HM_DATA/YYYYMMDD_HH.

In our specific case (2010011406):
```bash
$ ls 20100114_06/
bdinput_0  bdstrategy        ELSCFHARMALBC002        fc_start_sfx  first_guess_dfi                    odb            odb_can_ori  super6413
bdinput_3  ELSCFHARMALBC000  Failed_AnSFC_RunCanari  FG_ADDSURF    first_guess_sfx                    odb_can        oulan        very_first_guess
bdinput_6  ELSCFHARMALBC001  fc_start                first_guess   HM_MakeCycleInput_2010011406.html  odb_can_merge  super6378    very_first_guess_sfx
```
which leads to:
```bash
$ ls 20100114_06/Failed_AnSFC_RunCanari/
ECMA.poolmask     ICMSHANALSST               rtcoef_gms_5_imager.dat       rtcoef_metop_2_amsua.dat  rtcoef_noaa_15_avhrr.dat  rtcoef_noaa_16_hirs.dat   rtcoef_noaa_18_hirs.dat
ELSCFANALALBC000  ifs.stat                   rtcoef_goes_10_imager.dat     rtcoef_metop_2_hirs.dat   rtcoef_noaa_15_hirs.dat   rtcoef_noaa_17_amsua.dat  rtcoef_noaa_18_mhs.dat
fort.4            List_odb                   rtcoef_goes_10_sounder.dat    rtcoef_metop_2_mhs.dat    rtcoef_noaa_15_msu.dat    rtcoef_noaa_17_amsub.dat  rtcoef_noaa_19_amsua.dat
fort.61           NODE.001_01                rtcoef_goes_11_imager.dat     rtcoef_msg_1_seviri.dat   rtcoef_noaa_15_ssu.dat    rtcoef_noaa_17_avhrr.dat  rtcoef_noaa_19_hirs.dat
ICMSHANALCLI2     rszcoef_fmt                rtcoef_goes_11_sounder.dat    rtcoef_noaa_15_amsua.dat  rtcoef_noaa_16_amsua.dat  rtcoef_noaa_17_hirs.dat   rtcoef_noaa_19_mhs.dat
ICMSHANALCLIM     rtcoef_adeos_2_amsr.dat    rtcoef_goes_12_imager.dat     rtcoef_noaa_15_amsua.new  rtcoef_noaa_16_amsub.dat  rtcoef_noaa_18_amsua.dat  rtcoef_trmm_1_tmi.dat
ICMSHANALINIT     rtcoef_envisat_1_atsr.dat  rtcoef_meteosat_8_seviri.dat  rtcoef_noaa_15_amsub.dat  rtcoef_noaa_16_avhrr.dat  rtcoef_noaa_18_amsub.dat
```
The forensics start here ...

However, one should also notice:
```bash
$ ls 36h14/Date/Hour/Cycle/Analysis/AnSFC/
RunCanari.1  RunCanari.job1  RunCanari.job1-q
```
because the final part of the output of the 'Canari' run is (in file $unCanari.1):
```bash
16:03:21         Debut analyses 

Program received signal 11 (SIGSEGV): Segmentation fault.

Backtrace for this error:
  + /lib/x86_64-linux-gnu/libc.so.6(+0x32480) [0x2b2b657d5480]
  + function canaco_ (0x1087FB7)
    at line 117 of file canaco.F90
  + function canari_ (0x9A042B)
    at line 339 of file canari.F90
  + function can1_ (0x998F1F)
    at line 150 of file can1.F90
  + function cnt0_ (0x5D5FB8)
    at line 210 of file cnt0.F90
  + function master (0x5A1871)
    at line 50 of file master.F90
```
This error is still under investigation.