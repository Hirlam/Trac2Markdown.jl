```@meta
EditURL="https://hirlam.org/trac//wiki//DFS?action=edit"
```
# DFS

The DFS calculation software is still in under development. It is however possible to run the software already now even though it is not fully automated.
Start by downloading the tar-file dfscalc.tar found in Attachments. [https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/dfscalc.tar]

The following instructions is also available in the README file.

To run the DFS calculations and plot the results do the following

1. Edit the include.paths script to set dates and paths to your experiment and dfs directory

2. Run prep_dfs in batch mode. This script generates two sets of ccma files, one with perturbed observations and one original unperturbed. 

3. Before running the minimisation for the disturbed observations the namelist of your experiment must be copied to a file called "namel_minim" in the dfs script dir. In one of your HM_Date-files search for "Start of log: fort.4" and copy everything between the hash lines "#############################" into namel_minim.

4. Run RunMinim in batch mode. This will generate new an-fg statistics for the perturbed observations.

5. Before running extract you need to create a compiled MANDALAY. This is easiest done by doing the following:
Set up a new experiment
Check out src/obd/ddl/mandalay.sql
Replace this file by the mandalay.sql in dfs_scr (included in this tar-file)
Start your experiment and let it run until the compilation is complete
Copy the created MANDALAY to dfs_scr/bin (or point to it in extract_dfs)

It is also necessary to compile dfscomp.F90 and dfstot.F90 e.g:
gfortran -o bin/dfscomp.x dfscomp.F90
gfortran -o bin/dfstot.x dfstot.F90

6. Now run extract_dfs in batch mode. This generates the file $STARTDIR/OUTPUT/dsf.tot (STARTDIR in specified in include.paths) that contains the DFS statistics for the period. This can be plotted e.g. with the included R-script.

7. Plot the resuts with dfs_plot.R. Place dfs.tot and dfs_plot.R in the same directory and type: "Rscript dfs_plot.R" This generates the file dfs_tot.eps in the same directory.