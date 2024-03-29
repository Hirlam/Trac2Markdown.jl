```@meta
EditURL="https://hirlam.org/trac//wiki//MUSC?action=edit"
```

## MUSC using the develop branch (CY43) in the git repository

A revised MUSC environment is included with the Harmonie scripting system. A "reference" test, musc_ref, is available, idealized test cases (MF's ARMCU and 2 x freezing drizzle by BJKE) and a few fog cases by Sander Tijm. Normal, fast and slow ASTEX cases are also there but do not currently work on all platforms - this is under investigation. GABLS and RICO cases will be prepared in 2021. Instructions on how to use MUSC are included below.
See https://asr.copernicus.org/articles/17/255/2020/ for some information on HARMONIE-AROME experiments using MUSC but note that the scripts have changed somewhat since that paper was written.

**Set up MUSC**

 1. Get the code:
```bash
mkdir -p $HOME/harmonie_releases/git
cd $HOME/harmonie_releases/git
git clone https://git.hirlam.org/Harmonie -b develop develop ## This just clones the develop branch
cd develop
git branch
# If you already have a clone of the code but want to update it to the latest, use "git pull" rather than "git branch".
```

 2. Set up a MUSC experiment. In this example the METIE.LinuxRH7gnu system config file is used. Note that you need to use -c ecgb if running at ECMWF (ecgb)
```bash
mkdir -p $HOME/hm_musc/test_0001
cd $HOME/hm_musc/test_0001
$HOME/harmonie_releases/git/develop/util/musc/scr/musc_setup.sh -h
$HOME/harmonie_releases/git/develop/util/musc/scr/musc_setup.sh -r $HOME/harmonie_releases/git/develop -c METIE.LinuxRH7gnu
```

 3. Generate your namelist, unless you're using an idealised case with pre-defined namelists:
```bash
cd $HOME/hm_musc/test_0001
./musc_namelist.sh -h
./musc_namelist.sh -l <length of run> -i <the ID name on the generated namelist files e.g. DEF> -[a choice of aerosols - optional] -[r choice of radiation scheme - optional] -[N nudging - optional]
```

 4. Compile and run your experiment (still in $HOME/hm_musc/test_0001)
```bash
./musc_compile.sh -h
./musc_compile.sh -n 2   # n is the number of parallel make processes
                         # -- pick a sensible number for your laptop/PC/HPC
```

 5. Get a copy of the input files
```bash
cd $HOME
wget https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/MUSC/muscCY43InputData.tar.5.gz
gunzip muscCY43InputData.tar.5.gz
tar -xvf muscCY43InputData.tar.5
```

* Note that if you need to do experiments with 2 patches etc, ensure you derive some MUSC input files yourself using 3D HARMONIE-AROME files run with 2 patches. MUSC*REFL65* input files have only 1 patch. Changing MUSC namelists won't enable 2 patch output from a MUSC run.

**Run MUSC**

### Musc_ref

The reference test is a X-hr experiment (change CUSTOP in musc_namelist.sh if you wish to change the run length) and produces Out*lfa files for each model time-step of the time period. ICM* files are produced at each hour. 

 1. Run your experiment
```bash
cd $HOME/hm_musc/test_0001
./musc_run.sh -h
./musc_run.sh -d $HOME/muscCY43InputData/musc_ref -n REFL65 -i DEF [ -e ECOCLIMAP_PATH]
# optional path for ECOCLIMAP data may be given. For musc_ref -i must be given as no 
# namelists are provided with this experiment and must be generated before musc_run.sh 
# is executed. For the idealised cases, if -i is not specified -i becomes the name of 
# the idealised case once the namelist files are copied to $HOME/hm_musc/test_0001 e.g. 
# for armcu the namelist files become namelist_atm_armcu etc.

```

### ARMCU
This is an idealized SCM test case, the "Sixth GCSS WG-1 case (ARM—Atmospheric Radiation Measurement)", focussing on the diurnal cycle of cumulus clouds over land ([Brown et al, 2002](https://doi.org/https://doi.org/10.1256/003590002320373210,), [Lenderink et al, 2004](https://doi.org/10.1256/qj.03.122,). The input files and namelist settings have been taken from mitraillette (*arut*).

 1. Run your experiment
```bash
cd $HOME/hm_musc/test_0001
./musc_run.sh -h
./musc_run.sh -d $HOME/muscCY43InputData/armcu -n ARMCUL79
```

### ASTEX

See https://agupubs.onlinelibrary.wiley.com/doi/epdf/10.1002/2017MS001064 for some useful background info.

### Supercooled Liquid Cases

-https://www.sciencedirect.com/science/article/pii/S0165232X20303864?via%3Dihub
-https://www.tandfonline.com/doi/full/10.1080/16000870.2019.1697603

## Handling MUSC Output

### DDH Toolbox
The outputs from a MUSC run are small files in lfa format. DDH tools can be used to handle these files.

To download the DDH toolbox, go to https://www.umr-cnrm.fr/gmapdoc/spip.php?article19 and download the tarball. Untar it and within the "tools" folder run "install". Now the various "tools" are compiled. For example lfaminm $file shows you the max, min and mean of all the output variables in a file. lfac $file $var shows the value(s) of $var in $file e.g. lfac Out.000.0000.lfa PTS shows you surface temperature. In order to be able to use the plotting scripts below, you'll need the lfac tool in your path. 

For example on ecgate, I set the following paths (may differ a bit for you depending on where you downloaded the ddhtools to):

* export PATH=$HOME/DDHTOOLS/ddhtoolbox/tools/lfa/:$PATH
* export DDHI_BPS=$HOME/DDHTOOLS/ddhtoolbox/ddh_budget_lists/
* export DDHI_LIST=$HOME/DDHTOOLS/ddhtoolbox/ddh_budget_lists/conversion_list

### Plot output time-series from the MUSC output lfa files
```bash
cd $HOME/hm_musc/test_0001
./musc_plot1Dts.sh -d <musc-data-dir>

## python based plotting scripts and "default" png plots 
## will be produced in $HOME/hm_musc/test_0001/plots1Dts

```

### Extract output from the MUSC output ICM* fa files and plot time-series using these
* By default you get ICM* files on the hour - you can change the namelist should you require a higher frequency.

```bash
cd $HOME/hm_musc/test_0001
./musc_convertICM2ascii.sh -l <number_hours_in_expt_run> -f <path_to_your_musc_output>

## Generates an OUT ascii file for each atm and sfx ICM* input file
## ICM files have additional input not in lfa files e.g. TKE which is useful - also similar to 3D outputs

./musc_plot_profiles_ICMfiles.sh -d <data-dir> -p <parameter-model-level> -l <run_length_hours>

```


## Creating your own input files

A converter script, musc_convert.sh, is available to extract a MUSC column from a model state file (ICMSHHARM+HHHH). musc_convert.sh is a Bash script that calls gl_grib_api to carry the data conversions.

### Extract a MUSC input file
```bash
cd $HOME/hm_musc/test_0001
./musc_convert.sh -d $HOME/muscCY43InputData/harm_arome/ -c extr3d -n REFIRL -l 53.5,-7.5 -t 6
mkdir $HOME/muscCY43InputData/musc_refirl
cp MUSCIN_REFIRL_atm.fa MUSCIN_REFIRL_sfx.fa MUSCIN_REFIRL_pgd.fa $HOME/muscCY43InputData/musc_refirl/
```

### Convert MUSC FA to MUSC ASCII
```bash
cd $HOME/hm_musc/test_0001
./musc_convert.sh -c fa2ascii -d $HOME/muscCY43InputData/musc_refirl -n REFIRL
ls -ltr
cp MUSCIN_REFIRL_atm.ascii MUSCIN_REFIRL_sfx.ascii $HOME/muscCY43InputData/musc_refirl/
```

### Convert MUSC ASCII to MUSC FA
```bash
cd $HOME/hm_musc/test_0001
./musc_convert.sh -c ascii2fa -d $HOME/muscCY43InputData/musc_refirl -n REFIRL
ls -ltr
```


### Forcing in MUSC

 *  musc_convert.sh includes forcing for temperature (11), humidity (51) and wind speed (32) . 

You may edit the following lines to include other forcing:
```bash
  PPPKEY(1:4)%shortname  = 'ws','#','#','#',
  PPPKEY(1:4)%faname  = '#','SNNNFORC001','SNNNFORC002','SNNNFORC003'
  PPPKEY(1:4)%levtype = 'hybrid','hybrid','hybrid','hybrid',
  PPPKEY(1:4)%level   = -1,-1,-1,-1,
  PPPKEY(1:4)%pid     = 32,-1,-1,-1,
  PPPKEY(1:4)%nnn     = 0,0,0,0,
  PPPKEY(1:4)%lwrite  = F,T,T,T,
  IFORCE              = 11,51,32,
```

 * Further information on forcing is available here: [MUSC/Forcing](./MUSC/Forcing.md)


## MUSC Virtual Machine (VM)

MUSC can also be run in a Virtual Machine. This removes the need for compilation and installation of the model as it is already installed and running in the VM. The GUI in the VM can be a little slow depending upon your specific computer, however, the terminals are generally very quick, so working primarily in terminals removes this problem. 

 1. Get the VM (~7 Gb):  [https://hirlam.org/portal/download/MUSC/musc_cy43_vm_v1.0.tar.bz2]

2. Create a new directory (e.g. ~/VirtualBox_VMs/) and decompress the file in it.
    **WARNING: The MUSC VM decompresses to be approximately 43 Gb.**     Decompressing the file can usually be done by moving the file to your new directory and double clicking it in your file manager.     This will create a directory called MUSC containing the MUSC VM.     This can also be done in a linux terminal as follows: 
```bash
mkdir ~/VirtualBox_VMs
mv Directory_With_Dowloaded_File/musc_cy43_vm_v1.0.tar.bz2 ~/VirtualBox_VMs
cd ~/VirtualBox_VMs
tar xjf musc_cy43_vm_v1.0.tar.bz2
```

3. Download and install virtual machine software:
    The MUSC VM is in !VirtualBox format (*.vbox) and can be used with various virtual machine software but the simplest choice is to use !VirtualBox from Oracle.     This is available under the GNU Public Licence (GPL) for Windows, Mac, and Linux.     Download and install the !VirtualBox software from:  [https://www.virtualbox.org/wiki/Downloads]

4. Setup the MUSC VM:
```bash
Open VirtualBox
In the menu "Machine", select "Add…"
Navigate to the decompressed directory (e.g. ~/VirtualBox_VMs/MUSC)    
Select the file "MUSC.vbox"
Click "Open"
```

5. Starting the MUSC VM:
    Double click on MUSC in the left panel of the !VirtualBox window.

The VM should open a new window in which an Ubuntu system is booted. There is no password required to log in, though if it is needed, the username and password are both “musc”. 
There is an overview document on the desktop detailing the directory structure and how to setup and run your first experiment. 

## MUSC local adaptation
### KNMI workstations
The following files were added to make it possible to run MUSC on KNMI workstations:
```bash
config-sh/config.LinuxPC-MPI-KNMI
config-sh/submit.LinuxPC-MPI-KNMI
util/makeup/config.linux.gfortran.mpi-knmi 
```
for use with the setup script:
```bash
./musc_setup.sh [...] -c LinuxPC-MPI-KNMI
```
In addition, the following workaround has to be applied to be able to run the REFL65 test case:
```bash
$ git diff src/ifsaux/utilities/echien.F90
diff --git a/src/ifsaux/utilities/echien.F90 b/src/ifsaux/utilities/echien.F90
index 55d5ce94e..694c87d83 100644
--- a/src/ifsaux/utilities/echien.F90
+++ b/src/ifsaux/utilities/echien.F90
@@ -532,7 +532,7 @@ IF((KINF == 0).OR.(KINF == -1).OR.(KINF == -2).OR.(KINF == -3)) THEN
            & 'LEVEL ',JFLEV,' : ',&
            & 'FILE = ',ZVALH(JFLEV), ' ; ARGUMENT = ',PVALH(JFLEV)
           IERRA=1
-          IERR=1
+!         IERR=1
         ENDIF
         IF(ABS(ZVBH(JFLEV)-PVBH(JFLEV)) > PEPS) THEN
           WRITE(KULOUT,*) ' VERTICAL FUNCTION *B* MISMATCH ON ',&
```
Then you are ready to compile:

- remove the file experiment_is_locked from the experiment directory.
- remove the directory with your previous build (if any).
- start the compile with the musc_compile.sh script

When starting the MUSC run, add the PATH to mpirun and the libraries:
```bash
export PATH=$PATH:/usr/lib64/openmpi/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib
./musc_run.sh [...]
```


## MUSC FAQ

1. If there is an error, what files do I look in?
NODE.001_01 and lola in your output directory.

2. How to I handle the output files?
The output files are of the form Out.XXX.XXXX and appear in your output directory. There are in lfa format and can be handled using ddh tools. See the bash script musc_plot1Dts.sh for ideas. There are also ICM*lfa output files that are also handy for plotting profiles - use musc_convertICM2ascii.sh to convert these files to ASCII and musc_plot_profiles_ICMfiles.sh to plot some profiles e.g. TKE, cloud liquid etc.

3. I ran a different idealised case but did not get different results?
The likely reason for this is that you did not delete the namelists from your experiment directory. If the namelists are there, the musc_run.sh script neither creates them nor copies them from the repository.

4. How do I create a new idealised case?
This is not straightforward but the following was used to create the ASTEX cases in cy43 using info from cy38: https://www.overleaf.com/7513443985ckqvfdcphnng

5. How can I access a list of MUSC output parameters?
Ensure you have the ddhtoolbox compiled. Then use lfaminm $file on any of your output files and it will show what is there. To look at a particular variable try lfac $file $parameter e.g. lfac $file PTS (for surface temperature). You can use cat to copy the values to an ASCII file for ease of use (e.g. lfac $file PTS > $ASCIIfile).  

6. Is MUSC similar to the full 3D model version - is the physics the same?
Yes, if you checkout develop then you have MUSC up-to-date with that.

7. Do I need to recompile the model if I modify code?
Yes, if you modify code in a single file you must recompile the code but do not delete the original compiled model first. This will recompile relatively quickly. If you modify code in multiple files and you change what variables are passed between files, then you must delete your original compiled model and recompile the code. This will take longer to recompile. 

## MUSC variable names
A list of variable names found in the MUSC lfa output files can be found [here](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/MUSC/musc_vars). Please note that this is not a complete list of MUSC output parameters (yet). The variables in regular ICMSH... fa output are documented [here](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/Forecast/Outputlist)

## Outstanding Issues
1. ARMCU and Jenny's cases run without surface physics, radiation etc and hence return NANs in apl_arome. To circumvent this on ecgb, we needed to compile less strictly. This needs to be investigated further.
2. The ASTEX cases currently do not run on ecgb but work perfectly at Met Eireann - debugging needed.