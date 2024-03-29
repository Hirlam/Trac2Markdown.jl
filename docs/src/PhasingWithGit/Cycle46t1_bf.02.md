```@meta
EditURL="https://hirlam.org/trac//wiki//PhasingWithGit/Cycle46t1_bf.02?action=edit"
```
# Cycle 46t1_bf.02 phasing information using our git repository

# Introduction

This page specifies the steps undertaken to merge Cycle CY46T1_bf.02 into our git repository.

Cycle Master: Toon Moene.

Check the first phasing attempt for some more details [wiki:HarmonieSystemDocumentation/PhasingWithGit/Cycle46]

## Quick path to a decent merge

The following steps brings us a merge repository

```bash
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
git checkout develop
git remote add public https://git.hirlam.org/Harmonie
git remote add arpifs ssh://reader054@git.cnrm-game-meteo.fr/git/arpifs.git
git pull public develop
git push origin develop
git checkout -b pre-CY46h1
git fetch arpifs master:mf-master
git checkout mf-master
git fetch arpifs CY46T1_bf.02:mf-CY46T1_bf.02
git push origin mf-CY46T1_bf.02      # Make the branch part of our shared phasing repository
git checkout pre-CY46h1 
git config merge.renameLimit 50000
git merge -s recursive -Xsubtree=src mf-CY46T1_bf.02
```

This leads to loads of conflicts that we've decided to deal with later. Let's add these to the repository

```bash
git status > log
```

Keep all references to files after the "# Unmerged paths:" line

```bash
...
#
# Unmerged paths:
#   (use "git add/rm <file>..." as appropriate to mark resolution)
#
#       both modified:      src/aeolus/support/height_conv.F90
#       both modified:      src/aladin/c9xx/ebicli.F90
#       both modified:      src/aladin/c9xx/eincli9.F90
#       both modified:      src/aladin/coupling/ecoupl2.F90
...
```

Now we can add all files, but remove some references to links
```bash
cat log | cut -d":" -f2  | cut -d">" -f1  | grep -v " -" | xargs -l1 git add
```

Commit 
```bash
git commit
```

Publish the branch

```bash
> git push origin pre-CY46h1
Username for 'https://git.hirlam.org': uandrae
Password for 'https://uandrae@git.hirlam.org': 
Counting objects: 3190, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (1375/1375), done.
Writing objects: 100% (2159/2159), 1.51 MiB | 1.85 MiB/s, done.
Total 2159 (delta 1767), reused 950 (delta 758)
To https://git.hirlam.org/HarmoniePhasing
 * [new branch]      pre-CY46h1 -> pre-CY46h1
```
# Example of committing a fix
Workflow for committing a fix is detailed below
## Make your own, local pre-CY46h1 branch
```bash
mkdir ~/CY46-phasing
cd ~/CY46-phasing
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing/
git checkout pre-CY46h1
```

We also need the Meteo-France reference version to compare with

```bash
mkdir ~/CY46-MFref
cd ~/CY46-MFref
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing/
git checkout mf-CY46T1_bf.02
```
Note that Meteo France's repository contains what is in our repository's "src" directory.

