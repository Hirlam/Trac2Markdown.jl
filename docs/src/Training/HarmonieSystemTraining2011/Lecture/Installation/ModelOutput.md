```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/ModelOutput?action=edit"
```
# Where does the output go (model output)
During a run, $HM_DATA looks like this:
```bash
$ ls -l
total 312
drwxr-xr-x 10 harmonie harmonie   4096 Sep 16 10:53 20100114_00
drwxr-x--x  5 harmonie harmonie   4096 Sep 16 10:53 36h14
drwxr-xr-x  4 harmonie harmonie   4096 Sep 16 08:47 archive
drwxr-xr-x  2 harmonie harmonie   4096 Sep 16 10:52 bin
lrwxrwxrwx  1 harmonie harmonie     25 Sep 12 11:57 boundaries -> /home/harmonie/boundaries
drwxr-xr-x  2 harmonie harmonie   4096 Sep 16 08:49 climate
-rw-r--r--  1 harmonie harmonie   6180 Sep 16 10:54 harmonie.check
-rw-r--r--  1 harmonie harmonie  25212 Sep 16 10:50 harmonie.def
-rw-r--r--  1 harmonie harmonie  31493 Sep 16 10:50 harmonie.html
-rw-r--r--  1 harmonie harmonie  48122 Sep 16 10:54 harmonie.log
-rw-r--r--  1 harmonie harmonie  21037 Sep 16 10:50 harmonie.tdfinc
-rw-r--r--  1 harmonie harmonie 126874 Sep 16 10:23 HM_Postprocessing_2010011400.html
drwxr-xr-x 12 harmonie harmonie   4096 Sep 16 08:36 lib
-rw-r--r--  1 harmonie harmonie   8806 Sep 16 10:50 _mSMS_env
-rw-r--r--  1 harmonie harmonie   5555 Sep 16 10:54 mSMS.log
lrwxrwxrwx  1 harmonie harmonie     28 Sep 12 11:58 observations -> /home/harmonie/observations/
```
On the c1a, $HM_DATA is $TEMP/hm_home/$EXP.

The model output goes into the directory with the name YYYYMMDD_HH (in this case 20100114_00), in a subdirectory named <hostname><pid>, with the <hostname> the name of the machine the executable is running on and <pid> the process identification of the process that started it.

In our case it is super17268:
```bash
$ ls -l super17268
-rw-r--r-- 1 harmonie harmonie       0 Sep 17 14:23 AROMOUT_.0000.des
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0000.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0000.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0001.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0001.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0002.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0002.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0003.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0003.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0004.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0004.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0005.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0005.lfi
lrwxrwxrwx 1 harmonie harmonie      61 Sep 17 14:21 AROMOUT_.0006.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/AROMOUT_.0006.lfi
lrwxrwxrwx 1 harmonie harmonie      60 Sep 17 14:21 ELSCFHARMALBC000 -> /scratch/harmonie/hm_home/36h14/20100114_00/ELSCFHARMALBC000
lrwxrwxrwx 1 harmonie harmonie      60 Sep 17 14:21 ELSCFHARMALBC001 -> /scratch/harmonie/hm_home/36h14/20100114_00/ELSCFHARMALBC001
lrwxrwxrwx 1 harmonie harmonie      60 Sep 17 14:21 ELSCFHARMALBC002 -> /scratch/harmonie/hm_home/36h14/20100114_00/ELSCFHARMALBC002
-rw-r--r-- 1 harmonie harmonie     263 Sep 17 14:21 EXSEG1.nam
-rw-r--r-- 1 harmonie harmonie       0 Sep 17 14:23 fort.10
-rw-r--r-- 1 harmonie harmonie    7167 Sep 17 14:21 fort.4
lrwxrwxrwx 1 harmonie harmonie      54 Sep 17 14:21 hiwif -> /scratch/harmonie/hm_home/36h14/20100114_00/fc_signals
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0000 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0000
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0001 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0001
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0002 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0002
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0003 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0003
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0004 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0004
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0005 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0005
lrwxrwxrwx 1 harmonie harmonie      58 Sep 17 14:21 ICMSHHARM+0006 -> /scratch/harmonie/hm_home/36h14/20100114_00/ICMSHHARM+0006
lrwxrwxrwx 1 harmonie harmonie      52 Sep 17 14:21 ICMSHHARMINIT -> /scratch/harmonie/hm_home/36h14/20100114_00/fc_start
-rw-r--r-- 1 harmonie harmonie    3333 Sep 17 14:29 ifs.stat
-rw-r--r-- 1 harmonie harmonie  213379 Sep 17 14:29 NODE.001_01
-rw-r--r-- 1 harmonie harmonie 1068558 Sep 17 14:22 OUTPUT_LISTING
-rw-r--r-- 1 harmonie harmonie       0 Sep 17 14:21 TEST.des
lrwxrwxrwx 1 harmonie harmonie      56 Sep 17 14:21 TEST.lfi -> /scratch/harmonie/hm_home/36h14/20100114_00/fc_start_sfx
```
* Input files:
  - ELSCFHARMALBC00n
    Boundary data file number n.
  - ICMSHHARMINIT
    Initial upper air data.
  - TEST.lfi
    Initial surface level data (SURFEX).

* Output files:
  - AROMOUT_.000n.lfi
    Output of surface level data (SURFEX) for hour n.
  - ICMSHHARM+000n
    Output of upper air data for hour n.