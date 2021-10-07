```@meta
EditURL="https://hirlam.org/trac//wiki//SourceCodeRepository/PublishFeatureOnly?action=edit"
```
# '''Developer Instructions to contribute code

## Overview
This page provides instructions on how to provide contributions to the Harmonie develop branch. Much of the information in this page is copied directly from [SourceCodeRepository](./SourceCodeRepository.md).

## User Access

In general, all users with access to hirlam.org have read access to the central public Harmonie repository, but only the system-core staff is granted write access. In order to facilitate repository sharing for all users, each user can establish a user repository, and a *fork* of the official repositories like the Harmonie repository.

## Create a Fork #forking

A fork of the Harmonie git repository is just a clone of the repo on hirlam.org, but optimizing storage resource use. On hirlam.org, the fork is established within the users repository area 'users/${HIRLUSER}'. In order to perform the forking, ssh access is necessary:

{{{#!sh
export HIRLUSER=<your_hirlam_username>
ssh git@hirlam.org fork Harmonie users/${HIRLUSER}/Harmonie
```

Unfortunately, users don't have ssh access to 'git' on hirlam.org, unless a public ssh key is being provided and registered. The corresponding personal ssh key has to be used then in order to execute the above ssh command, and in case this one is not the default ssh key on the user's local system, it has to be provided via ssh option `-i`.

Once the fork is established, the user can clone from this [#shareduserrepo user repository]: [=#forkclone]

{{{#!sh
git clone https://git.hirlam.org/users/${HIRLUSER}/Harmonie $HOME/repo/users/${HIRLUSER}/Harmonie
```

Either of these commands establishes the repository on the local filesystem, with the *origin* pointing to the user's repository. So *pushing* will happen onto the //user repository//, and not onto the public repository. Nevertheless, the //user repository// is generally readable for all users on hirlam.org.
> It is important to note that the forked repository on hirlam.org is *not* automatically updated with updates from the original repository

Updating your forked repository on hirlam.org happens through your local repository, and this is controlled by yourself. In order to be able to do this, however, your local repository needs to be explicitly //connected// to the public repository by establishment of a *remote*:

{{{#!sh
cd $HOME/repo/users/${HIRLUSER}/Harmonie
git remote add public https://git.hirlam.org/Harmonie
```

Check the list of *remotes* within your local user repo by: [=#remotelist]

{{{#!sh
git remote -v
```

This should then show a listing like:
```bash
origin	https://git.hirlam.org/users/${HIRLUSER}/Harmonie (fetch)
origin	https://git.hirlam.org/users/${HIRLUSER}/Harmonie (push)
public	https://git.hirlam.org/Harmonie (fetch)
public	https://git.hirlam.org/Harmonie (push)
```
where *origin* points to your own user repository, and *public* points to the central public repository. 

Updating of for example the `develop` branch within your fork on hirlam.org would then be done as follows: [=#updatefork]
{{{#!sh
cd $HOME/repo/users/${HIRLUSER}/Harmonie
git checkout develop
git pull public develop
git push origin develop
```

## Local Development #localdev
### create your feature branch

A feature branch is created with:
{{{#!sh
git checkout develop
git checkout -b develop_${HIRLUSER}_myFeatureName
```

After checkout of branch `develop`, this creates branch develop_${HIRLUSER}_myFeatureName on basis of the latest status of branch `develop` within your local Harmonie git repository. Here the cycle number 'dd' would take the number for the cycle that is represented by branch `develop`. At the time of writing, this is cycle 43.

If you want to make sure that you don't miss the very latest official changes to `develop` before branching off, then update `develop` first, and if your local repo is cloned from your [#forking fork], then [#updatefork update your fork branch first]. Then apply the update locally and branch-off:

{{{#!sh
git checkout develop
git pull origin develop
git checkout -b develop_${HIRLUSER}_myFeatureName
```

### update your feature branch #updatefeaturebranch

In case you have existing feature branches, which have been branched-off from branch `develop` or any of [#branches the other cycle development branches (CY'nn')], then you should update
each feature branch every time after you have updated `develop` or CY'nn' with changes from the public repository, respectively. Updating for example your local `develop` branch would look like (assume [#forking the forking structure]):

{{{#!sh
git checkout develop
git pull public develop
```


A feature branch can then be updated as follows:

{{{#!sh
git checkout develop_${HIRLUSER}_myFeatureName
git merge develop
```

The merge may result in merge conflicts, if your local feature changes conflict with upstream changes. You have to resolve the conflicts in order to finish the update, see [git documantation](http://git-scm.com/book/en/v2) or the manual pages for details. The merge process usually creates a merge commit, unless the merge results in a simple *fast-forward*, and all feature commits you did within your feature branch are retained **as is**

### publish your feature branch

In order for a development to become officially public on the central public Harmonie repository, the commits related to that development have to be pushed to the central public repository. So instead of directly pushing to the central public Harmonie repository, following procedure applies:

 * update your feature branch to include the latest official upstream changes under `develop` from the central public repository:
   * update `develop` locally and on your user repository
     {{{#!sh
git checkout develop
git pull public develop
git push origin develop
```
   * merge the upstream changes into your feature branch
     {{{#!sh
git checkout develop_${HIRLUSER}_myFeatureName
git merge develop
```
     and resolve possible conflicts. The risk for conflicts at this stage is minimized, if you have [#updatefeaturebranch updated the feature branch] regularly
   * [#sharing share] your feature branch via your user repository
     {{{#!sh
git push origin develop_${HIRLUSER}_myFeatureName
```

 * notify the system core group (system-core at hirlam.org) and request them to pull from your feature branch into the central public branch `develop`. The request should provide following information:
   * the name of your feature branch
   * indication on whether to gather the feature commits into a single one (squashing into one commit)
   * for the System Core gang:
       {{{#!sh
cd ${HOME}/repo/central/Harmonie
git checkout develop
git checkout -b develop_${HIRLUSER}_myFeatureName
git pull https://git.hirlam.org/users/${HIRLUSER}/Harmonie develop_${HIRLUSER}_myFeatureName
git rebase develop
# inspect/test this branch as required
git checkout develop
git merge develop_${HIRLUSER}_myFeatureName
# if you are happy with the merge, then push!
git push
```

 * after system-core has published your feature on the public `develop` branch, you can update your local `develop` branch, as well as on your user repository:
     {{{#!sh
git checkout develop
git pull public develop
git push origin develop
```
    so now your have gotten your feature back in its published form, and your own feature branch has become obsolete.

### delete your feature branch #deletefeaturebranch

 * delete your feature branch in order to avoid any confusion in the future (we assume that your feature branch has no other extra commits than those that have been published). Remove it both locally and on your user repository at hirlam.org:
     {{{#!sh
git branch -D develop_${HIRLUSER}_myFeatureName
git push origin :develop_${HIRLUSER}_myFeatureName
```

----


