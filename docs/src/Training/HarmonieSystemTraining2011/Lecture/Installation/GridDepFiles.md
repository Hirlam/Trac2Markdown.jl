```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/GridDepFiles?action=edit"
```
# Grid Dependent Files (the background error statistics)

The method to generate background error statistics is described in [this page](../../../../HarmonieSystemDocumentation/Structurefunctions.md).

Magnus Lindskog will detail the steps in this procedure later this week.

To make them accessible for your HARMONIE experiments, you have to indicate where they are; in my case I stored them in $HOME/jbdata, which looks like this:
```bash
$ ls -l *.gz
-rw-r----- 1 harmonie harmonie 7505367 Sep 13 12:07 stabfiltn_NETHERLANDS_20060920_168.bal.gz
-rw-r----- 1 harmonie harmonie 3331504 Sep 13 12:20 stabfiltn_NETHERLANDS_20060920_168.cv.gz

```
The HARMONIE experiments learn about this location via the script 'include.ass', which has to reside in your scr subdirectory of your experiment directory (i.e., in $HOME/hm_home/$EXP/scr).

My experiments have this addition (with respect to the version in the 36h1.4 repository):
```bash
$ diff ~/svn/harmonie-36h1.4/scr/include.ass .
141a142,145
> elif [ "$DOMAIN" == "NETHERLANDS" ]; then
>    JBDIR=$HOME/jbdata
>    f_JBCV=stabfiltn_NETHERLANDS_20060920_168.cv
>    f_JBBAL=stabfiltn_NETHERLANDS_20060920_168.bal
```
[ Note that the names are given without the .gz suffix ! ]