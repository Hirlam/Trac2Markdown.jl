```@meta
EditURL="https://hirlam.org/trac//wiki//Phasing/LUNBC_in_cy43t1?action=edit"
```
# Phasing information for implementing the LUNBC changes in Cycle 43

# Author

Mariano Hortal.

# Implementer

Toon Moene.

# Base Version, Deadlines for Contributions

Base line: CY43_t1.02.

Deadline of this contribution: May 27nd, 2016.

# Initial version of the LUNBC code

The initial version of the LUNBC code (to provide for relaxation of the upper atmosphere of the model to that of the boundary conditions provided) was based on CY41T1. It contained changes to the following files:
```bash
aladin/coupling/ecoupl1.F90
aladin/coupling/ecoupl1ad.F90
aladin/coupling/elswa3.F90
aladin/coupling/eseimpls.F90
aladin/coupling/eseimplsad.F90
arpifs/ald_inc/namelist/nemelbc0a.nam.h
arpifs/control/stepo.F90
arpifs/control/stepoad.F90
arpifs/control/stepotl.F90
arpifs/module/elbc0a_mod.F90
arpifs/module/elbc0b_mod.F90
arpifs/module/elbc0c_mod.F90
```
and the following new files:
```bash
aladin/coupling/ecoupl2ad.F90
aladin/coupling/ecoupl2.F90
coupling/external/gpcou/esurlxt1ad.F90
coupling/external/gpcou/esurlxt1.F90
coupling/interface/esurlxt1ad.h
coupling/interface/esurlxt1.h
```
However, due to reorganisation of the boundary condition handling, all this has to be reviewed, to see where the changed code has to go.
# Get the CY43 code
On merou, perform the following:
```bash
git fetch                               # Update the local git repository.
git_branch -r 43 -b t1 -v 02 -u lunbc   # Create a branch to work on. This will be named moene_CY43_lunbc
```
# Analyse the differences with respect to the new code
Now check all the individual differences between these files and the ones in the CY43T1 branch. The new files are all OK (initially - they might have to change if we make changes to the updated files below):
```bash
aladin/coupling/ecoupl1.F90
aladin/coupling/ecoupl1ad.F90
# Both routines ESEIMPLS and ESIMPLSAD have an new first argument YDGEOMETRY,
# LUNBC update added KDIM (first dimension of arrays as first parameter - adapt change).
aladin/coupling/elswa3.F90
# The update uses YOMGEM: YRGEM - is that still the right thing to do ?
aladin/coupling/eseimpls.F90
aladin/coupling/eseimplsad.F90
# Both routines ESEIMPLS and ESIMPLSAD have an new first argument YDGEOMETRY,
# LUNBC update added KDIM (first dimension of arrays as first parameter - adapt change).
arpifs/ald_inc/namelist/nemelbc0a.nam.h
# LUNBC added to namelist, but another one added in between - hand update.
arpifs/control/stepo.F90
# The logic in the old update is still OK, with small offset in lines. However, ECOUPL1 has acquired
# new arguements, which might have to be duplicated to ECOUPL2, *a new file*.
arpifs/control/stepoad.F90
# There are new arguments to ECOUPL1AD, which might have to be duplicated to ECOUPL2AD,
# *a new file*.
arpifs/control/stepotl.F90
# The logic is the same, but ECOUPL1 has acquired new arguements, which might have to
# be duplicated for ECOUPL2, *a new file*.
arpifs/module/elbc0a_mod.F90
# Old update is still OK.
arpifs/module/elbc0b_mod.F90
# Is the use of YOMDIM : YRDIM still correct here ?
arpifs/module/elbc0c_mod.F90
# Is the use of YOMGEM : YRGEM still correct here ?
```
# Editing the changed source files by hand
Because the diffs wouldn't have applied cleanly.
Used a clean CY41T1 source for guidance.
```bash
vi ./aladin/coupling/ecoupl1.F90 
vi ./aladin/coupling/ecoupl1ad.F90 
vi ./aladin/coupling/elswa3.F90 
vi ./aladin/coupling/eseimpls.F90 
vi ./aladin/coupling/eseimpls.F90 
vi ./aladin/coupling/eseimplsad.F90 
vi ./arpifs/ald_inc/namelist/nemelbc0a.nam.h 
vi ./arpifs/control/stepo.F90 
vi ./arpifs/control/stepoad.F90 
vi ./arpifs/control/stepotl
vi ./arpifs/control/stepotl.F90 
vi ./arpifs/module/elbc0a_mod.F90 
vi ./arpifs/module/elbc0b_mod.F90 
vi ./arpifs/module/elbc0c_mod.F90 
```
# Build the version with the LUNBC changes
```bash
ftp merou                       # Fetch
<login>                         #  the
bin                             #    lunbc
get moene_CY43_t1.02_lunbc.tgz  #      branch
quit                            #        tar file
#
# Then, create the gmkpack environment:
#
(export PATH=$PATH:/home/gmap/mrpm/khatib/public/bin/gmkpack.6.6.4/util; gmkpack  -r 43 -b t1 -n 02 -a -l IMPI512IFC1500 -o 2y -p masterodb)
#
# Go to the source location ...
#
cd pack/43_t1.02.IMPI512IFC1500.2y/src/local
#
#   ... and unpack the contributions branch
#
tar zxvf ~/moene_CY43_t1.02_lunbc.tgz
#
# Remove the projects we do not deal with yet:
#
rm -rf cope obstat oops scat scripts
#
# Back up
#
cd ../..
#
# Execute the build script
#
(export GMK_THREADS=20; export PATH=$PATH:/home/gmap/mrpm/khatib/public/bin/gmkpack.6.6.4/util; ./ics_masterodb)
```
# Testing with mitraillette
```bash
Based on the description in http://www.cnrm-game-meteo.fr/gmapdoc/IMG/pdf/doc_mitraillette_v012016.pdf and Karim Yessad's mitraille directory on prolix,
I set up my own mitraillette by copying Karim´s in:

/home/gmap/mrpm/yessad/mitraille

I did use the input data in

/home/gmap/mrpm/yessad/SAVE/anal_a_mitraille

and others as in Karim´s scripts.

Mitraillette command, with the second executable name in the PRO_FILE pointing to the one produced by my gmkpack build of the moene_CY43_lunbc branch:

./mitraillette.x CY43T1 PRO_FILE.cy43t1_aldmultiref multi
./test.x0001

The tests in the base output that had run to completion with the same namelists showed no differences in norms.
```
# Commit the changes to the git repository
```bash
#
# Add the changed and new files
#
git add aladin/coupling/ecoupl1.F90 aladin/coupling/ecoupl1ad.F90 aladin/coupling/elswa3.F90 aladin/coupling/eseimpls.F90 aladin/coupling/eseimplsad.F90 arpifs/ald_in/namelist/nemelbc0a.nam.h arpifs/control/stepo.F90 arpifs/control/stepoad.F90 arpifs/control/stepotl.F90 arpifs/module/elbc0a_mod.F90 arpifs/module/elbc0b_mod.F90 arpifs/module/elbc0c_mod.F90 aladin/coupling/ecoupl2.F90 aladin/coupling/ecoupl2ad.F90 coupling/external/gpcou/esurlxt1.F90 coupling/external/gpcou/esurlxt1ad.F90 coupling/interface/esurlxt1.h coupling/interface/esurlxt1ad.h
#
# See if OK
#
git status
#
# Commit
#
git commit --dry-run
git commit -m "Mariano Hortal's upper boundary relaxation code (LUNBC)"
#
# Signal the branch has been committed
#
git_post
```