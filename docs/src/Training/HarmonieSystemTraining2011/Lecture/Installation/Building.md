```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/Building?action=edit"
```
# Building the HARMONIE system
The rest is amazingly simple.  Even if you would not have input data at all yet, you can already build the HARMONIE software by simply doing the following:
```bash
cd $HOME/hm_home/$EXP    # change directory to your experiment directory.
export NPROC=8           # 8 threads to build (useful on a four-core machine).
~/svn/harmonie-36h1.4/config-sh/Harmonie start DTG=2011090100  # Fictitious date.
```
This will pop up a miniSMS window driven by mXCdp, which allows you to follow the progress of the build (Ole Vignes will explain this in detail in the next talk).

If you are only interested in building the executables, you could also use:
```bash
cd $HOME/hm_home/$EXP    # change directory to your experiment directory.
export NPROC=8           # 8 threads to build (useful on a four-core machine).
~/svn/harmonie-36h1.4/config-sh/Harmonie install
```

With Kbuntu-laptop, it appears that by default 'sh' is a link to /bin/dash, this will cause syntax error with many of the HIRLAM/HARMONIE scripts where 'set -k' is specified. Switching 'sh' linking to /bin/bash avoids this problem.