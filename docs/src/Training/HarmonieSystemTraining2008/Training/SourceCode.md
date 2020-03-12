```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Training/SourceCode?action=edit"
```

# Hands On Practice: Subversion tool

## Instructions or links to instructions

If you work on ecgate and cannot reach the hirlam.org Subversion server, you probably need to set the ECMWF web proxy in
~/.subversion/servers like this:
```bash
   cp ~nhz/.subversion/servers ~/.subversion/servers
```

## Practice tasks

### Basic Subversion: Making local changes to a tagged release

These tasks illustrate how to keep track of your changes, and how to upgrade between releases while keeping your modifications. 

 1. For online documentation use `svn help` and `svn help <subcommand>`.
 1. Locate the two most recently tagged Harmonie releases using `svn ls`. The flag `--verbose` gives more information. You can also use the Trac code browser.
 1. Check out the older of the two releases from the test repository at https://test.hirlam.org/ using `svn co`.
 1. The checked out directory is called a sandbox. `cd` into it. `svn info` will show some information about your sandbox.
 1. `svn log` will tell you the version history. It can be used on a file, a directory, a repository URL etc. The Trac code brower is often the most convenient way to review history and log messages. 
 1. `svn annotate` gives who and when changed which line in a file. Depending on your mood, `svn praise` or `svn blame` also works. 
 1. Change a few files! Verify that `svn status` identifies the changes. Try `svn diff`. The diff output may be used to send your modifications to the system maintainer.
 1. Create a new file. How is the new file listed in `svn status`? Tell Subversion about it with `svn add`, and check `svn status` again.
 1. Remove a file! What is the status? Recover the file with `svn update`.  To really remove a file, use `svn rm` instead!  What is the status now?
 1. Rename a file with `svn move`. Notice that a rename is implemented as a combined delete and add. 
 1. Try to migrate your changes to the newer release using `svn switch`. If the new release contains changes that collides with your own, you will have to resolve the conflicting changes manually, this will be illustrated later. But as long as the changes does not coincide, Subversion will handle them automatically. 
 1. Undo your modifications to one of the previously changed files. Verify that `svn status` does not list the file any more. 
 1. You can also undo your modifications with `svn revert`. Try that on another file.
 1. File removals can also be reverted. Try to recover your previously removed file, and verify the result with `svn status`.

### Intermediate Subversion use: Working on a branch

These tasks show how you can use a branch to store your changes to a release and how to upgrade your branch to a newer release.

 1. Create your own branch from a previous Harmonie release using  
```bash
  svn copy https://test.hirlam.org/tags/harmonie-<version>  https://test.hirlam.org/branches/<your-branch-name>
```
 1. Check out your new branch. 
 1. Modify some files and commit that change to the test repository. Write an appropriate log message. Unless you use the `-m` flag to provide the log message, the client will open the editor given by the environment variable `EDITOR`. Notice that the committed files disappear from the `svn status` output. Your changes are now in the repository.
 1. When several people work on a branch you can update your sandbox with their changes using `svn update`. This command can also be used to move a sandbox between different revisions. Test this by moving your sandbox to the revision before your recent commit with `svn update -r PREV`. With `svn update` can then be used to go back to the latest revision of your branch.
 1. In order to test what happens when there is a conflict, move your sandbox to the revision before your commit again. Now modify the same files you changed in step 2 and make sure you change the same lines as before in at least one of your new modifications. This time `svn update` will notice a conflict for the coinciding modification. With Subversion 1.5 you have the option either postpone (p) the conflict  or immediately edit (e). There are also other option available using `h`. If you postponed the conflict, you have to tell Subversion when you have corrected it using `svn resolved`.
 1. Sometimes you realize that you have to undo a previously committed change. This is done by merging the change in reverse, using `svn merge -c -<change set to undo> .`  Revert a previous change set and commit that to your test branch.
 1. The Hirlam CIS-branch at `/branches/cis` was recently deleted. When did that happen? How would you check out the CIS-branch now? 

### Advanced subversion use: More on merging 

This section describes how to maintain a feature branch using the merge tracking feature in Subversion 1.5.

 1. We currently do not use any feature branch for Harmonie, so this example is using the Hirlam newsnow branch instead. Check out the newsnow branch like this:
```bash
 svn co https://test.hirlam.org/branches/newsnow/hirlam newsnow
 cd newsnow 
```
 1. The change sets that previously has been merged into newsnow is stored in the svn:mergeinfo property: 
```bash
 svn pget svn:mergeinfo
```
 1. Use `svn mergeinfo` to see which change sets in /trunk/hirlam that are eligible for merging into newsnow:
```bash
 svn mergeinfo --show-revs eligible https://test.hirlam.org/trunk/hirlam
```
 1. Before attempting a large merge, you might want to test it first without actually making any changes using the `--dry-run` argument:
```bash
 svn merge --dry-run https://test.hirlam.org/trunk/hirlam
```
 1. The real merge can then be performed:
```bash
 svn merge https://test.hirlam.org/trunk/hirlam
```
 1. If you don't want to merge everything from trunk at once, use `-r` to limit the revision range:
```bash
 svn merge -r 6095:6109 https://test.hirlam.org/trunk/hirlam
```
 1. Finally resolve any eventual conflicts and commit the result. Please mention the merged trunk revision in the log message. However, for the benefit of others doing this exercise, please do not commit so that they can try the same merge. 

## [Back to the relevant lecture notes] (../../../HarmonieSystemTraining2008/Lecture/SourceCode.md)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)
