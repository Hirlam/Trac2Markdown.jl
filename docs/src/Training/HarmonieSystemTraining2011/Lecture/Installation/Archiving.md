```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/Archiving?action=edit"
```
# Archiving after a successful run
After a cycle completes successfully, the results (data and log files) are archived.

Archiving takes place under the directory $HM_DATA/archive on a local installation and in ECFS under ectmp:harmonie/$EXP at ECMWF (or ec:harmonie/$EXP if you specified it like that in sms/config_exp.h).

For example (local installation), relative to $HM_DATA:
```bash
$ ls -l archive/2010/01/14/00
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 14:23 AROMOUT_.0000.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 14:37 AROMOUT_.0001.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 14:52 AROMOUT_.0002.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 15:08 AROMOUT_.0003.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 15:24 AROMOUT_.0004.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 15:40 AROMOUT_.0005.lfi
-rw-r--r-- 1 harmonie harmonie 84443136 Sep 17 15:55 AROMOUT_.0006.lfi
-rw-r--r-- 1 harmonie harmonie     1347 Sep 17 14:20 bdstrategy
-rw-r--r-- 1 harmonie harmonie    29264 Sep 17 15:56 Date_harmonie.log
-rw-r--r-- 1 harmonie harmonie     1523 Sep 17 15:56 Date_timing.dat
-rw-r--r-- 1 harmonie harmonie 41571844 Sep 17 15:56 fc2010011400+000grib
-rw-r--r-- 1 harmonie harmonie  8294160 Sep 17 15:57 fc2010011400+000grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+001grib
-rw-r--r-- 1 harmonie harmonie  8328120 Sep 17 15:57 fc2010011400+001grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+002grib
-rw-r--r-- 1 harmonie harmonie  8337720 Sep 17 15:57 fc2010011400+002grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+003grib
-rw-r--r-- 1 harmonie harmonie  8342760 Sep 17 15:57 fc2010011400+003grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+004grib
-rw-r--r-- 1 harmonie harmonie  8351040 Sep 17 15:57 fc2010011400+004grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+005grib
-rw-r--r-- 1 harmonie harmonie  8357880 Sep 17 15:56 fc2010011400+005grib_sfx
-rw-r--r-- 1 harmonie harmonie 42865396 Sep 17 15:56 fc2010011400+006grib
-rw-r--r-- 1 harmonie harmonie  8365080 Sep 17 15:56 fc2010011400+006grib_sfx
-rw-r--r-- 1 harmonie harmonie   152660 Sep 17 15:56 fld_fc_2010011400+006
-rw-r--r-- 1 harmonie harmonie  2288981 Sep 17 15:56 HM_Date_2010011400.html
-rw-r--r-- 1 harmonie harmonie  2576917 Sep 17 14:21 HM_MakeCycleInput_2010011400.html
-rw-r--r-- 1 harmonie harmonie   245670 Sep 17 15:57 HM_Postprocessing_2010011400.html
-rw-r--r-- 1 harmonie harmonie 44236800 Sep 17 14:23 ICMSHHARM+0000
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 14:37 ICMSHHARM+0001
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 14:52 ICMSHHARM+0002
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 15:08 ICMSHHARM+0003
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 15:24 ICMSHHARM+0004
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 15:40 ICMSHHARM+0005
-rw-r--r-- 1 harmonie harmonie 46080000 Sep 17 15:55 ICMSHHARM+0006
-rw-r--r-- 1 harmonie harmonie    11087 Sep 17 14:21 MakeCycleInput_harmonie.log
-rw-r--r-- 1 harmonie harmonie     1937 Sep 17 14:21 MakeCycleInput_timing.dat
-rw-r--r-- 1 harmonie harmonie    51437 Sep 17 15:57 Postprocessing_harmonie.log
-rw-r--r-- 1 harmonie harmonie     3987 Sep 17 15:57 Postprocessing_timing.dat
-rw-r--r-- 1 harmonie harmonie   228390 Sep 17 14:21 VARBC.cycle
```
which exhibits the general structure of the archive (whether under $HM_DATA/archive or ectmp:harmonie/$EXP):
```bash
YYYY/MM/DD/HH/<data-for-cycle-YYYYMMDD_HH>
```
After archiving is complete, the directory $HM_DATA/YYYYMMDD_HH and its contents are removed.