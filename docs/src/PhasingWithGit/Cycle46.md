```@meta
EditURL="https://hirlam.org/trac//wiki//PhasingWithGit/Cycle46?action=edit"
```
# Cycle 46 phasing information using our git repository

**[Please use this for the continued work with CY46](./PhasingWithGit/Cycle46t1_bf.02.md)**

# Introduction

This page specifies the steps undertaken to merge Cycle CY46T1_r1.04 into our git repository.

Cycle Master: Toon Moene.

# Telesession by Kai and Toon on the 7th of October 2019

## Get the phasing repository
```bash
-bash-4.1$ mkdir HM
-bash-4.1$ cd HM
-bash-4.1$ git clone https://git.hirlam.org/HarmoniePhasing
Cloning into 'HarmoniePhasing'...
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
remote: Counting objects: 215129, done.
remote: Compressing objects: 100% (44288/44288), done.
remote: Total 215129 (delta 170328), reused 212713 (delta 167914)
Receiving objects: 100% (215129/215129), 383.62 MiB | 6.41 MiB/s, done.
Resolving deltas: 100% (170328/170328), done.
Checking out files: 100% (20897/20897), done.
-bash-4.1$ cd HarmoniePhasing/
-bash-4.1$ ls
config-sh  const  ecf  msms  nam  scr  sms  src  util
```
## Check out the needed branches
```bash
-bash-4.1$ for b in mf-master mf-CY44 mf-CY46 develop; do git checkout $b; done
Checking out files: 100% (38345/38345), done.
Branch mf-master set up to track remote branch mf-master from origin.
Switched to a new branch 'mf-master'
Checking out files: 100% (6796/6796), done.
Branch mf-CY44 set up to track remote branch mf-CY44 from origin.
Switched to a new branch 'mf-CY44'
Checking out files: 100% (6796/6796), done.
Branch mf-CY46 set up to track remote branch mf-CY46 from origin.
Switched to a new branch 'mf-CY46'
Checking out files: 100% (34307/34307), done.
Branch develop set up to track remote branch develop from origin.
Switched to a new branch 'develop'
```
## Add needed remotes
```bash
-bash-4.1$ git remote add public https://git.hirlam.org/Harmonie
-bash-4.1$ git remote add toon https://git.hirlam.org/users/toon/Harmonie
-bash-4.1$ git remote add ksa https://git.hirlam.org/users/ksa/Harmonie
```
## Pull in the develop branch
```bash
-bash-4.1$ git pull -t public develop
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 7 (delta 6), reused 0 (delta 0)
Unpacking objects: 100% (7/7), done.
From https://git.hirlam.org/Harmonie
 * branch                develop    -> FETCH_HEAD
 * [new branch]          develop    -> public/develop
Updating eab22bcf1..fb3c8cb34
Fast-forward
 scr/MARS_get_bd   | 33 ++-------------------------------
 scr/MARS_prepare  |  7 +++----
 scr/functions.ksh |  7 -------
 scr/pp_marsreq.pl | 10 ++++++++--
 4 files changed, 13 insertions(+), 44 deletions(-)
```
Check it's the right one
```bash
-bash-4.1$ git branch
* develop
  master
  mf-CY44
  mf-CY46
  mf-master
```
and double check the log ...
```bash
-bash-4.1$ git log 
commit fb3c8cb343ef9d5520e98ed22c749281ca2d423e
Author: Ulf Andrae <ulf.andrae@smhi.se>
Date:   Sun Oct 6 19:49:13 2019 +0000

    Ulf Andrae: Fixes for broken IFSENS MARS retrieval

commit eab22bcf10739b2789137e3b2ea15632b0d44310
Author: Ulf Andrae <ulf.andrae@smhi.se>
Date:   Fri Oct 4 11:21:28 2019 +0000
```
OK.
## Push the result back to hirlam.org
```bash
-bash-4.1$ git push --tags origin develop
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
Counting objects: 7, done.
Delta compression using up to 32 threads.
Compressing objects: 100% (7/7), done.
Writing objects: 100% (7/7), 894 bytes | 0 bytes/s, done.
Total 7 (delta 6), reused 0 (delta 0)
To https://git.hirlam.org/HarmoniePhasing
   eab22bcf1..fb3c8cb34  develop -> develop
```
## Check out Meteo France's CY44 branch
This establishes a common "departure point" for the merging.
```bash
-bash-4.1$ git checkout mf-CY44
Checking out files: 100% (33270/33270), done.
Switched to branch 'mf-CY44'
Your branch is up-to-date with 'origin/mf-CY44'.
```
Check whether we are at the right branch
```bash
-bash-4.1$ git branch
  develop
  master
* mf-CY44
  mf-CY46
  mf-master
```
Double check to see the last commit:
```bash
-bash-4.1$ git --no-pager log --reverse --pretty=tformat:'%C(yellow)%h%Creset  %ai  %s  %C(yellow)%d%Creset'
...
c64751ed2  2017-03-15 12:22:39 +0000  Last changes from ECMWF upon CY43T2_r3.09 .   (HEAD -> mf-CY44, tag: CY44, tag: CY43T2_r3.10, origin/mf-CY44)
```
## Check out Meteo France's CY46 branch
```bash
-bash-4.1$ git checkout mf-CY46
Checking out files: 100% (6796/6796), done.
Switched to branch 'mf-CY46'
Your branch is up-to-date with 'origin/mf-CY46'.
```
Check the last commit:
```bash
-bash-4.1$ git --no-pager log --reverse --pretty=tformat:'%C(yellow)%h%Creset  %ai  %s  %C(yellow)%d%Creset'
...
b3049dac4  2018-04-09 11:25:02 +0000  Protect some code changes (introduced in CY45T1_r1.01) by key LECMWF.   (HEAD -> mf-CY46, tag: CY46, tag: CY45T1_r1.06, origin/mf-master, origin/mf-CY46, mf-master)
```
## Check out our 'develop' branch
```bash
-bash-4.1$ git checkout develop
Checking out files: 100% (34307/34307), done.
Switched to branch 'develop'
Your branch is up-to-date with 'origin/develop'.
```
## Check out the pre-CY46 branch from it
```bash
-bash-4.1$ git checkout -b pre-CY46
Switched to a new branch 'pre-CY46'
```
## Merge the Meteo France CY44 branch with our pre-CY46 branch
First, check the commit that defines the common base:
```bash
-bash-4.1$ git merge-base HEAD CY44
dc3e0b908cec164d86ab298982dbcd254709c528
```
and check it in the 'git log'.

