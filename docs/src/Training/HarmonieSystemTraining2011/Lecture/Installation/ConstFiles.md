```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/ConstFiles?action=edit"
```
# Constant Files (Climate File Generation)

The directory with geographical data to generate climatological soil property files is pointed to by the environment variable HM_CLDATA in Env_system.

At ECMWF, on c1a, this data can be found in:
```bash
/ms_perm/hirlam/harmonie_climate
```
To use it locally, tar and gzip this directory and unpack it on your system, and make HM_CLDATA in script Env_system point to the directory you unpacked it into.

For the LinuxPC-MPI configuration, the default for this locations is $HOME/climdata; it looks like this:
```bash
$ ls -l
total 36
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 abc_O3
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 aero_tegen
drwxr-x--- 4 harmonie harmonie 4096 Oct  3  2008 CLIM_G
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 GLOB95
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 GTOPT030
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 N108
drwxr-x--- 2 harmonie harmonie 4096 Oct 10  2008 PGD
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 SURFACE_G
drwxr-x--- 2 harmonie harmonie 4096 Oct  3  2008 SURFACE_L
```