## Be prepared
Before starting to work on committing your next fix, do not forget to synchronize your local pre-CY46h1 branch with the one at hirlam.org:
```bash
git pull origin pre-CY46h1
```
## Example: project 'algor'
The work necessary to fix project 'algor' involved several argument lists in
4 files (see [dcd7b6](https://hirlam.org/trac/changeset/dcd7b6b9a51fb27a251772ae5bfc69ae6f40b230/HarmoniePhasing)). Once edited out these are the git commands:
## Commit fixes locally
Commit, adding all modified files (-a) with the commit message (-m) supplied.
```bash
git commit -a -m "Resolve merge conflicts: take theirs"
```
## Check status
```bash
git status
```
## Push the changes to hirlam.org
```bash
git push origin pre-CY46h1
```
# Sharing of work
## Merge develop as of 20210224 into pre-CY46h1
!ToMo [changeset:d25479/Harmonie d25479] as follows (on ecgate)
```bash
#
# On the PERM file system, preserve the previous clones for merge and copy:
#
cd $PERM
mv HarmoniePhasing HarmoniePhasing.13
mv Harmonie Harmonie.1
#
# Get a fresh clone
#
git clone https://git.hirlam.org/Harmonie
cd Harmonie
git branch -a
#
# Check out the pre Cycle 46 branch
#
git checkout pre-CY46h1
git branch -a
#
# Set necessary merge limits and committer/author e-mail address
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Perform the merge
#
git merge origin/develop
git status
#
# Save the conflicted files
#
for f in src/aladin/coupling/ecoupl2.F90 src/aladin/coupling/ecoupl2ad.F90 src/aladin/coupling/elsin0ta.F90 src/arpifs/module/yomtraj.F90 src/arpifs/op_obs/hradp_ml.F90 src/arpifs/op_obs/hradp_ml_tl.F90 src/arpifs/phys_dmn/vdfhghtnhl.F90 src/arpifs/phys_dmn/vdfparcelhl.F90 src/mpa/micro/internals/rain_ice.F90; do cp -v $f $f.conflict; done
#
# Fix the conflicts
#
vi src/aladin/coupling/ecoupl2.F90
vi src/aladin/coupling/ecoupl2ad.F90
vi src/aladin/coupling/elsin0ta.F90
vi src/arpifs/module/yomtraj.F90
vi src/arpifs/op_obs/hradp_ml.F90
vi src/arpifs/op_obs/hradp_ml_tl.F90
vi src/arpifs/phys_dmn/vdfhghtnhl.F90
vi src/arpifs/phys_dmn/vdfparcelhl.F90
vi src/mpa/micro/internals/rain_ice.F90
#
# Start the check run
#
cd ~/hm_home/
mkdir mergedevelop20210224
cd mergedevelop20210224
/perm/ms/nl/nkc/Harmonie/config-sh/Harmonie setup -r /perm/ms/nl/nkc/Harmonie
vi ecf/config_exp.h # Set ANASURF=none because Canari doesn't work yet.
/perm/ms/nl/nkc/Harmonie/config-sh/Harmonie start DTG=2021021000 DTGEND=2021021003 LL=3
#
# Well, that didn't compile ...
#
cd /perm/ms/nl/nkc/Harmonie
cp src/aladin/coupling/ecoupl2ad.F90.conflict src/aladin/coupling/ecoupl2ad.F90
vi src/aladin/coupling/ecoupl2ad.F90
view src/coupling/interface/esurlxt1ad.h
vi src/aladin/coupling/ecoupl2ad.F90
diff src/coupling/interface/esurlxt1ad.h ../Harmonie.1/src/coupling/interface/esurlxt1ad.h 
cp ../Harmonie.1/src/coupling/interface/esurlxt1ad.h src/coupling/interface/esurlxt1ad.h
vi src/aladin/coupling/ecoupl2ad.F90
#
# Restart the test run (specifically, the compile part)
#
rm ~/hm_home/mergedevelop20210224/experiment_is_locked 
git status
#
# In the end, resolve to using the original copy of ecoupl2ad.F90 ....
#
diff ../Harmonie.1/src/aladin/coupling/ecoupl2ad.F90 src/aladin/coupling/ecoupl2ad.F90
cp ../Harmonie.1/src/aladin/coupling/ecoupl2ad.F90 src/aladin/coupling/ecoupl2ad.F90
git status
#
# and restart the test run to finally produce executables.
#
rm ~/hm_home/mergedevelop20210224/experiment_is_locked 
git status
#
# With the test run completing correctly,
# add the files with resolved conflicts
#
git add src/aladin/coupling/ecoupl2.F90 src/aladin/coupling/ecoupl2ad.F90 src/aladin/coupling/elsin0ta.F90 src/arpifs/module/yomtraj.F90 src/arpifs/op_obs/hradp_ml.F90  src/arpifs/phys_dmn/vdfhghtnhl.F90 src/arpifs/phys_dmn/vdfparcelhl.F90 src/mpa/micro/internals/rain_ice.F90 src/coupling/interface/esurlxt1ad.h 
#
# And commit
#
git commit -m "merge develop as of 20210224 into pre-CY46h1" --dry-run
#
# Oops, forgot one.
#
git add src/arpifs/op_obs/hradp_ml_tl.F90
git commit -m "merge develop as of 20210224 into pre-CY46h1" --dry-run
git commit -m "merge develop as of 20210224 into pre-CY46h1"
#
# and finally push the results.
#
git push
```
## 20210217 Copy branch pre-CY46h1-78bd67 in !HarmoniePhasing to pre-CY46h1 in Harmonie
**NOTE:** pre-CY46h1-78bd67 in !HarmoniePhasing should **NOT** be used from now on anymore !

!ToMo as follows (on ecgate):
```bash
#
# Get a fresh clone of the phasing repository:
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add the main Harmonie repository as a remote:
#
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
#
# Check out the branch to copy in the phasing repository:
#
git checkout pre-CY46h1-78bd67
#
# And push it as pre-CY46h1 to the main Harmonie repository:
#
git push public pre-CY46h1-78bd67:pre-CY46h1
#
# Now clone the Harmonie repository afresh:
#
cd ..
git clone https://git.hirlam.org/Harmonie
cd Harmonie
#
# See if our new branch is there ...
#
git branch -a
#
# ... and get it:
#
git checkout pre-CY46h1
#
# Rudimentary check that we indeed got the right branch:
#
grep -r FIXME src/
#
# Setup and start a checking run:
#
cd ~/hm_home/
mkdir HarmonieRepoPreCY46h1
cd HarmonieRepoPreCY46h1
/perm/ms/nl/nkc/Harmonie/config-sh/Harmonie setup -r /perm/ms/nl/nkc/Harmonie
vi ecf/config_exp.h # Set ANASURF=none because Canari doesn't work yet.
/perm/ms/nl/nkc/Harmonie/config-sh/Harmonie start DTG=2021020500 DTGEND=2021020503 LL=3
#
# Completed correctly - all set.
#
```
## Merge develop as of 20210203 into pre-CY46h1-78bd67
!ToMo [changeset:e2e0e5/HarmoniePhasing e2e0e5] and [changeset:cd334a/HarmoniePhasing cd334a] as follows (on ecgate)
```bash
#
# Get a fresh clone from the phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add the main repository as remote.
#
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
#
# Check out the pre-CY46h1 branch.
#
git checkout pre-CY46h1-78bd67
git branch -a
#
# Set merge limits and committer/author e-mail.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Perform the merge.
#
git merge public/develop
#
# No conflicts ? Really ?
#
git status # Yes, really.
#
# Start check run.
#
cd ~/hm_home/
mkdir mergedevelop20210203
cd mergedevelop20210203
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none because CANARI doesn't work yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2021013100 DTGEND=2021013103 LL=3
#
# The new MPL_WAIT calls aren't correct, so fix them.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
grep -ir mpl_wait src/
find src/ -name evdtuvad_comm_mod.F90
vi src/etrans/module/evdtuvad_comm_mod.F90
find src/ -name euvtvd_comm_mod.F90
src/etrans/module/euvtvd_comm_mod.F90
#
# Restart the checking run.
#
rm ~/hm_home/mergedevelop20210203/experiment_is_locked 
#
# It completed normally.
#
git status
#
# Add the fixed files.
#
git add src/etrans/module/euvtvd_comm_mod.F90 src/etrans/module/evdtuvad_comm_mod.F90
#
# Redo the limits and e-mail adresses.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Commit and push the result.
#
git commit -m "merge develop as of 20210203 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20210203 into pre-CY46h1-78bd67"
git push
```
## Merge develop as of 20210113 into pre-CY46h1-78bd67
!ToMo [changeset:45cbdb/HarmoniePhasing 45cbdb] as follows (on ecgate)
```bash
#
# Get a fresh clone of the phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add main repository as remote.
#
git remote add public https://git.hirlam.org/Harmonie
#
# Fetch all changes from remote.
#
git fetch --all
#
# Check out the pre-Cycle 46h1 branch.
#
git branch -a
git checkout pre-CY46h1-78bd67
#
# Set limits and committer/author e-mail address.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Perform the merge.
#
git merge public/develop
git status
#
# Save the files with conflicts.
#
for f in src/aladin/coupling/elsin0ta.F90 src/arpifs/control/cnt4ad.F90 src/arpifs/control/cnt4tl.F90 src/arpifs/io_serv/io_serv_get_req.F90 src/arpifs/namelist/namvar.nam.h src/arpifs/var/suvar.F90 util/makeup/config.linux.gfortran.mpi; do cp -v $f $f.conflict; done
#
# Resolve the conflicts, adding #ifdef FIXME ... #endif for the corrected 4DVar treatment of boundaries [changeset:49ff36/HarmoniePhasing 49ff36].
#
vi src/aladin/coupling/elsin0ta.F90
vi src/arpifs/control/cnt4ad.F90
vi src/arpifs/control/cnt4tl.F90
vi src/arpifs/io_serv/io_serv_get_req.F90 # Fix for IO-server MPI problem
vi src/arpifs/namelist/namvar.nam.h
vi src/arpifs/var/suvar.F90
vi util/makeup/config.linux.gfortran.mpi  # Add new SURFEX compile flags
#
# Add #ifdef FIXME ... #endif in new files belonging to 4DVar change.
#
vi src/aladin/coupling/elswa3ad.F90
vi src/aladin/coupling/elswa3tl.F90
git status
#
# Start a test run.
#
cd ~/hm_home/
mkdir mergedevelop20210113
cd mergedevelop20210113
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none because CANARI doesn't work yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2021010200 DTGEND=2021010203 LL=3
#
# Fix conflict resolution, round I and restart compilation.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
vi src/arpifs/var/suvar.F90
rm ~/hm_home/mergedevelop20210113/experiment_is_locked 
#
# Fix conflict resolution, round II and restart compilation.
#
vi src/arpifs/control/cnt4ad.F90
vi src/aladin/coupling/elsin0ta.F90
rm ~/hm_home/mergedevelop20210113/experiment_is_locked 
#
# Fix conflict resolution, round III and restart compilation.
#
vi src/arpifs/control/cnt4ad.F90
vi src/arpifs/control/cnt4tl.F90
rm ~/hm_home/mergedevelop20210113/experiment_is_locked 
#
# Reset limits and e-mail addresses after being forcefully logged out.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Add the files with resolved conflicts.
#
git status
git add src/aladin/coupling/elsin0ta.F90 src/arpifs/control/cnt4ad.F90 src/arpifs/control/cnt4tl.F90 src/arpifs/namelist/namvar.nam.h src/arpifs/var/suvar.F90
git add src/aladin/coupling/elswa3ad.F90 src/aladin/coupling/elswa3tl.F90
git add src/arpifs/io_serv/io_serv_get_req.F90 util/makeup/config.linux.gfortran.mpi
git status
#
# Commit the merge ...
#
git commit -m "merge develop as of 20210113 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20210113 into pre-CY46h1-78bd67"
#
# ... and push it.
#
git push
```
## Merge develop as of 20201214 into pre-CY46h1-78bd67
!ToMo [changeset:ea811d/HarmoniePhasing ea811d] and [changeset:dc6ad9/HarmoniePhasing dc6ad9] as follows (on ecgate)
```bash
#
# Get a fresh clone of the phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add the main repository as remote and update
#
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
#
# Checkout the Cycle 46 phasing branch
#
git checkout pre-CY46h1-78bd67
#
# Set necessary limits and committer/author e-mail adres
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Do the actual merge and check status
#
git merge public/develop
git status
#
# Add the new files from our develop branch
#
git add src/odb/ddl.CCMA/obsmon_conv.sql src/odb/ddl.CCMA/obsmon_conv2.sql src/odb/ddl.CCMA/obsmon_sat.sql src/odb/ddl.ECMA/obsmon_conv.sql src/odb/ddl.ECMA/obsmon_conv2.sql src/odb/ddl.ECMA/obsmon_sat.sql
#
# Save the files with conflicts
#
for f in src/arpifs/adiab/cpg.F90 src/arpifs/adiab/cpg_drv.F90; do cp -v $f $f.conflict; done
#
# Resolve conflicts, round I
#
vi src/arpifs/adiab/cpg.F90
vi src/arpifs/adiab/cpg_drv.F90
#
# Start a test run
#
cd ~/hm_home/
mkdir mergedevelop20201214
cd mergedevelop20201214
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h  # Set ANASURF=none because Canari doesn't work yet
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020120500 DTGEND=2020120503 LL=3
#
# Resolve conflicts, round II
#
cd /perm/ms/nl/nkc/HarmoniePhasing
cp src/arpifs/adiab/cpg.F90.conflict src/arpifs/adiab/cpg.F90
cp src/arpifs/adiab/cpg_drv.F90.conflict src/arpifs/adiab/cpg_drv.F90
vi src/arpifs/adiab/cpg.F90
vi src/arpifs/adiab/cpg_drv.F90
#
# Restart the test run
#
rm ~/hm_home/mergedevelop20201214/experiment_is_locked
#
# Check status and add the files with resolved conflicts
#
git status
git add src/arpifs/adiab/cpg.F90 src/arpifs/adiab/cpg_drv.F90
#
# Commit the merge and push the changes
#
git commit -m "merge develop as of 20201214 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20201214 into pre-CY46h1-78bd67"
git push
git pull # Oops, someone updated the Cycle 46 phasing branch - get their updates.
git push
```
## Merge develop as of 20201123 into pre-CY46h1-78bd67
!ToMo [changeset:9cd48b/HarmoniePhasing 9cd48b] as follows (on ecgate)
```bash
#
# Get a fresh clone from the phasing repository in my $PERM
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
#
# Add the public Harmonie repository to get at our central develop branch
#
cd HarmoniePhasing
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
#
# Checkout our pre-Cycle-46 branch
#
git checkout pre-CY46h1-78bd67
#
# Set merge limits and AUTHOR and COMMITTER e-mail addresses.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Do the actual merge of public develop into our pre-Cycle-46 branch
#
git merge public/develop
#
# Check the result and save the files with merge conflicts.
#
git status
for f in src/arpifs/control/cnt3_lam.F90 src/arpifs/control/sim4d.F90 src/arpifs/control/stepoad.F90 src/arpifs/control/stepotl.F90 src/arpifs/obs_preproc/sugoms.F90 src/arpifs/op_obs/obsop_gps_surface.F90 src/arpifs/phys_dmn/mf_phystl.F90 src/arpifs/sinvect/suforce.F90 src/mpa/micro/internals/rain_ice.F90 src/odb/pandor/module/bator_decodbufr_mod.F90 src/odb/tools/Bator.F90; do cp -v $f $f.conflict; done
#
# Fix the merge conflicts.
#
vi src/odb/tools/Bator.F90
vi src/odb/pandor/module/bator_decodbufr_mod.F90
vi src/mpa/micro/internals/rain_ice.F90
vi src/arpifs/sinvect/suforce.F90
vi src/arpifs/phys_dmn/mf_phystl.F90
vi src/arpifs/op_obs/obsop_gps_surface.F90
vi src/arpifs/obs_preproc/sugoms.F90
vi src/arpifs/control/stepotl.F90
vi src/arpifs/control/stepoad.F90
vi src/arpifs/control/sim4d.F90
vi src/arpifs/control/cnt3_lam.F90
#
# Set up and run an experiment with the resulting source code.
#
cd ~/hm_home/
mkdir mergedevelop20201123
cd mergedevelop20201123
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none because Canari doesn't work yet
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020111500 DTGEND=2020111503 LL=3
#
# Prepare for the commit by git add'ing the files with resolved conflicts.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
git status
git add src/arpifs/control/cnt3_lam.F90 src/arpifs/control/sim4d.F90 src/arpifs/control/stepoad.F90 src/arpifs/control/stepotl.F90 src/arpifs/obs_preproc/sugoms.F90 src/arpifs/op_obs/obsop_gps_surface.F90 src/arpifs/phys_dmn/mf_phystl.F90 src/arpifs/sinvect/suforce.F90 src/mpa/micro/internals/rain_ice.F90 src/odb/pandor/module/bator_decodbufr_mod.F90 src/odb/tools/Bator.F90
#
# (Re)set the merge limits and the AUTHOR and COMMITTER e-mail addresses.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Commit and push the result of the merge.
#
git commit -m "merge develop as of 20201123 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20201123 into pre-CY46h1-78bd67"
git push
```
## Merge develop as of 20201030 into pre-CY46h1-78bd67
!ToMo [changeset:fb4d16/HarmoniePhasing fb4d16] as follows (on ecgate)
```bash
#
# Get a fresh clone from our Phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add a link to our main repository.
#
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
#
# Check out the preCY46 branch.
#
git checkout pre-CY46h1-78bd67
#
# Enlarge limits and set correct author/committer e-mail addresses.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Perform the merge.
#
git merge public/develop
git status
#
# Save conflicted files and perform conflict resolution.
#
for f in src/arpifs/climate/updcli_mse.F90 src/mpa/micro/internals/rain_ice.F90; do cp -v $f $f.conflict; done
vi src/arpifs/climate/updcli_mse.F90
vi src/mpa/micro/internals/rain_ice.F90
#
# Start the test run.
#
cd ~/hm_home/
mkdir mergedevelop20201030
cd mergedevelop20201030
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none, because CANARI doesn't work yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020101500 DTGEND=2020101503 LL=3
#
# Amend conflict resolution and requeue the test job in ecflow.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
git status
cp src/arpifs/climate/updcli_mse.F90.conflict src/arpifs/climate/updcli_mse.F90
vi src/arpifs/climate/updcli_mse.F90
#
# Tests are OK. Commit the merge and push the results.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
git status # Final check.
#
# Add the files with the resolved conflicts.
#
git add src/arpifs/climate/updcli_mse.F90 src/mpa/micro/internals/rain_ice.F90
#
# Commit and push.
#
git commit -m "merge develop as of 20201030 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20201030 into pre-CY46h1-78bd67"
git push
```
## Merge of CY46T1_bf.06 into pre-CY46h1-78bd67 (20201020)
!ToMo [changeset:fe5b96/HarmoniePhasing fe5b96] as follows (on ecgate)
```bash
#
# Get a fresh clone of our phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
#
# Add Meteo France repository and fetch their master.
#
git remote add arpifs ssh://reader054@mfgit/git/arpifs.git
git fetch arpifs master:mf-master
git checkout mf-master
#
# Fetch the sixth bugfix branch and push it to our repository for reference.
#
git fetch arpifs CY46T1_bf.06:mf-CY46T1_bf.06
git push origin mf-CY46T1_bf.06
#
# Check out our pre-46 branch as the target for the merge.
#
git checkout pre-CY46h1-78bd67
#
# Enlarge limits necessary for large merge.
#
git config merge.renameLimit 50000
git config diff.renameLimit 50000
#
# Perform the merge and check its status.
#
git merge -s recursive -Xsubtree=src mf-CY46T1_bf.06
git status
#
# Save the (one) file with conflicts and fix the conflicts.
#
cp -v src/utilities/pearome/programs/pertsurf.F90 src/utilities/pearome/programs/pertsurf.F90.conflict
vi src/utilities/pearome/programs/pertsurf.F90
#
# Perform the test runs.
#
cd ~/hm_home/
mkdir mergeCY46T1bf06
cd mergeCY46T1bf06
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none because CANARI doesn't work yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020101000 DTGEND=2020101003 LL=3
#
# Set the correct committer and author e-mail addresses.
#
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Perform the commit and push of the merge.
#
cd /perm/ms/nl/nkc/HarmoniePhasing
git status # final check.
git add src/utilities/pearome/programs/pertsurf.F90 # Add the file with conflicts resolved.
git commit -m "merge of CY46T1_bf.06" --dry-run
git commit -m "merge of CY46T1_bf.06"
git push
```
## Merge develop as of 20201012 into pre-CY46h1-78bd67
!ToMo [changeset:2e39d1/HarmoniePhasing 2e39d1] and [changeset:5d7de2/HarmoniePhasing 5d7de2] as follows (on ecgate)
```bash
#
# Get a fresh clone of the phasing repository.
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git branch -a
git checkout pre-CY46h1-78bd67
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
git merge public/develop
git status
#
# Save the conflicted files.
#
for f in src/arpifs/fullpos/sufpc.F90 src/blacklist/mf_blacklist.b src/mpa/micro/internals/rain_ice.F90 src/odb/pandor/module/bator_decodbufr_mod.F90; do cp -v $f $f.conflict; done
#
# Resolve the conflicts.
#
vi src/arpifs/fullpos/sufpc.F90
vi src/blacklist/mf_blacklist.b
vi src/odb/pandor/module/bator_decodbufr_mod.F90
vi src/mpa/micro/internals/rain_ice.F90
#
# Try to fix the problems of invoking CUANCAPE2 from Fullpos
#
vi src/arpifs/fullpos/eccica.F90
vi src/arpifs/fullpos/endpos.F90
vi src/arpifs/fullpos/fpcica.F90
vi src/arpifs/fullpos/phymfpos.F90
#
# Test the result
#
cd ~/hm_home/
mkdir mergedevelop20201012
cd mergedevelop20201012
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none because Canari doesn't work yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020100300 DTGEND=2020100303 LL=3
#
# This is OK, now commit the result.
#
git status
git add src/arpifs/fullpos/sufpc.F90 src/blacklist/mf_blacklist.b src/mpa/micro/internals/rain_ice.F90 src/odb/pandor/module/bator_decodbufr_mod.F90 src/arpifs/fullpos/eccica.F90 src/arpifs/fullpos/endpos.F90 src/arpifs/fullpos/fpcica.F90 src/arpifs/fullpos/phymfpos.F90
git status
git commit -m "merge develop as of 20201012 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20201012 into pre-CY46h1-78bd67"
git push
git pull # Someone changed branch pre-CY46h1-78bd67 since I started.
git push
```
Unfortunately, I had to add a FIXME in eccaci.F90 (See ticket [ticket:180]):
```bash
#ifdef FIXME
! YDECUMF has to come from YDMODEL, a TYPE(MODEL) input argument,
! but this is nowhere to be found in fullpos.
CALL CUANCAPE2(YDECUMF,KST,KEND,KPROMA,KLEV,ZRPF,ZRPH,PT,PQV,PCAPE,PCIN)
#endif
```
## Merge develop as of 20200929 into pre-CY46h1-78bd67
!ToMo [changeset:c9ec4f/HarmoniePhasing c9ec4f] as follows (on ecgate)
```bash
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git checkout pre-CY46h1-78bd67
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
git merge public/develop
git status # Check result and list of conflicts.
#
# Fix conflicts.
#
vi src/arpifs/obs_preproc/upecma.F90
vi src/ifsaux/py_interface/mode_searchgrp.F90
git add src/arpifs/obs_preproc/upecma.F90 src/ifsaux/py_interface/mode_searchgrp.F90
#
# Check the results with a test run
#
cd ~/hm_home
mkdir mergedevelop20200929
cd mergedevelop20200929
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set ANASURF=none, because CANARI isn't working yet.
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020090300 DTGEND=2020090303 LL=03
#
# Success (apart from obsmonitoring - a known problem) ! Now commit the changes:
#
cd /perm/ms/nl/nkc/HarmoniePhasing
git status # Final check to see if we didn't forget anything.
git commit -m "merge develop as of 20200929 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20200929 into pre-CY46h1-78bd67"
git push
```
## Merge develop as of 20200907 into pre-CY46h1-78bd67
!ToMo [changeset:cfc771/HarmoniePhasing cfc771] and [changeset:8e7fa1/HarmoniePhasing 8e7fa1] as follows (on ecgate)
```bash
#
# Get a fresh clone
#
cd $PERM
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
git remote add public https://git.hirlam.org/Harmonie
git fetch --all
git checkout pre-CY46h1-78bd67
git config merge.renameLimit 50000
git config diff.renameLimit 50000
export GIT_COMMITTER_EMAIL=moene@knmi.nl
export GIT_AUTHOR_EMAIL=moene@knmi.nl
#
# Do the merge
#
git merge public/develop
git status
#
# Save the conflicted files
#
for f in ecf/config_exp.h nam/harmonie_namelists.pm scr/4DVminim scr/4DVscreen scr/4DVtraj src/arpifs/control/cva1.F90 src/arpifs/module/control_vectors_comm_mod.F90 src/arpifs/module/traj_physics_mod.F90 src/arpifs/obs_preproc/mkglobstab.F90 src/arpifs/obs_preproc/mkglobstab_model.F90 src/arpifs/op_obs/hradp_ml.F90 src/arpifs/op_obs/hradp_ml_tl.F90 src/arpifs/phys_dmn/mf_physad.F90 src/arpifs/phys_dmn/mf_phystl.F90 src/arpifs/setup/su1yom.F90 src/arpifs/setup/surip.F90 util/musc/scr/musc_run.sh ; do cp -v $f $f.conflict; done
#
# Resolve the conflicts
#
vi ecf/config_exp.h
vi nam/harmonie_namelists.pm
vi util/musc/scr/musc_run.sh
vi scr/4DVminim
vi scr/4DVscreen
vi scr/4DVtraj
vi src/arpifs/control/cva1.F90
vi src/arpifs/module/control_vectors_comm_mod.F90
vi src/arpifs/module/traj_physics_mod.F90
#
# Deleted
#
mv src/arpifs/obs_preproc/mkglobstab.F90 src/arpifs/obs_preproc/mkglobstab.F90.opzij
#
vi src/arpifs/obs_preproc/mkglobstab_model.F90
vi src/arpifs/op_obs/hradp_ml.F90
vi src/arpifs/op_obs/hradp_ml_tl.F90
vi src/arpifs/phys_dmn/mf_physad.F90
vi src/arpifs/phys_dmn/mf_phystl.F90
vi src/arpifs/setup/su1yom.F90
vi src/arpifs/setup/surip.F90
vi util/musc/scr/musc_run.sh
#
# This one needed a FIXME
#
vi src/arpifs/var/savmini.F90
#
# Add "NPATFR" to the namelist definition
#
vi src/arpifs/namelist/namspp.nam.h
#
# Test the results
#
cd ~/hm_home/
mkdir mergedevelop20200907
cd mergedevelop20200907
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
vi ecf/config_exp.h # Set "ANASURF=none"
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020082300 DTGEND=2020082303 LL=03
#
# Finish up
#
cd $PERM/HarmoniePhasing
git status
git add ecf/config_exp.h nam/harmonie_namelists.pm scr/4DVminim scr/4DVscreen scr/4DVtraj src/arpifs/control/cva1.F90 src/arpifs/module/control_vectors_comm_mod.F90 src/arpifs/module/traj_physics_mod.F90 src/arpifs/obs_preproc/mkglobstab_model.F90 src/arpifs/op_obs/hradp_ml.F90 src/arpifs/op_obs/hradp_ml_tl.F90 src/arpifs/phys_dmn/mf_physad.F90 src/arpifs/phys_dmn/mf_phystl.F90 src/arpifs/setup/su1yom.F90 src/arpifs/setup/surip.F90 util/musc/scr/musc_run.sh src/arpifs/namelist/namspp.nam.h src/arpifs/var/savmini.F90
git rm src/arpifs/obs_preproc/mkglobstab.F90
git status # OK
#
# Perform the commit and push
#
git commit -m "merge develop as of 20200907 into pre-CY46h1-78bd67" --dry-run
git commit -m "merge develop as of 20200907 into pre-CY46h1-78bd67"
git push
git pull # Get the changes made since 20200907
git push
```
## Merge of CY46T1_bf.05 into pre-CY46h1-78bd67 (20200903)
!ToMo [changeset:bb1476/HarmoniePhasing bb1476] as follows (on ecgate)
```bash
git clone https://git.hirlam.org/HarmoniePhasing
cd HarmoniePhasing
git branch -a
git checkout pre-CY46h1-78bd67
git remote add arpifs ssh://reader054@mfgit/git/arpifs.git
git fetch arpifs master:mf-master
git checkout mf-master
git fetch arpifs CY46T1_bf.05:mf-CY46T1_bf.05
git push origin mf-CY46T1_bf.05
git checkout pre-CY46h1-78bd67
git config merge.renameLimit 50000
git merge -s recursive -Xsubtree=src mf-CY46T1_bf.05
git status
for f in src/arpifs/cma2odb/ctxinitdb.F90 src/arpifs/cma2odb/putatdb.F90 src/odb/pandor/module/ObsConvertBufrToOdb.F90 src/odb/pandor/module/bator_decodbufr_mod.F90 src/surfex/ASSIM/oi_control.F90; do cp $f $f.conflict; done
#
# ... and resolve the conflicts
#
vi src/arpifs/cma2odb/ctxinitdb.F90
vi src/arpifs/cma2odb/putatdb.F90
vi src/odb/pandor/module/ObsConvertBufrToOdb.F90
vi src/odb/pandor/module/bator_decodbufr_mod.F90
vi src/surfex/ASSIM/oi_control.F90
#
# ... Test run
#
cd ~/hm_home/
mkdir mergeCY46T1bf05
cd mergeCY46T1bf05/
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie setup -r /perm/ms/nl/nkc/HarmoniePhasing
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie start DTG=2020082000 DTGEND=2020082003 LL=03
#
# ... When the second cycle crashes in Canari set ANASURF=none and ...
#
/perm/ms/nl/nkc/HarmoniePhasing/config-sh/Harmonie prod LL=03
#
# ... Add the changed files for commit
#
git add src/arpifs/cma2odb/ctxinitdb.F90 src/arpifs/cma2odb/putatdb.F90 src/odb/pandor/module/ObsConvertBufrToOdb.F90 src/odb/pandor/module/bator_decodbufr_mod.F90 src/surfex/ASSIM/oi_control.F90 src/odb/pandor/module/AbstractBufrReader.F90
git status
git commit -m "merge of CY46T1_bf.05" --dry-run
git commit -m "merge of CY46T1_bf.05"
git push
```
## Creation of branch pre-CY46h1-78bd67 (20200804-08)
Ulf and Toon discussed the status of the pre-CY46h1 branch on the 4th of August
and decided that it was better to go back to the moment when things still worked
(at least a cold start forecast): [changeset:78bd67/HarmoniePhasing 78bd67].

This was done by creating a new branch pre-CY46h1-78bd67 ("simply" reverting the changes
after 78bd67 looked too risky from a description we found on the internet
[Undo pushed merge in git](https://www.christianengvall.se/undo-pushed-merge-git/)).

Ulf redid the merge of CY46t1_bf.04 ([changeset:5df473/HarmoniePhasing 5df473])
and Toon redid the merge of develop ([changeset:f5c336/HarmoniePhasing f5c336] and [changeset:d094d2/HarmoniePhasing d094d2]).
## Merge of develop (20200623 - obsoleted by work from 20200804 onwards)
!ToMo: [changeset:6c0142/HarmoniePhasing 6c0142]
```bash
cd ~/HarmoniePhasing                                    # Go to local clone of CY46 phasing repository
git remote add public https://git.hirlam.org/Harmonie   # Add the connection to master/develop repository
git fetch --all                                         # Update our view of all repositories
git pull --ff-only                                      # Pull of pre-CY46h1 should be fast-forward only !
git checkout pre-CY46h1                                 # Next day, check out the branch (to be sure)
git pull --ff-only                                      #   And pull again
git merge public/develop                                # Perform the merge
git status                                              # Get an overview of the merge conflicts
```
Merge conflicts resolved:
```bash
#
git add scr/Harmonie_testbed.pl
#
# Add iso_fortran_env to external modules
#
git add util/makeup/config.cca.gnu util/makeup/config.ecgb util/makeup/config.linux.gfortran.mpi util/makeup/config.redhat7.gfortran-dev.openmpi util/makeup/config.redhat74.gfortran485.nompi util/obsmon/config/config.redhat7.gfortran-dev.openmpi
#
git add src/arpifs/module/parersca.F90 src/arpifs/module/varbc_rad.F90 src/arpifs/obs_preproc/upecma.F90 src/arpifs/var/suscat.F90 src/mpa/micro/internals/rain_ice.F90
#
# Remove duplicate entries
#
git add src/blacklist/hirlam_external
#
# These files used YYerror (until bison decided to use it, so I changed that to YYerror1)
#
git add src/odb/compiler/yacc.y src/odb/compiler/lex.l src/odb/compiler/genc.c src/odb/compiler/tree.c src/odb/include/defs.h
#
# Fix picking the wrong choice in resolving the conflict
#
git add src/arpifs/var/suscat.F90 
git commit --dry-run
#
# Oops, added a FIXME - don't forget to commit
#
git add src/mpa/micro/internals/rain_ice.F90
#
# Commit and push the result
#
git commit -m "20200623 Merge develop into pre-CY46h1"
git push
```
## Merge of CY46T1_bf.04 (20200615 - obsoleted by work from 20200804 onwards)
!ToMo: [changeset:4f9548/HarmoniePhasing 4f9548]
```bash
cd ~/HarmoniePhasing                                                         # The Location of the Harmonie phasing git clone on my system
git pull                                                                     # Update our pre-CY46h1 branch locally (which was previously checked out)
git remote add arpifs ssh://reader054@git.cnrm-game-meteo.fr/git/arpifs.git  # Establish the "French Connection"
git fetch arpifs master:mf-master                                            # Fetch their master branch
git checkout mf-master                                                       # Switch to that branch
git fetch arpifs CY46T1_bf.04:mf-CY46T1_bf.04                                # Fetch their CY46T1_bf.04 bug fix branch
git push origin mf-CY46T1_bf.04                                              # Push it to our repository for later use
git checkout pre-CY46h1                                                      # Switch to our pre-CY46h1 branch
git config merge.renameLimit 50000                                           # Set renaming limit for mergers
git merge -s recursive -Xsubtree=src mf-CY46T1_bf.04                         # Do the merge (note that their branch is in our subdirectory 'src')
```
For resolving the conflicts, I had to edit (and git add) the following files:
```bash
git add src/arpifs/obs_preproc/defrun.F90
git add src/arpifs/phys_dmn/apl_arome.F90
git add src/ifsobs/src/aux/hdf5_file_mod.F90 
git add src/ifsobs/src/dbase/hdf_dbase_mod.F90
git add src/odb/pandor/module/bator_decodbufr_mod.F90
git add src/surfex/ASSIM/assim_nature_isba_oi.F90
git add src/surfex/ASSIM/oi_cacsts.F90
git add src/surfex/SURFEX/coupling_surf_atmn.F90
git add src/surfex/SURFEX/mode_gridtype_conf_proj.F90
```
For compiling pandor, I had to add "iso_fortran_env" to the list of external modules (EXTMODS) in the makeup config file:
```bash
git add util/makeup/config.linux.gfortran.mpi
```
!ObsConvertInits.F90 contained carriage-return/line-feed line endings, which had to be converted to line-feeds to get makeup's module finder to work:
```bash
git add src/odb/pandor/module/ObsConvertInits.F90
```
This one really needs our updates - otherwise the HDF handling doesn't compile:
```bash
git add src/ifsobs/src/dbase/hdf_dbase_mod.F90
```
Add "private" for the abstract procedures:
```bash
git add src/odb/pandor/module/AbstractBufrReader.F90
```
"Deal" with aeolus' geom_to_geop height conversion:
```bash
git add src/odb/pandor/module/ObsConvertBufrToOdb.F90 src/odb/pandor/module/bator_decodbufr_mod.F90
```
Add various FIXME's
```bash
git add src/surfex/ASSIM/assim_nature_isba_oi.F90 src/surfex/SURFEX/coupling_surf_atmn.F90 src/surfex/SURFEX/mode_gridtype_conf_proj.F90
```
Commit the work and push it to the central server:
```bash
git commit -m "Merge Meteo France's CY46T1_bf.04 into our pre-CY46h1"
[pre-CY46h1 4f9548fb5] Merge Meteo France's CY46T1_bf.04 into our pre-CY46h1
```
```bash
git push
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
Enumerating objects: 133, done.
Counting objects: 100% (133/133), done.
Delta compression using up to 4 threads
Compressing objects: 100% (68/68), done.
Writing objects: 100% (68/68), 75.20 KiB | 4.18 MiB/s, done.
Total 68 (delta 60), reused 0 (delta 0), pack-reused 0
remote: warning: only found copies from modified paths due to too many files.
remote: warning: you may want to set your diff.renameLimit variable to at least 19637 and retry the command.
remote: Processing branch: refs/heads/pre-CY46h1
remote: Processed: 4f9548fb59224e0625029ab54d85d5f9ada504c8
To https://git.hirlam.org/HarmoniePhasing
   78bd67dad..4f9548fb5  pre-CY46h1 -> pre-CY46h1
```
Thanks for the warning - what now ?
```bash
git config diff.renameLimit 50000
git push
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
Everything up-to-date
```
No change ? So what is the warning about ?

## Work done during the System Working Week 20200504-08 and afterwards

|= Task =|= Comment =|= On It =|= Commit(s) =|= Status =|
| --- | --- | --- | --- | --- |
| Fullpos FIXME |  | |  |  |  
|Missing Water in Forecast |Norms of Water Components are Zero, suspect is FIXME in aro_rain_ice.F90/rain_ice_old.F90/aro_adjust.F90 | !UlAn | [changeset:9e9fa4b2/HarmoniePhasing 9e9fa4b2] | Partly fixed, The new interface to OLD4 is better checked by Karl-Ivar |
| Merge CY46T1_bf.03 | Merge done locally, some bator conflicts remains. Job for Eoin? | !UlAn | [changeset:80c48061/HarmoniePhasing 80c48061] | Fixed |  
|FIXME in APL_AROME | This FIXME fixed itself automagically | !ToMo | [changeset:3da378/HarmoniePhasing 3da378] | Fixed |
|FIXME in SU0YOMB | Take Theirs | !ToMo | [changeset:d38fb5/HarmoniePhasing d38fb5] | Fixed |
|FIXME in SUSPSDT | Obvious fix | !ToMo | [changeset:300e2c/HarmoniePhasing 300e2c] | Fixed |
|FIXME in INI_SPP and EVOLVE_SPP | Add YDMODEL argument to their argument lists | !ToMo | [changeset:df8d58/HarmoniePhasing df8d58] | Fixed |
|FIXME in CVAR2INAD | Remove code not in T version | !ToMo | [changeset:6a5d4d/HarmoniePhasing 6a5d4d] | Fixed |
|FIXME in SUSPSDT, round 2 | This needs a stochastic physics expert | !ToMo | | Waiting |
|FIXME in LITEST | Remove unused module variable SIMPLE | !ToMo | [changeset:2f025b/HarmoniePhasing 2f025b] | Fixed |
|FIXME in ADTEST | Correct actual argument lists of CAIN and CDSTA | !ToMo | [changeset:4d59e7/HarmoniePhasing 4d59e7] | Fixed |
|FIXME in BGPERT | Correct merge error: Take Theirs | !ToMo | [changeset:862cb8/HarmoniePhasing 862cb8] | Fixed |
|FIXME in fields_io_mod.F90 | Remove extraneous actual argument to ARO_SURF_DIAGH | !ToMo | [changeset:e5ff04/HarmoniePhasing e5ff04] | Fixed |
| Access to MF mirror from hlam@ecgb | Running as hlam on ecgate use "git clone ssh://mfgit/git/arpifs.git". See ~hlam/.ssh/config for ssh details. A clone is located under ~hlam/harmonie_release/git/mf_mirror/ |  !UlAn | N/A | Fixed | 
|Screening crashes in FGFER                 |Use of corrupted GOM (YGP5%TF) to calculate q,,sat,, causes crash |!EoWh |[changeset:b1fc7c/HarmoniePhasing b1fc7c] |Screening + 3D-Var now work for DKCOEXP - still have issues with 50x50 domain |
|Minim failing in hjo.F90                   |Issue with setting of ACTUAL_NDBIASCORR in hjo.F90                |!EoWh |[changeset:844abf/HarmoniePhasing 844abf] |Screening + 3D-Var now work for DKCOEXP - still have issues with 50x50 domain |
|CANARI completes but produces bad results  |Negative temperatures to be investigated  |  |  |  |
| When to updated to the level of develop? | Now! Incremental and controlled  |  |  | Done |
| Develop merged up to release-43h2.1.rc1 |  | !UlAn  | [changeset:903cda/Harmonie/ 903cda]  | Fixed |
| Reimplement and test SP fix | | | [changeset:903cda/Harmonie/ 903cda] | | 
| Reimplement and test Drop sonde fix | | | [changeset:610a9f/Harmonie/ 610a9f] | |
| Oulan reading has changed. Causes single obs setup to fail | | | | | 

## Configurations

|= Platform/Compiler         =|= Configuration    =|= Status =|
| --- | --- | --- |
|CentOS 8/GCC 8.3.1+OpenMPI   |AROME_FORECAST      |Works     |
|CentOS 8/GCC 8.3.1+OpenMPI   |AROME_3DVAR_FGCOPY  |Works but some print-outs missing in Screening |


## Mitraillette tests on cca
 * GMAPDOC: [MITRAILLETTE CY46T1](https://www.umr-cnrm.fr/gmapdoc/IMG/pdf/doc_mitraillette_v122018.pdf): ENVIRONNEMENT FILES AND USER’S GUIDE. VERSION v122018 available on [https://www.umr-cnrm.fr/gmapdoc/spip.php?article162](https://www.umr-cnrm.fr/gmapdoc/spip.php?article162)
 * Scripts and namelists:
```bash
$HM_LIB/src/validation/mitraille
#
# For example MUSC:
#
$HM_LIB/src/validation/mitraille/protojobs/L1_FCST_HYD_SL2_VFD_AROPHY1D.pjob
$HM_LIB/src/validation/mitraille/namelist/L1_FCST_HYD_SL2_VFD_AROPHY1D.nam
$HM_LIB/src/validation/mitraille//namelist/L1_FCST_HYD_SL2_VFD_AROPHY1D.selnam_exseg1
```

 * Reference data at ECMWF (Oct 2 2018):
```bash
ec:/hirlam/mitraillette/cy46_data
```
 * We are missing 
   * const/rrtm_cst/V02
   * const/ecoclimap/V8.0, probably not valid since we are running V8.1
 * We need a binary compiled the same way to compare T and H versions
 * Namelist changes from CY36 to date are documented in $HM_LIB/src/validation/mitraille/doc/history_difnam

 * [Test results ](./PhasingWithGit/Cycle46t1_bf.02/mitraillette_tests.md)


## Full Harmonie tests


|= Task               =|= Comment                                                                              =|= On it =|= Commit(s)                              =|= Status                                                          =|
| --- | --- | --- | --- | --- |
|Forecast with fullpos | Fails in fullpos setup. POSTP set to none for the time being.                          |         |                                          |!EoWh: Fullpos OK on local server but SURFEX_LSELECT is not        | 
|Canari                | ABORT!   10 CAREDO : ERROR 1                                                           |!EoWh    |[changeset:3df65f/HarmoniePhasing 3df65f] |!EoWh: issue avoided for now. Further investigation required.      |
|Screening             | BLINIT: INVALID USER SYMBOL(S) FOUND                                                   |         |[changeset:803453/HarmoniePhasing 803453] |FIXED     |
|Screening             | Crashed in src/arpifs/obs_preproc/gefger.F90 with SYNOP data (suspect ODB)             |!EoWh    |                                          |          |
|Minim                 | Fails in namelist reading: "Cannot match namelist object name lqscatt"                 |!EoWh    |[changeset:646b3e/HarmoniePhasing 646b3e] |FIXED     |
|Minim                 | Fails in hjo.F90                                                                       |         |                                          |          |
|Climate               | gl not reading/writing SURFEX FA correctly due to a bug in lficap. (PGD and PREP OK).  |         |[changeset:a46aca/HarmoniePhasing a46aca] |FIXED     |
|Forecast              | Fails in namelist reading                                                              |         |[changeset:ae44ec/HarmoniePhasing ae44ec] |FIXED     |
|LSmixBC               | ECHIEN ERROR : ECHIEN(..., KINF=1,...) HAS BEEN REPLACED BY ERIEN(...)                 |         |[changeset:e2906f/HarmoniePhasing e2906f] |FIXED     |

## Differences and unique files in theirs and ours

List of files only present in either theirs or our repository. The list does not include things not normally included in our repository (cope,scripts,obstat,scat,...). Since surfex is of different origin that's excluded as well. We need to find out if the missing files is correct and that extra files should be kept.

* [Differences vs CY46T1_bf.03](./PhasingWithGit/Cycle46t1_bf.02/Differences_vs_CY46T1_bf.03.md)
* [Unique CY64T1_bf.02](./PhasingWithGit/Cycle46t1_bf.02/unqique_mf.md)
* [Unique pre-CY46h1](./PhasingWithGit/Cycle46t1_bf.02/unqique_harmonie.md)

## Resolving FIXME

 * Still 23 files with FIXME 


|= Project      =|= Comment                              =|= Working on it =|= Commit(s) =|= Status =|
| --- | --- | --- | --- | --- |
|arpifs          |#ifdef FIXME, SPP changes ... |           |             | |
|arpifs          |#ifdef FIXME, YOMFPHOLD changes ... |            |             | |
|odb             |#ifdef FIXME - take changes from MF to make it compile | !ToMo     |[changeset:744ca9/HarmoniePhasing 744ca9] |FIXED |
|odb             |#ifdef FIXME - needs module CONTEXT from arpifs/cma2odb/context.F90 | !ToMo |[changeset:cfae86/HarmoniePhasing cfae86] |FIXED |
|mpa             |#ifdef FIXME - aro_adjust.F90 | !ToMo !UlAn (OK?) | [changeset:9e9fa4b2/HarmoniePhasing 9e9fa4b2] | Fixed |
|mpa             |#ifdef FIXME - aro_rain_ice.F90, rain_ice_old.F90 (LGRSN) | !UlAn | [changeset:9e9fa4b2/HarmoniePhasing 9e9fa4b2] | Fixed |


## Compile by project

By command line compilation with makeup we can "sort of" share the work. Make sure to have the right environment loaded.

```bash
make PROJ=crm
```
E.g., on Toon's laptop - running Debian Testing with gcc/gfortran 9.2 (assuming a 'build' directory next to !HarmoniePhasing):
```bash
(cd build; cp -Rv ../HarmoniePhasing/. .; ./util/makeup/configure config.linux.gfortran.mpi; cd src; make -f main.mk COPT= PROJ=crm)
```
(the COPT= is necessary to be able to build the output of the blacklist compiler).


|= Project      =|= Comment                                             =|= On it =|= Commit(s) =|= Status =|
| --- | --- | --- | --- | --- |
| aeolus         |                                                       |!ToMo    |N/A |DONE |
| aladin         |took utility/create_pert.F90|read_pert.F90 from theirs |!ToMo    |[changeset:69c305/HarmoniePhasing 69c305]|DONE |
| algor          |No changes needed                                      |!BeUl    | -  |DONE |
| arpifs         |Compiles with FIXME and FEMARS_OR_NOT ifdefs           |!EoWh    |    |DONE (I think). Checking full build now ...  |
| biper          |No changes needed                                      |!BeUl    | -  |DONE |
| blacklist      |No changes needed                                      |!BeUl    | -  |DONE |
| coupling       |No changes needed                                      |!BeUl    | -  |DONE |
| crm            |Interference with utilities/mten                       |!UlAn    |[changeset:8ac295/HarmoniePhasing 8ac295]   | DONE |
| ecfftw         |N/A .Makefile.ecfftw: No such file or directory        |         |    |DONE |
| etrans         |No changes needed                                      |!BeUl    | -  |DONE |
| ifsaux         |                                                       |         |    | DONE |
| ifsobs         |Integer type mods for HDF5                             |!BeUl    |[changeset:5eb5d1/HarmoniePhasing 5eb5d1] |DONE |
| mpa            |Some FIXME's left                                      |!ToMo    |[changeset:2bf4c8/HarmoniePhasing 2bf4c8], [changeset:6d54ba/HarmoniePhasing 6d54ba]|(almost) DONE |
| mse            |One fix.                                               |!ToMo    |[changeset:095551/HarmoniePhasing 095551]|DONE |
| obstat         |                                                       |!ToMo    |N/A |DONE |
| odb            |Some FIXME's left - now solved, see above              |!ToMo    |[changeset:3eada9/HarmoniePhasing 3eada9] |DONE |
| oopsifs        |                                                       |!ToMo    |N/A |DONE |
| oops_src       |                                                       |!ToMo    |N/A |DONE |
| radiation      |No changes needed                                      |!ToMo    | -  |DONE |
| satrad |Add h5lt to EXTMODS in makeup config file |!ToMo |[changeset:7ca33d/HarmoniePhasing 7ca33d] |DONE |
| scat | |!ToMo |N/A |DONE |
| surf |No changes needed |!ToMo | - |DONE |
| surfex | |!UlAn | | DONE |
| trans |No changes needed |!ToMo | - |DONE |
| utilities | |!UlAn | | DONE |
| validation | N/A | | | DONE |

## Resolving conflicts

Put your name on the project you're working on. Mark when done and comment if further action is required. If more fine grained structure is required add as appropriate.


|= Project      =|= # conflicts =|= Comment =|= Working on it =|= Commit(s) =|= Status =|
| --- | --- | --- | --- | --- | --- |
| aeolus         |       0    |OK                                                                   | !UlAn |N/A |DONE |
| aladin         |       0    |To be checked: coupling/eseimpls.F90: removed our fix introduced in changeset f1b18e to get cy43 running. | !BeUl | [changeset:3214d3/HarmoniePhasing 3214d3], [changeset:040cef/HarmoniePhasing 040cef]|DONE |
| algor          |       0    |Resolved: take theirs                                                |!ToMo  |[dcd7b6](https://hirlam.org/trac/changeset/dcd7b6b9a51fb27a251772ae5bfc69ae6f40b230/HarmoniePhasing) | DONE |
| arpifs/adiab   |       0    |Resolved. Take mostly theirs while trying to retain HIRLAM SPP code  |!EoWh  |[changeset:a8008d/HarmoniePhasing a8008d] |DONE |
| arpifs/ald_inc |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/c9xx    |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/canari  |       0    |Resolved. Take mostly theirs.                                        |!EoWh  |[changeset:cf7d63/HarmoniePhasing cf7d63] |DONE |
| arpifs/chem    |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/climate |       0    |Think I have taken care of LMCCECSST                                 |!EoWh  |[changeset:ae386d/HarmoniePhasing ae386d] |DONE |
| arpifs/cma2odb |       0    |Resolved: take theirs                                                |!EoWh  |[changeset:a11d61/HarmoniePhasing a11d61] |DONE |
| arpifs/common  |       0    |                                                                     |N/A    |N/A                                       |DONE |
| arpifs/control |       0    |Resolved: take mostly theirs trying to maintain Jan's LFORCE option  |!EoWh  |[changeset:a47ad5/HarmoniePhasing a47ad5] |DONE |
| arpifs/dfi     |       0    |OK                                                                   |!UlAn  |                                          |DONE |
| arpifs/dia     |       0    |Resolved: take theirs                                                |!EoWh  |[changeset:b86a28/HarmoniePhasing b86a28] |DONE |
| arpifs/fp_serv |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/fullpos |       0    |Resolved: take mostly theirs trying to maintain NMAXFPHOLD changes   |!EoWh  |[changeset:25adf9/HarmoniePhasing 25adf9] |DONE |
| arpifs/function |      0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/gbrad   |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/interpol |      0    |Resolved: take theirs                                                |!EoWh  |[changeset:6f513c/HarmoniePhasing 6f513c] |DONE |
| arpifs/io_serv |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/kalman  |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/module  |       0    |merge mostly theirs - tried to keep CVALPHA/Hybrid/Brand/SPP code    |!EoWh  |[changeset:7e25e8/HarmoniePhasing 7e25e8] |DONE |
| arpifs/mwave   |       0    |OK                                                                   |!UlAn  |                                          |DONE |
| arpifs/namelist |      0    |merge mostly theirs - tried to keep our Hybrid/SPP namelist vars     |!EoWh  |[changeset:6f6afb/HarmoniePhasing 6f6afb] |DONE |
| arpifs/nemo    |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/obs_error |     0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/obs_preproc |   0    |keep mostly theirs - keep our blacklisting/NASCAWVC changes          |!EoWh  |[changeset:3ea536/HarmoniePhasing 3ea536] |DONE |
| arpifs/ocean   |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/onedvar |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/oops    |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/op_obs  |       0    |take mostly theirs except minor PS change from us                    |!EoWh  |[changeset:bdd22a/HarmoniePhasing bdd22a] |DONE |
| arpifs/parallel |      0    |Think dot_product_ctlvec.F90 is taken care of                        |!EoWh  |[changeset:90ebda/HarmoniePhasing 90ebda] |DONE |
| arpifs/phys_dmn/ac*     |  156  |Take mostly theirs - watch out for actkezotls called from aplpar |!EoWh  |[changeset:48dc1b/HarmoniePhasing 48dc1b] |DONE |
| arpifs/phys_dmn/ap*-ch*  |  0  |NGFL_EZDIAG should be removed from ACRADIN calls in aplpar & apl_arome Check the call to ARO_ADJUST again!!!  |!UlAn | | |
| arpifs/phys_dmn/in*-mf* |  156  |NGFL_EZDIAG should be removed from ACRADIN calls in aplpar & apl_arome  |!UlAn  | | |
| arpifs/phys_dmn/su*-    |  0  |  |!BeUl  |[changeset:c358f9/HarmoniePhasing c358f9] |DONE |
| arpifs/phys_ec |       0    |OK                                                                   |!UlAn  |                                          |DONE |
| arpifs/phys_radi |     0    |Take mostly theirs, kept our SPP and EZDIAG mods                     |!BeUl  |[changeset:4401e4/HarmoniePhasing 4401e4] |DONE |
| arpifs/pp_obs  |       0    |take theirs                                                          |!EoWh  |[changeset:1511cf/HarmoniePhasing 1511cf] |DONE |
| arpifs/programs |      0    |OK                                                                   |!UlAn  |                                          |DONE |
| arpifs/raingg  |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/sekf    |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/setup   |       0    |take mostly their trying to keep our SPG changes                     |!EoWh  |[changeset:36c0a5/HarmoniePhasing 36c0a5] |DONE |
| arpifs/sinvect |       0    |Requires work with forced singular vectors - protected with #ifdef   |!EoWh  |[changeset:a93be7/HarmoniePhasing a93be7] |DONE |
| arpifs/smos    |       0    |OK                                                                   |!UlAn  |                                          |DONE |
| arpifs/transform |     0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| arpifs/utility |       0    |take theirs but kept our LMCCECSST/LDALPHA chanegs                   |!EoWh  |[changeset:62600a/HarmoniePhasing 62600a] |DONE |
| arpifs/var     |       0    |Eoin: take mostly theirs but keep our hybrid code                    |!EoWh  |[changeset:d7abe7/HarmoniePhasing d7abe7] |DONE |
| biper          |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| blacklist      |       0    |OK. Took theirs as HARMONIE no longer uses mf_blacklist.b            |!EoWh  |[changeset:d6b61b/HarmoniePhasing d6b61b] |DONE |
| coupling       |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| cope           |            |Not present in our repo                                              |N/A    |N/A                                       |DONE |
| crm            |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| ecfftw         |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| etrans         |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| ifsaux         |       0    |Tooks mostly theirs apart from sing prec changes in py_interface     |!EoWh  |[changeset:eb11fe/HarmoniePhasing eb11fe] |DONE |
| ifsobs         |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| mpa            |       0    | rain_ice[_old].F90 needs further work. New version introduced!                |!UlAn  |                                          |DONE |
| mpa/turb       |       0    |                                                                     |!UlAn  |                                          |DONE |
| mse            |       0    |Attempted to make ARO_SURF_DIAGH declaration, interface and calls consistent. Might be good to check SURFEX (de)allocation. This is done differently in our and MF's code (e.g . fp2sx2.F90, prep_stepx.F90 and suphmse_surface.F90) |!BeUl |[changeset:d5ee51/HarmoniePhasing d5ee51] |DONE |
| obstat         |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| odb            |       0    |Hope I didn't ruin Ole's JPRB->JPRD work                             |!EoWh  |[changeset:59adfb/HarmoniePhasing 59adfb], [changeset:414bb8/HarmoniePhasing 414bb8]  |DONE |
| oopsifs        |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| oops_src       |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| radiation      |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| satrad         |       0    |OK                                                                   |!EoWh  |[changeset:0e235e/HarmoniePhasing 0e235e] |DONE |
| scripts        |            |Not present in our repo                                              |N/A    |N/A                                       |DONE |
| scat           |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |
| surf           |       0    | OK | !UlAn | | |
| surfex         |       0    | Keep all our changes. MF still runs V8.0. Should be a walk in the park... | !UlAn | |DONE |
| trans          |       0    | OK | !UlAn  | | |
| utilities      |       0    | OK | !UlAn | | |
| validation     |       0    |N/A                                                                  |N/A    |N/A                                       |DONE |