Now do the merge:
```bash
-bash-4.1$ git merge -m "merge up to mf-tag-CY44, strategy ours" -s ours CY44
Merge made by the 'ours' strategy.
```
and check the last commit:
```bash
-bash-4.1$ git --no-pager log --reverse --pretty=tformat:'%C(yellow)%h%Creset  %ai  %s  %C(yellow)%d%Creset'  
...
b47f407a1  2019-10-07 09:31:51 +0000  merge up to mf-tag-CY44, strategy ours   (HEAD -> pre-CY46)
```
Correct.
## Merge the Meteo France CY46 branch with our pre-CY46 branch
First, check the commit that defines the common base:
```bash
-bash-4.1$ git merge-base HEAD CY46
c64751ed2a44d15ee35cd8107a4ebe41c07f0478
```
and check it in the 'git log'.

Do the merge - and note the problem of not tracking all renamed files:
```bash
-bash-4.1$ git merge --no-ff -s recursive -Xsubtree=src CY46
...
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your merge.renamelimit variable to at least 3612 and retry the command.
Automatic merge failed; fix conflicts and then commit the result.
-bash-4.1$ 
```
It fails because of the unresolved conflicts - to be dealt with later.

So we have to redo the merge with *all renames*  .... First reset the pre-CY46 branch
```bash
-bash-4.1$ git reset --hard
Checking out files: 100% (6141/6141), done.
HEAD is now at b47f407a1 merge up to mf-tag-CY44, strategy ours
```
We need a larger buffer for rename detection:
```bash
-bash-4.1$ git config merge.renameLimit 5000
```
Redo the merge
```bash
-bash-4.1$ git merge --no-ff -s recursive -Xsubtree=src CY46 2>&1 | tee merge-CY46.log
```
[ See the 400K output as attachment 'merge-CY46.log' below. ]

and check the last commit:
```bash
-bash-4.1$ git --no-pager log --reverse --pretty=tformat:'%C(yellow)%h%Creset  %ai  %s  %C(yellow)%d%Creset'
...
b3049dac4  2018-04-09 11:25:02 +0000  Protect some code changes (introduced in CY45T1_r1.01) by key LECMWF.   (HEAD -> mf-CY46, tag: CY46, tag: CY45T1_r1.06, origin/mf-master, origin/mf-CY46, mf-master)
```
See what the results are:
```bash
git status
```
[ See the 400K output as attachment 'status-CY46.log' below. ]
## Add files with conflicts to the index
We want to commit the merge with the conflicts, so that they can be resolved in parallel
by several people in our pre-CY46 branch.

