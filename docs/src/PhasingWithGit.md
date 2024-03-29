```@meta
EditURL="https://hirlam.org/trac//wiki//PhasingWithGit?action=edit"
```
# Phasing information using our git repository

# Introduction

This page describes how to merge a T(oulouse) Cycle of the HARMONIE source code into our git repository.

[ The git commands described herein were provided by Kai Sattler]

# Establish the phasing repo

## Create a local repo from your Harmonie fork on hirlam.org
```bash
git clone git@hirlam.org:users/<your username>/Harmonie $HOME/repo/users/<your username>/Harmonie
cd $HOME/repo/users/<your username>/Harmonie
```

## Create remotes to the central public Harmonie repo and to the MF arpifs repo
```bash
git remote add public git@hirlam.org:Harmonie
git remote add arpifs ssh://reader054@mfgit/git/arpifs.git
```
For the latter remote designation to work, you will have to add the following to your ~/.ssh/config:
```bash
Host mfgit
  Hostname git.cnrm-game-meteo.fr
  User <your registered name at mfgit>
  IdentityFile ~/.ssh/<your registered ssh-key>
```

# Establish the branches for the merge procedure

## Assure your develop branch is up-top-date
```bash
git checkout develop
git pull public develop
git push origin develop
```

## Branch-off the new cycle branch
```bash
git checkout -b pre-CYnm
```

## Get relevant MF branches
```bash
git fetch arpifs master:mf-master
git checkout mf-master
git fetch arpifs CYnmT1.0x:mf-CYnmT1.0x
git checkout mf-CYnmT1.0x
```

# Prepare for the branch comparison

## Create a repo copy for easier comparison of branches
```bash
rsync --delete -avHc $HOME/repo/users/<your username>/Harmonie $HOME/repo/users/<your username>/Harmonie.wrk
```
## Move to the new cycle branch
```bash
git checkout pre-CYnm
```
## Possibility to see diffs between branches pre-CYnm and mf-CYnmT1.0x by comparing
```bash
$HOME/repo/users/<your username>/Harmonie, which represents pre-CYnm
$HOME/repo/users/<your username>/Harmonie.wrk, which represents mf-CYnmT1.0x
```
and asking for assistance


# Start the merge

## Find the latest common ancestors
```bash
git merge-base pre-CYnm mf-master
git merge-base pre-CYnm mf-CYnmT1.0x
```
## Perform merge within in git
```bash
git checkout pre-CYnm
git merge mf-CYnmT1.0x
```
All simple auto-merges are directly added to the index (staging area for commit), the conflicing files remain in the working area.

Perform conflict resolution on the "obvious" conflicts (i.e., those that do not necessitate subject knowledge), and add the resolved files to the index
```bash
git add <resolved file>
```
## Postpone all other conflicts
```bash
git -?
```

# While there are non-obvious conflicts

## Try to resolve them with expert help, then add to the index
```bash
git add <resolved file>
```
## Occasionally merge develop into the pre-CYnm branch

THIS IS NOT POSSIBLE RIGHT AWAY, because the unfinished branch pre-CYnm blocks your phasing repo for other work, especially due to the pending conflicts.

If you absolutely want/need to do this, then  create two preliminary commits:

### Re-commit the resolved files
```bash
git commit -s -m "pre-commit merge mf-CYnmT1.0x resolved"
```
### "Resolve" somehow all conflicts in a preliminary way, and pre-commit them
```bash
git add .
git commit -s -m "pre-commit merge mf-CYnmT1.0x resolved"
```
BUT NOTE: you might run into new conflicts when trying to merge newer updates from develop branch!

# If no conflicts remain, perform a final merge of develop into pre-CYnm
```bash
git commit -s
```

# Perform a merge of pre-CYnm into develop and declare the merge of CYnmT1.0x complete

## Merge into your local develop
```bash
git checkout develop
git merge pre-CYnm
```
## Tag the merge
```bash
git tag -a -m "merge mf-CYnmT1.0x" CYnmh1
```
## Publish the merge with the tag into the public develop
```bash
git push --tags public develop
```

# Cycle specific adaptations of this procedure

* [Cycle 46h1](./PhasingWithGit/Cycle46t1_bf.02.md)
* [Cycle 46](./PhasingWithGit/Cycle46.md)


----


