```@meta
EditURL="https://hirlam.org/trac//wiki//SourceCodeRepositoryTutorial/FeatureDevelopment?action=edit"
```
# Harmonie git repository tutorial - feature development

## Overview
This page is to provide a step by step tutorial on how to perform development of a feature for the Harmonie code, from the beginning to the publication on the public central Harmonie git repository. It is meant to be used in the context of a webinar.

Instead of the original public central **Harmonie** git repository, this tutorial makes use of of a dedicated repository called **!HarmonieTutorial**, in order to easier facillitate all development steps without affecting the original Harmonie repository. Another specific thing for this tutorial is the use of evironment variables like HUSER, SUSER. These are introduced in order to print commands with user specific names in a generic way.


## Introduction

The basic structure of working with [git](https://www.git-scm.com/) for revision control of source code includes three levels:


Working on these three levels happens locally.

Remote action is only necessary for sharing or publication:



## Preparations

* you should have sent your public ssh-key from your workstation to 'system-core@hirlam.org', in order to actively follow the tutorial

* Set your user name to your hirlam.org account
```bash
   export HUSER=<your hirlam.org user name>
```

* Create the user repository and !HarmonieTutorial fork, after your pub-key has been installed
```bash
   ssh git@hirlam.org fork HarmonieTutorial users/$HUSER/HarmonieTutorial
```

* Create the local user repository, including the remote link to the central public !HarmonieTutorial repository on hirlam.org, and check out the //develop// branch, which is the basis for the feature development work
```bash
   mkdir $HOME/HM/users/$HUSER
   cd $HOME/HM/users/$HUSER
   git clone git@hirlam.org:users/$HUSER/HarmonieTutorial HarmonieTutorial
   cd HarmonieTutorial

   git remote add public git@hirlam.org:HarmonieTutorial
   git remote -v
   git branch
   git checkout develop
```

* establish a basic local configuration for git (this creates or modifies $HOME/.gitconfig)
```bash
git config --global user.name <your name>
git config --global user.email <your email>
git config --global log.date iso
git config --global core.pager "less -FRSX"
git config --global core.whitespace trailing-space,space-before-tab
git config --global color.ui true
git config --global diff.renames copy
```

* establish some git aliases:
```bash
git config --global alias.dih "diff --cached"
git config --global alias.dwh "diff HEAD"
git config --global alias.dwi "diff"
```

* get the changesets for this tutorial

  a) if you work on a local computer, then download

     [changeset 1](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/SourceCodeRepositoryTutorial/FeatureDevelopment/1_cy43_turb_cld_conv.tar)

     [changeset 2](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/SourceCodeRepositoryTutorial/FeatureDevelopment/2_cy43_turb_cld_conv.tar)

     [changeset 3](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/SourceCodeRepositoryTutorial/FeatureDevelopment/3_cy43_turb_cld_conv.tar)

     and set the download path into an environment variable:
```bash
        export CHANGESET_PATH=<your local download path>
```

  b) if you work on ecgate, then set the following path into an environment variable:
```bash
        export CHANGESET_PATH=/home/ms/spsehlam/hlam/git_tutorial
```


## Feature Development

### *Basics*

Feature branch establishment:
```bash
   cd $HOME/HM/users/$HUSER/HarmonieTutorial
   git checkout develop
   git checkout -b cy43_wimfeat
   git log
```

the last command lists the commit history, where the newest commit ('HEAD') should point to snapshot
```bash
   dd6e920bc28889fcbb21908ff798dda94ff4b86f
```

Feature branch modifications:

* 1. modification
```bash
   git checkout cy43_wimfeat
   git status
   tar -xvf $CHANGESET_PATH/1_cy43_turb_cld_conv.tar
   git status
   git add nam scr src
   git status
```

* white-space-check of the modifications in the index (i.e. has just been staged for commit)
```bash
   git dih
```
  The listing should mark trailing and other unnecessary white spaces clearly within the diff listing (probably red blocks). Then take away these trailing and other unnecessary white spaces by manual editing
```bash
  vi src/arpifs/phys_dmn/apl_arome.F90
  vi src/arpifs/phys_dmn/vdfexcuhl.F90
  vi src/mpa/turb/internals/turb_ver_dyn_flux.F90
```
  and check the result of this action by listing the diff between working area and the index
```bash
   git dwi
```

  
* once the white spaces have been removed, add this to the index
```bash
   git add src
```

* commit 1. modifications
```bash
   git commit -s
```

   and specify the commit message in the upcomming editor session

* see your commit in the log history
```bash
   git log
```

  
* 2. and 3. modifications, where modifications 2 are just staged for commit (added to the index), but not committed yet, while modifications 3 are applied on the working area, but not added to the index
```bash
   git checkout cy43_wimfeat
   tar -xvf $CHANGESET_PATH/2_cy43_turb_cld_conv.tar
   git add .
   tar -xvf $CHANGESET_PATH/3_cy43_turb_cld_conv.tar
   git status
```
   then see the changes related to the 2. modifications for file *scr/forecast_model_settings.sh*
```bash
   git dih scr/forecast_model_settings.sh
```
   and then see the changes related to the 3. modifications
```bash
   git dwi scr/forecast_model_settings.sh
```
   and now see the changes related to both the 2. and the 3. modifications
