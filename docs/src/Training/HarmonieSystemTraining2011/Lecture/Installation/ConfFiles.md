```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/ConfFiles?action=edit"
```
# Configuration Issues
To configure the HARMONIE system in your experiment directory ($EXP indicating the experiment name), do the following from your home directory:
```bash
mkdir -p hm_home/$EXP
cd hm_home/$EXP
~/svn/harmonie-36h1.4/config-sh/Harmonie setup -r ~/svn/harmonie-36h1.4/ -h LinuxPC-MPI
```
This results in:
```bash
config-sh/
Env_submit -> config-sh/submit.LinuxPC-MPI
Env_system -> config-sh/config.LinuxPC-MPI
sms/
```
and:
```bash
$ cat config-sh/hm_rev 
/home/harmonie/svn/harmonie-36h1.4/
```
points to the local checkout of the 36h1.4 tag repository.

Because the 36h1.4 tag was set during heavy development, the following was missed for the LinuxPC-MPI configuration, and has to be added to Env_system:
```bash
export GRIB_API=$HOME/grib_api          # directory for grib_api libraries
export GRIB_API_LIB="-L$GRIB_API/lib -lgrib_api_f90 -lgrib_api"
export GRIB_API_INCLUDE=-I$GRIB_API/include
```

Aside from this, the 'setup' command will extract the general "experiment configuration" to the 'sms' directory:
```bash
sms/config_exp.h
```
This file contains area/grid definitions and model, analysis, and boundary strategy options and has to be added to change these definitions to suite your experiment.