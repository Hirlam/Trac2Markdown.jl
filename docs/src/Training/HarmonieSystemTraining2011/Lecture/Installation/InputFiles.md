```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/InputFiles?action=edit"
```
# The Input Files (Boundaries and Observations)
The locations for boundaries and observation files are specified by you in the sms/config_exp.h file.

A common location is to have them in $HM_DATA/boundaries and $HM_DATA/observations, where $HM_DATA is given by default as $HOME/scratch/hl_home/$EXP, i.e., in your experiment-specific scratch area.

To deal with that using many experiments, I usually have a $HOME/boundaries and $HOME/observations filled with the real data, and link to them from the $HOME/scratch/hm_home/$EXP directory, or whatever I choose $HM_DATA to point to.

So, for me, this looks like (in $HM_DATA):
```bash
$ ls -l boundaries observations
lrwxrwxrwx 1 harmonie harmonie 25 Sep 12 11:57 boundaries -> /home/harmonie/boundaries
lrwxrwxrwx 1 harmonie harmonie 28 Sep 12 11:58 observations -> /home/harmonie/observations
```
with
```bash
$ ls $HOME/boundaries
an20100114_00+000    an20100114_00+000ve  fc20100114_00+003  fc20100114_00+009  fc20100114_00+015  fc20100114_00+021
an20100114_00+000md  fc20100114_00+000    fc20100114_00+006  fc20100114_00+012  fc20100114_00+018  fc20100114_00+024
```
and
```bash
$ ls $HOME/observations
ob2010011400  ob2010011403  ob2010011406  ob2010011409  ob2010011412  ob2010011415  ob2010011418  ob2010011421
```