Check if you can add a conflicted file to the index:
```bash
-bash-4.1$ git add src/satrad/module/rttov_unix_env.F90
-bash-4.1$ git diff --cached src/satrad/module/rttov_unix_env.F90
```
Yes, it worked.
So now we add the files that have conflicts:
```bash
-bash-4.1$ git status | grep "both modified:" | wc -l
1547
-bash-4.1$ for f in $(git status | grep "both modified:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ git status | grep "both modified:" | wc -l
0
```
Done !
## Add the other files that we want to commit
```bash
-bash-4.1$ for f in $(git status | grep "deleted by us:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ for f in $(git status | grep "deleted by them:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ for f in $(git status | grep "both added:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ for f in $(git status | grep "added by us:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ for f in $(git status | grep "added by them:" | cut -f 2 -d :); do git add $f; done
-bash-4.1$ for f in $(git status | grep "both deleted:" | cut -f 2 -d :); do git rm $f; done
src/aeolus/BUFR_file_handling/l1b_bufrutil.F90: needs merge
rm 'src/aeolus/BUFR_file_handling/l1b_bufrutil.F90'
src/aeolus/BUFR_tables/B0000000000098026002.TXT: needs merge
rm 'src/aeolus/BUFR_tables/B0000000000098026002.TXT'
src/aeolus/BUFR_tables/D0000000000098026002.TXT: needs merge
rm 'src/aeolus/BUFR_tables/D0000000000098026002.TXT'
src/odb/cma2odb/context.F90: needs merge
rm 'src/odb/cma2odb/context.F90'
src/odb/cma2odb/parconst.F90: needs merge
rm 'src/odb/cma2odb/parconst.F90'
src/odb/cma2odb/yomper.F90: needs merge
rm 'src/odb/cma2odb/yomper.F90'
src/odb/cma2odb/yomstdin.F90: needs merge
rm 'src/odb/cma2odb/yomstdin.F90'
src/odb/cma2odb/yomwt.F90: needs merge
rm 'src/odb/cma2odb/yomwt.F90'
```
What is the status now ?
```bash
-bash-4.1$ git status
On branch pre-CY46
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)

< ... all correct ... >

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	src/ifsaux/py_interface/mode_searchgrp.F90~HEAD
```
This untracked file is there by a "unhistoric" commit - just remove it.
```bash
-bash-4.1$ rm src/ifsaux/py_interface/mode_searchgrp.F90~HEAD
```
## Committing the pre-CY46 branch with unresolved conflicts
```bash
-bash-4.1$ git commit -s
-bash-4.1$ git commit --amend # Amend the commit message to be more explicit what we have done
```
## Push the results to hirlam.org
```bash
-bash-4.1$ git branch
  develop
  master
  mf-CY44
  mf-CY46
  mf-master
* pre-CY46
-bash-4.1$ git push origin pre-CY46
Username for 'https://git.hirlam.org': toon
Password for 'https://toon@git.hirlam.org': 
Counting objects: 2266, done.
Delta compression using up to 32 threads.
Compressing objects: 100% (2253/2253), done.
Writing objects: 100% (2266/2266), 2.12 MiB | 1.40 MiB/s, done.
Total 2266 (delta 1982), reused 0 (delta 0)
To https://git.hirlam.org/HarmoniePhasing
 * [new branch]          pre-CY46 -> pre-CY46
```
Herewith the work is done.


# How to proceed from here
How to get the new branch:
```bash
git clone git@hirlam.org:HarmoniePhasing
```
or
```bash
git clone https://git.hirlam.org/HarmoniePhasing
```
Then:
```bash
cd HarmoniePhasing
git checkout pre-CY46
```
Do not touch the pre-CY46 branch directly:
```bash
git checkout -b ${USER}-CY46 # So that work can be shared.
```
Looking for conflicts:
```bash
cd src
git grep '>>>>>>>'
git grep -l '>>>>>>>' | wc -l # number of files with conflicts
1567
```
Example: aladin/adiab/elarmes.F90:123
```bash
<<<<<<< HEAD
TYPE(GEOMETRY), INTENT(INOUT)    :: YDGEOMETRY
=======
TYPE(GEOMETRY), INTENT(IN)       :: YDGEOMETRY
TYPE(MODEL_DYNAMICS_TYPE),INTENT(IN):: YDML_DYN
TYPE(TRIP)     ,INTENT(IN)       :: YDRIP
>>>>>>> CY46
```
Define remotes:
```bash
git remote add public git@hirlam.org:Harmonie # or: git remote add public https://git.hirlam.org/HarmoniePhasing
git remote add arpifs ssh://reader054@git.cnrm-game-meteo.fr/git/arpifs.git
```
Optional checkouts, for comparison:
```bash
git checkout develop
git checkout mf-CY44
git checkout mf-CY46
git checkout mf-master
```


----