```bash
   git dwh scr/forecast_model_settings.sh
```
   use the same commands, respectively, without the file name in order to list the changes in all modified files

  
* commit modifications 2, and this time the commit message is provided right away:
```bash
   git commit -s -m "2_cy43_turb_cld_conv"
```

* commit modifications 3
```bash
   git status
   git add .
   git status
   git commit -s
```

* include new upstream updates in the feature branch (for this tutorial, a certain historic state is used):
```bash
   git checkout develop
   git pull -t public develop
   git push origin develop
   git push --tags origin develop
   git log
```
  'git log' lists the updated history, and the latest commit ('HEAD') should point to snapshot
```bash
   9c9c100f1fb4085247e9740f5f0c10e22ca8e73b
```
   then continue with ```merge```:
```bash
   git checkout cy43_wimfeat
   git merge develop
```
   git reports a conflict, so check the status
```bash
   git status
```
   the listing should show all automerged files in the index, and the conflicting files within the working area. In this example, there should be one conflict:

    | [[Color(red, deleted by them:    sms/config_exp.h)]] |
| --- |
  address it as follows: restore the deleted 'config_exp.h' under 'sms/', and manually introduce the differences into 'ecf/config_exp.h'
```bash
   git add sms/config_exp.h
   vi -d sms/config_exp.h ecf/config_exp.h
```
  
```bash
    * line 226 (ecf/config_exp.h) "# *** For member specific settings use suites/harmonie.pm ***"
    * all diffs relating to ENSMFAIL and ENSMDAFAIL (lines 234, 235 and 483 of sms/config_exp.h - do NOT take them over to ecf/config_exp.h
```

  When done (check the diffs carefully, and take only those diffs over to 'ecf/config_exp.h', which relate to your feature), finalise the merge process
```bash
   git add ecf/config_exp.h
   git rm sms/config_exp.h
   git status
   git commit -s
```
  In the upcomming editor session add some information about that this conflict resolution moves your feature changes from sms/config_exp.h over to the new ecf/config_exp.h


  Now check the commit history in the following way:
```bash
   git log
```

  As you updated the feature branch using ```merge```, the latest commit should be a merge commit.


## Feature Publishing

-1- Prepare some important information concerning your update:

   * Name of the feature branch, and from where it was branched-off
   * Description of the set of modifications (including new options, namelist settings etc.)
   * List of the relevant feature commits to pull (in the above example, this would be all the three commits that have been added)
   * If applicable: Instructions on gathering multiple feature commits (which of the above listed relevant feature commits to gather into one, and the common message for these)

-2- Get latest up-stream changes, incorporate them, and re-organize all feature commits:
```bash
   git checkout develop
   git pull public develop
   git --no-pager log --reverse --pretty=tformat:'%h  %ai  %s' -n 10
```
  this alternative way of showing commit history lists the updated history, but only the last ten commits from top downwards, and the latest commit ('HEAD') should point to snapshot
```bash
   7afa1cc52  2019-06-20 10:54:01 +0000  Eoin: some Bator changes/corrections
```
then go on
```bash
   git push origin develop
   git checkout cy43_wimfeat
   git merge develop
```
   the upcomming conflict then looks like


   | [[Color(red, both modified:      ecf/config_exp.h)]] |
| --- |

   to resolve it: open ecf/config_exp.h, find the lines that start with "<<<<<<< HEAD", and select the code version of the 'develop', i.e. remove the code block that starts with "case $MAKEUP". Don't forget to also remove the conflict markers, i.e. the lines that start with "<<<<<<<", "=======" or with ">>>>>>>". When done, finalize the ```merge```:
```bash
   git add ecf/config_exp.h
   git commit -s
```

```bash
      149f4ce  2019-06-20 10:47:49 +0000  Ulf Andrae: Remove last references to mSMS + additional cleaning
```


-3- Once the update of your feature branch is complete, further prepare the pull-request by pushing to your user repository for sharing with system-core
```bash
   git push origin cy43_wimfeat
```

-4- Sent to 'system-core@hirlam.org' your pull-request including information gathered in step 1.

-5- Once the pull-request has been processed, update your repositories:
```bash
   git checkout develop
   git pull -t public develop-$HUSER
   git push origin develop
   git push --tags origin develop
```

Note that only for this tutorial the pull is done from //develop-$HUSER// instead of just //develop//. Usually, the pull would be from //develop//.

-6- Then clean-up the obsolete feature branches in your repositories:
```bash
   git branch -D cy43_wimfeat
   git push origin :cy43_wimfeat
```



## Some final remarks

  * try to avoid white space changes, they can provide much confusion

  * if you are unsure about an action and its consequences within your branch, you can branch-off from your branch into a temporary testing branch, and if you srcew things up, then just reset to the latest HEAD (clean-up index and working area), switch back to your original branch, and remove the temporary testing branch



## Cleaning the tutorial repository

Once not needed any more, the user repository for **!HarmonieTutorial** on hirlam.org can be removed in the following way:
```bash
   ssh git@hirlam.org D unlock users/$HUSER/HarmonieTutorial
   ssh git@hirlam.org D rm users/$HUSER/HarmonieTutorial
```



----


