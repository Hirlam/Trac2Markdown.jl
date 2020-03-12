```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2011/Lecture/Installation/LocalChanges?action=edit"
```
# Local Changes In Your Experiment
You can make changes to the base system you set up with 'Harmonie setup ...' by adding changed files to your experiment directory $HOME/hm_home/$EXP.

This works by recreating the directory layout you'll find under the checked out subversion sources (partially reproduced here) under your experiment directory:
```bash
./nam
...
./scr
./const
...
./config-sh
./util
./util/oulan
./util/makeup
./util/gl_grib_api
...
./util/gl
...
./util/auxlibs
...
./src/arp
./src/arp/phys_dmn
...
./msms
./sms
```
Put a updated file in the correct place in this local directory hierarchy, and it will be compiled and will be replacing the corresponding code in the executable. You only need the part of the directory layout that contains the changed file.

The command 'Harmonie setup' already makes use of this principle by creating the directories config-sh and sms in your experiment directory.