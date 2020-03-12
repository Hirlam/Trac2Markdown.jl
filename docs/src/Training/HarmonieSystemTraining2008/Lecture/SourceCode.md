```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Lecture/SourceCode?action=edit"
```

# HARMONIE source code management, use of Subversion tool

## Subversion tool

```bash
~> svn help
usage: svn <subcommand> [options] [args]
Subversion command-line client, version 1.5.2.
Type 'svn help <subcommand>' for help on a specific subcommand.
Type 'svn --version' to see the program version and RA modules
  or 'svn --version --quiet' to see just the version number.

Most subcommands take file and/or directory arguments, recursing
on the directories.  If no arguments are supplied to such a
command, it recurses on the current directory (inclusive) by default.

Available subcommands:
   add
   blame (praise, annotate, ann)
   cat
   changelist (cl)
   checkout (co)
   cleanup
   commit (ci)
   copy (cp)
   delete (del, remove, rm)
   diff (di)
   export
   help (?, h)
   import
   info
   list (ls)
   lock
   log
   merge
   mergeinfo
   mkdir
   move (mv, rename, ren)
   propdel (pdel, pd)
   propedit (pedit, pe)
   propget (pget, pg)
   proplist (plist, pl)
   propset (pset, ps)
   resolve
   resolved
   revert
   status (stat, st)
   switch (sw)
   unlock
   update (up)
```
## Hirlam/Harmonie repository
 * https://svn.hirlam.org/
 * Trac code browser: https://trac.hirlam.org/browser
## Tagged releases, branches, vendor branches
```bash
   trunk/
      hirlam/
      harmonie/
         config-sh/
         const/
         msms/
         nam/
         scr/
         sms/
         src/
         util/
      contrib/
         metgraf/
 
  tags/
      harmonie-31h1/
      harmonie-32h2/
      harmonie-32h3/
      harmonie-33h0/
      harmonie-33h1/
      hirlam-7.0/
      hirlam-7.0.1/
      hirlam-7.0beta1/
      hirlam-7.0rc1/
      hirlam-7.1/
      hirlam-7.1.1/
      hirlam-7.1.2/
      hirlam-7.1.3/
      hirlam-7.1.4/
  
   branches/
      harmonie-31h1/
      hirlam-7.0/
      hirlam-7.1/
      hirlam-7.2/
      newsnow/
      rttov8/
      openmp/
      smhi-operational/
      dmi-operational/
  
   vendor/
      aladin/
         current/
         cy33t0/
         cy33t0_t1.02/
         cy33t1/
         cy33t1_r2.03/
         cy34/
         cy35/
      gmkpack/
         6.2.2/
         6.2.3/
         6.2.4/
         6.3.0/
         6.3.1/
         6.3beta13/
         current/
```

## Use of basic svn features
## Code update/revision procedure; How to submit changesets
## [Hands on practice task] (../../../HarmonieSystemTraining2008/Training/SourceCode.md)
 * https://test.hirlam.org/
## Reference links
 * Subversion home page http://subversion.tigris.org/
 * Subversion book (complete online) http://svnbook.red-bean.com/

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)